{ Tests for PasMuJoCoClasses (TMjModel, TMjData, MuJoCoInitialize).

  Usage: ClassesTest [path-to-pendulum.xml] [path-to-mujoco-library]
  Exit code 0 when every check passes.

  Copyright 2026 John Hutchings
  Licensed under the Apache License, Version 2.0 (see LICENSE). }

program ClassesTest;

{$i PasMuJoCo.inc}
{$apptype console}

uses
{$ifdef fpc}
  SysUtils,
{$else}
  System.SysUtils, System.IOUtils,
{$endif}
  PasMuJoCo, PasMuJoCoClasses;

const
  // pendulum with a sensor and two keyframes, compiled from memory
  SensorXML =
    '<mujoco model="sensored">' +
    '  <option timestep="0.001"/>' +
    '  <worldbody>' +
    '    <body name="arm" pos="0 0 1">' +
    '      <joint name="hinge" type="hinge" axis="0 1 0"/>' +
    '      <geom name="rod" type="capsule" fromto="0 0 0 0 0 -0.5" size="0.02" mass="1"/>' +
    '    </body>' +
    '  </worldbody>' +
    '  <actuator><motor name="m" joint="hinge"/></actuator>' +
    '  <sensor><jointpos name="angle" joint="hinge"/></sensor>' +
    '  <keyframe>' +
    '    <key name="rest" qpos="0"/>' +
    '    <key name="tilted" qpos="1.25"/>' +
    '  </keyframe>' +
    '</mujoco>';

var
  Failures: Integer = 0;
  Checks: Integer = 0;

procedure Check(ACondition: Boolean; const AWhat: string);
begin
  Inc(Checks);
  if ACondition then
    WriteLn('  ok    ', AWhat)
  else
  begin
    Inc(Failures);
    WriteLn('  FAIL  ', AWhat);
  end;
end;

// Run AProc and check that it raises EMuJoCo whose message contains AText.
type
  TTestProc = procedure;

procedure CheckRaises(AProc: TTestProc; const AText, AWhat: string);
var
  Raised: Boolean;
  Msg: string;
begin
  Raised := False;
  Msg := '';
  try
    AProc();
  except
    on E: EMuJoCo do
    begin
      Raised := True;
      Msg := E.Message;
    end;
  end;
  Check(Raised and (Pos(AText, Msg) > 0), AWhat + ' (' + Msg + ')');
end;

{$ifdef MSWINDOWS}
function GetConsoleProcessList(lpdwProcessList: PCardinal; dwProcessCount: Cardinal): Cardinal;
  stdcall; external 'kernel32.dll';

// True when this program got its own console window (started from Explorer
// or the IDE) rather than running inside an existing command prompt.
function OwnsConsole: Boolean;
var
  Ids: array[0..1] of Cardinal;
begin
  Result := GetConsoleProcessList(@Ids[0], 2) <= 1;
end;
{$endif}

// Keep the console window open long enough to read the results.
procedure Finish(AExitCode: Integer);
begin
{$ifdef MSWINDOWS}
  if OwnsConsole{$ifndef fpc} or (DebugHook <> 0){$endif} then
  begin
    Write('Press Enter to close...');
    ReadLn;
  end;
{$endif}
  Halt(AExitCode);
end;

var
  PendulumFile, LibraryFile, BinaryFile: string;
  Model, Model2, Cloned: TMjModel;
  Data: TMjData;
  Angle: mjtNum;

procedure LoadMissingFile;
begin
  TMjModel.CreateFromXML('does-not-exist.xml').Free;
end;

procedure LoadBadXML;
begin
  TMjModel.CreateFromXMLString('<mujoco><worldbody><geom type="nosuchtype"/></worldbody></mujoco>').Free;
end;

procedure QPosOutOfRange;
begin
  Data.QPos[5] := 1;
end;

procedure BadKeyframe;
begin
  Data.ResetKeyframe(7);
end;

procedure RaiseMuJoCoError;
begin
  mju_error('deliberate test error');
end;

procedure LoadBadLibrary;
begin
  MuJoCoInitialize('no-such-mujoco-library');
end;

