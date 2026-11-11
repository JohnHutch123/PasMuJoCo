{ PasMuJoCo smoke test: load the MuJoCo library, load a model, step it.

  Usage: SmokeTest [path-to-model.xml] [path-to-mujoco-library]
  Exit code 0 when everything worked.

  Copyright 2026 John Hutchings
  Licensed under the Apache License, Version 2.0 (see LICENSE). }

program SmokeTest;

{$i PasMuJoCo.inc}
{$apptype console}

uses
{$ifdef fpc}
  SysUtils, Math,
{$else}
  System.SysUtils, System.Math,
{$endif}
  PasMuJoCo;

var
  ModelFile, LibraryFile: string;
  Error: array[0..1023] of AnsiChar;
  m: PmjModel;
  d: PmjData;
  i: Integer;
  qpos: PmjtNum;
  Angle0: mjtNum;
begin
  // MuJoCo's C code expects IEEE default behaviour (NaN/Inf, no traps)
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow,
    exUnderflow, exPrecision]);

  ModelFile := ExtractFilePath(ParamStr(0)) + '..' + PathDelim + 'models' + PathDelim +
    'pendulum.xml';
  if ParamCount >= 1 then
    ModelFile := ParamStr(1);
  LibraryFile := MuJoCoLibraryName;
  if ParamCount >= 2 then
    LibraryFile := ParamStr(2);

  if not LoadMuJoCoLibrary(LibraryFile) then
  begin
    WriteLn('FAIL: ', MuJoCoLastError);
    Halt(1);
  end;
  WriteLn('MuJoCo ', mj_versionString(), ' loaded');

  FillChar(Error, SizeOf(Error), 0);
  m := mj_loadXML(PAnsiChar(AnsiString(ModelFile)), nil, @Error[0], SizeOf(Error));
  if m = nil then
  begin
    WriteLn('FAIL: could not load ', ModelFile, ': ', PAnsiChar(@Error[0]));
    Halt(1);
  end;
  WriteLn('model: nq=', m^.nq, ' nv=', m^.nv, ' nu=', m^.nu, ' nbody=', m^.nbody,
    ' timestep=', m^.opt.timestep:0:4);

  d := mj_makeData(m);
  qpos := d^.qpos;
  qpos^ := 0.5;                     // start the pendulum at 0.5 rad
  Angle0 := qpos^;
  for i := 1 to 1000 do
    mj_step(m, d);
  WriteLn('after 1000 steps: time=', d^.time:0:3, ' angle=', qpos^:0:5);

  if (Abs(d^.time - 1000 * m^.opt.timestep) > 1e-9) or (qpos^ = Angle0) or IsNan(qpos^) then
  begin
    WriteLn('FAIL: simulation did not advance as expected');
    Halt(1);
  end;

  WriteLn('body 1 name: ', mj_id2name(m, mjOBJ_BODY, 1));
  WriteLn('geom type of "rod": ', m^.geom_type[mj_name2id(m, mjOBJ_GEOM, 'rod')]);

  mj_deleteData(d);
  mj_deleteModel(m);
  UnloadMuJoCoLibrary;
  WriteLn('OK');
end.