procedure RunTests;
begin
  PendulumFile := ExtractFilePath(ParamStr(0)) + 'pendulum.xml';
  if ParamCount >= 1 then
    PendulumFile := ParamStr(1);
  LibraryFile := MuJoCoLibraryName;
  if ParamCount >= 2 then
    LibraryFile := ParamStr(2);

  WriteLn('initialisation');
  CheckRaises(LoadBadLibrary, 'Could not load', 'a missing library is reported as EMuJoCo (this error is expected)');
  MuJoCoInitialize(LibraryFile);
  Check(MuJoCoLibraryLoaded, 'MuJoCoInitialize loads MuJoCo ' + string(mj_versionString()));
  MuJoCoInitialize(LibraryFile);
  Check(MuJoCoLibraryLoaded, 'second MuJoCoInitialize is harmless');

  WriteLn('TMjModel from file');
  Model := TMjModel.CreateFromXML(PendulumFile);
  try
    Check((Model.nq = 1) and (Model.nv = 1) and (Model.nu = 1) and (Model.nbody = 2),
      'pendulum sizes nq=1 nv=1 nu=1 nbody=2');
    Check(Abs(Model.Timestep - 0.002) < 1e-12, 'timestep 0.002');
    Check(Model.NameToId(mjOBJ_GEOM, 'rod') >= 0, 'NameToId finds geom "rod"');
    Check(Model.NameToId(mjOBJ_GEOM, 'missing') = -1, 'NameToId returns -1 for unknown name');
    Check(Model.IdToName(mjOBJ_BODY, 1) = 'pole', 'IdToName(body 1) = pole');

    WriteLn('TMjData');
    Data := TMjData.Create(Model);
    try
      Data.QPos[0] := 0.5;
      Data.Step(1000);
      Check(Abs(Data.Time - 2.0) < 1e-9, 'Step(1000) advances time to 2.0');
      Check(Abs(Data.QPos[0] - (-0.22238)) < 1e-4, 'pendulum angle matches smoke test');
      CheckRaises(QPosOutOfRange, 'out of range', 'QPos[5] raises EMuJoCo');
      Data.Reset;
      Check((Data.Time = 0) and (Data.QPos[0] = 0), 'Reset returns to time 0, qpos 0');
      Data.Ctrl[0] := 0.3;
      Data.Step;
      Check(Data.QVel[0] <> 0, 'Ctrl drives the motor');
      CheckRaises(RaiseMuJoCoError, 'deliberate test error',
        'mju_error raises EMuJoCo instead of exiting');
      Data.Reset;
      Data.Step;
      Check(Data.Time > 0, 'simulation still runs after a MuJoCo error');
    finally
      Data.Free;
    end;

    WriteLn('Clone and binary round trip');
    Cloned := Model.Clone;
    try
      Check((Cloned.Handle <> Model.Handle) and (Cloned.nq = Model.nq), 'Clone makes a separate copy');
    finally
      Cloned.Free;
    end;
{$ifdef fpc}
    BinaryFile := IncludeTrailingPathDelimiter(GetTempDir) + 'pasmujoco_test.mjb';
{$else}
    BinaryFile := TPath.Combine(TPath.GetTempPath, 'pasmujoco_test.mjb');
{$endif}
    Model.SaveBinary(BinaryFile);
    Model2 := TMjModel.CreateFromBinary(BinaryFile);
    try
      Check((Model2.nq = 1) and (Model2.IdToName(mjOBJ_BODY, 1) = 'pole'),
        'SaveBinary / CreateFromBinary round trip');
    finally
      Model2.Free;
      DeleteFile(BinaryFile);
    end;
  finally
    Model.Free;
  end;

  WriteLn('TMjModel from XML string');
  Model := TMjModel.CreateFromXMLString(SensorXML);
  try
    Check((Model.nkey = 2) and (Model.nsensordata = 1), 'two keyframes, one sensor value');
    Data := TMjData.Create(Model);
    try
      Data.ResetKeyframe(1);
      Data.Forward;
      Check(Abs(Data.SensorData[0] - 1.25) < 1e-12, 'ResetKeyframe(1) + Forward: sensor reads 1.25');
      CheckRaises(BadKeyframe, 'out of range', 'ResetKeyframe(7) raises EMuJoCo');
      Angle := Data.QPos[0];
      Data.Step(100);
      Check(Data.QPos[0] <> Angle, 'model compiled from a string simulates');
    finally
      Data.Free;
    end;
  finally
    Model.Free;
  end;

  WriteLn('load errors');
  CheckRaises(LoadMissingFile, 'does-not-exist.xml', 'missing file raises EMuJoCo');
  CheckRaises(LoadBadXML, 'nosuchtype', 'invalid XML raises EMuJoCo with MuJoCo''s message');

  UnloadMuJoCoLibrary;
end;

begin
  try
    RunTests;
  except
    on E: Exception do
    begin
      // an exception nothing above expected: report it instead of closing
      Inc(Failures);
      WriteLn('  FAIL  unexpected ', E.ClassName, ': ', E.Message);
    end;
  end;
  WriteLn(Checks, ' checks, ', Failures, ' failures');
  if Failures > 0 then
    Finish(1);
  Finish(0);
end.
