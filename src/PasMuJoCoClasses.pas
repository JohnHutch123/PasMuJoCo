{ PasMuJoCoClasses - thin object wrappers over the PasMuJoCo header.

  Copyright 2026 John Hutchings
  Licensed under the Apache License, Version 2.0 (see LICENSE).

  TMjModel owns an mjModel, TMjData owns an mjData. Both expose the raw
  pointer through Handle, so anything not wrapped here can still be done
  with the plain API:  mj_forward(Model.Handle, Data.Handle).

  Typical use:

    MuJoCoInitialize;                       // load library, set up FPU and errors
    Model := TMjModel.CreateFromXML('pendulum.xml');
    Data := TMjData.Create(Model);
    try
      Data.Ctrl[0] := 0.5;
      Data.Step;
    finally
      Data.Free;                            // free data before its model
      Model.Free;
    end; }

unit PasMuJoCoClasses;

{$i PasMuJoCo.inc}

interface

uses
{$ifdef fpc}
  SysUtils, Math,
{$else}
  System.SysUtils, System.Math,
{$endif}
  PasMuJoCo;

type
  // Raised for load and compile errors, bad indices, and (once
  // MuJoCoInitialize installed the handler) MuJoCo's own fatal errors. After
  // a fatal MuJoCo error, call Reset on the TMjData involved before stepping
  // it again, because MuJoCo stopped part-way through its computation.
  EMuJoCo = class(Exception);

  TMjModel = class
  private
    FHandle: PmjModel;
    FOwnsHandle: Boolean;
    function GetTimestep: mjtNum;
    procedure SetTimestep(const AValue: mjtNum);
    function GetSize(AIndex: Integer): Int64;
  public
    // Load and compile an MJCF or URDF file.
    constructor CreateFromXML(const AFileName: string);
    // Compile a model from MJCF text held in memory.
    constructor CreateFromXMLString(const AXML: string);
    // Load a compiled binary model (.mjb).
    constructor CreateFromBinary(const AFileName: string);
    // Wrap an existing mjModel. With AOwnsHandle, Destroy deletes it.
    constructor CreateFromHandle(AHandle: PmjModel; AOwnsHandle: Boolean);
    destructor Destroy; override;

    // Deep copy of the model.
    function Clone: TMjModel;
    // Save as a compiled binary model (.mjb).
    procedure SaveBinary(const AFileName: string);

    // Object id for a name, or -1 if there is no such object.
    function NameToId(AObjType: mjtObj; const AName: string): Integer;
    // Object name for an id, or '' if it has none.
    function IdToName(AObjType: mjtObj; AId: Integer): string;

    property Handle: PmjModel read FHandle;
    property OwnsHandle: Boolean read FOwnsHandle write FOwnsHandle;
    property Timestep: mjtNum read GetTimestep write SetTimestep;

    // Model sizes (see mjModel in the MuJoCo docs)
    property nq: Int64 index 0 read GetSize;          // generalized coordinates
    property nv: Int64 index 1 read GetSize;          // degrees of freedom
    property nu: Int64 index 2 read GetSize;          // controls
    property na: Int64 index 3 read GetSize;          // activation states
    property nbody: Int64 index 4 read GetSize;
    property njnt: Int64 index 5 read GetSize;
    property ngeom: Int64 index 6 read GetSize;
    property nsite: Int64 index 7 read GetSize;
    property nsensor: Int64 index 8 read GetSize;
    property nsensordata: Int64 index 9 read GetSize;
    property nkey: Int64 index 10 read GetSize;       // keyframes
    property nmocap: Int64 index 11 read GetSize;
  end;

  TMjData = class
  private
    FModel: TMjModel;
    FHandle: PmjData;
    function GetTime: mjtNum;
    procedure SetTime(const AValue: mjtNum);
    function Element(AArray: PmjtNum; ACount: Int64; AIndex: Integer;
      const AName: string): PmjtNum;
    function GetQPos(AIndex: Integer): mjtNum;
    procedure SetQPos(AIndex: Integer; const AValue: mjtNum);
    function GetQVel(AIndex: Integer): mjtNum;
    procedure SetQVel(AIndex: Integer; const AValue: mjtNum);
    function GetCtrl(AIndex: Integer): mjtNum;
    procedure SetCtrl(AIndex: Integer; const AValue: mjtNum);
    function GetAct(AIndex: Integer): mjtNum;
    procedure SetAct(AIndex: Integer; const AValue: mjtNum);
    function GetSensorData(AIndex: Integer): mjtNum;
  public
    // Allocate simulation data for AModel. The model must outlive this object.
    constructor Create(AModel: TMjModel);
    destructor Destroy; override;

    // Advance the simulation by one timestep.
    procedure Step; overload;
    // Advance by ACount timesteps.
    procedure Step(ACount: Integer); overload;
    // Two-phase step: Step1, then set controls/forces, then Step2.
    procedure Step1;
    procedure Step2;
    // Forward dynamics without integrating (updates positions, contacts, sensors...).
    procedure Forward;
    // Inverse dynamics: qfrc_inverse from qacc.
    procedure Inverse;
    // Reset to the model's default state (qpos0, zero velocities, time 0).
    procedure Reset;
    // Reset to keyframe AKey (0 .. Model.nkey-1).
    procedure ResetKeyframe(AKey: Integer);

    property Model: TMjModel read FModel;
    property Handle: PmjData read FHandle;
    property Time: mjtNum read GetTime write SetTime;
    // Range-checked access to the main state and control vectors.
    property QPos[AIndex: Integer]: mjtNum read GetQPos write SetQPos;
    property QVel[AIndex: Integer]: mjtNum read GetQVel write SetQVel;
    property Ctrl[AIndex: Integer]: mjtNum read GetCtrl write SetCtrl;
    property Act[AIndex: Integer]: mjtNum read GetAct write SetAct;
    property SensorData[AIndex: Integer]: mjtNum read GetSensorData;
  end;

// Load the MuJoCo library (raising EMuJoCo with the reason on failure), mask
// floating-point exceptions as MuJoCo's C code expects, and, with
// AInstallErrorHandler, turn MuJoCo's fatal errors into EMuJoCo exceptions
// instead of letting MuJoCo end the process. Safe to call more than once.
procedure MuJoCoInitialize(const ALibraryName: string = MuJoCoLibraryName;
  AInstallErrorHandler: Boolean = True);

// Mask all floating-point exceptions on the calling thread. MuJoCoInitialize
// does this for the main thread; call it at the start of any other thread
// that runs MuJoCo.
procedure MuJoCoMaskFPUExceptions;

implementation

const
  ErrorBufferSize = 1024;

function ToMj(const S: string): UTF8String; inline;
begin
  Result := UTF8String(S);
end;

function FromMj(P: PAnsiChar): string;
begin
  if P = nil then
    Result := ''
  else
    Result := string(UTF8String(P));
end;

procedure RequireLibrary;
begin
  if not MuJoCoLibraryLoaded then
    raise EMuJoCo.Create('MuJoCo library not loaded; call MuJoCoInitialize first');
end;

procedure MuJoCoErrorHandler(msg: PAnsiChar); cdecl;
begin
  raise EMuJoCo.Create('MuJoCo error: ' + FromMj(msg));
end;

procedure MuJoCoMaskFPUExceptions;
begin
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow,
    exUnderflow, exPrecision]);
end;

procedure MuJoCoInitialize(const ALibraryName: string; AInstallErrorHandler: Boolean);
begin
  MuJoCoMaskFPUExceptions;
  if not LoadMuJoCoLibrary(ALibraryName) then
    raise EMuJoCo.Create(MuJoCoLastError);
  if AInstallErrorHandler and (mju_user_error <> nil) then
    mju_user_error^ := MuJoCoErrorHandler;
end;

{ TMjModel }

constructor TMjModel.CreateFromXML(const AFileName: string);
var
  Error: array[0..ErrorBufferSize - 1] of AnsiChar;
begin
  inherited Create;
  RequireLibrary;
  FillChar(Error, SizeOf(Error), 0);
  FHandle := mj_loadXML(PAnsiChar(ToMj(AFileName)), nil, @Error[0], SizeOf(Error));
  if FHandle = nil then
    raise EMuJoCo.CreateFmt('Could not load model "%s": %s', [AFileName, FromMj(@Error[0])]);
  FOwnsHandle := True;
end;

constructor TMjModel.CreateFromXMLString(const AXML: string);
var
  Error: array[0..ErrorBufferSize - 1] of AnsiChar;
  Spec: PmjSpec;
  Msg: string;
begin
  inherited Create;
  RequireLibrary;
  FillChar(Error, SizeOf(Error), 0);
  Spec := mj_parseXMLString(PAnsiChar(ToMj(AXML)), nil, @Error[0], SizeOf(Error));
  if Spec = nil then
    raise EMuJoCo.Create('Could not parse model XML: ' + FromMj(@Error[0]));
  try
    FHandle := mj_compile(Spec, nil);
    if FHandle = nil then
    begin
      Msg := FromMj(mjs_getError(Spec));
      raise EMuJoCo.Create('Could not compile model XML: ' + Msg);
    end;
  finally
    mj_deleteSpec(Spec);
  end;
  FOwnsHandle := True;
end;

constructor TMjModel.CreateFromBinary(const AFileName: string);
begin
  inherited Create;
  RequireLibrary;
  FHandle := mj_loadModel(PAnsiChar(ToMj(AFileName)), nil);
  if FHandle = nil then
    raise EMuJoCo.CreateFmt('Could not load binary model "%s"', [AFileName]);
  FOwnsHandle := True;
end;

constructor TMjModel.CreateFromHandle(AHandle: PmjModel; AOwnsHandle: Boolean);
begin
  inherited Create;
  if AHandle = nil then
    raise EMuJoCo.Create('TMjModel.CreateFromHandle: nil handle');
  FHandle := AHandle;
  FOwnsHandle := AOwnsHandle;
end;

destructor TMjModel.Destroy;
begin
  if FOwnsHandle and (FHandle <> nil) and Assigned(mj_deleteModel) then
    mj_deleteModel(FHandle);
  FHandle := nil;
  inherited;
end;

function TMjModel.Clone: TMjModel;
var
  NewHandle: PmjModel;
begin
  NewHandle := mj_copyModel(nil, FHandle);
  if NewHandle = nil then
    raise EMuJoCo.Create('Could not copy model');
  Result := TMjModel.CreateFromHandle(NewHandle, True);
end;

procedure TMjModel.SaveBinary(const AFileName: string);
begin
  mj_saveModel(FHandle, PAnsiChar(ToMj(AFileName)), nil, 0);
end;

function TMjModel.NameToId(AObjType: mjtObj; const AName: string): Integer;
begin
  Result := mj_name2id(FHandle, AObjType, PAnsiChar(ToMj(AName)));
end;

function TMjModel.IdToName(AObjType: mjtObj; AId: Integer): string;
begin
  Result := FromMj(mj_id2name(FHandle, AObjType, AId));
end;

function TMjModel.GetTimestep: mjtNum;
begin
  Result := FHandle^.opt.timestep;
end;

procedure TMjModel.SetTimestep(const AValue: mjtNum);
begin
  FHandle^.opt.timestep := AValue;
end;

function TMjModel.GetSize(AIndex: Integer): Int64;
begin
  case AIndex of
    0: Result := FHandle^.nq;
    1: Result := FHandle^.nv;
    2: Result := FHandle^.nu;
    3: Result := FHandle^.na;
    4: Result := FHandle^.nbody;
    5: Result := FHandle^.njnt;
    6: Result := FHandle^.ngeom;
    7: Result := FHandle^.nsite;
    8: Result := FHandle^.nsensor;
    9: Result := FHandle^.nsensordata;
    10: Result := FHandle^.nkey;
    11: Result := FHandle^.nmocap;
  else
    Result := 0;
  end;
end;

{ TMjData }

constructor TMjData.Create(AModel: TMjModel);
begin
  inherited Create;
  if (AModel = nil) or (AModel.Handle = nil) then
    raise EMuJoCo.Create('TMjData.Create: no model');
  FModel := AModel;
  FHandle := mj_makeData(AModel.Handle);
  if FHandle = nil then
    raise EMuJoCo.Create('Could not allocate mjData');
end;

destructor TMjData.Destroy;
begin
  if (FHandle <> nil) and Assigned(mj_deleteData) then
    mj_deleteData(FHandle);
  FHandle := nil;
  inherited;
end;

procedure TMjData.Step;
begin
  mj_step(FModel.Handle, FHandle);
end;

procedure TMjData.Step(ACount: Integer);
var
  i: Integer;
begin
  for i := 1 to ACount do
    mj_step(FModel.Handle, FHandle);
end;

procedure TMjData.Step1;
begin
  mj_step1(FModel.Handle, FHandle);
end;

procedure TMjData.Step2;
begin
  mj_step2(FModel.Handle, FHandle);
end;

procedure TMjData.Forward;
begin
  mj_forward(FModel.Handle, FHandle);
end;

procedure TMjData.Inverse;
begin
  mj_inverse(FModel.Handle, FHandle);
end;

procedure TMjData.Reset;
begin
  mj_resetData(FModel.Handle, FHandle);
end;

procedure TMjData.ResetKeyframe(AKey: Integer);
begin
  if (AKey < 0) or (AKey >= FModel.nkey) then
    raise EMuJoCo.CreateFmt('Keyframe %d out of range (model has %d)', [AKey, FModel.nkey]);
  mj_resetDataKeyframe(FModel.Handle, FHandle, AKey);
end;

function TMjData.GetTime: mjtNum;
begin
  Result := FHandle^.time;
end;

procedure TMjData.SetTime(const AValue: mjtNum);
begin
  FHandle^.time := AValue;
end;

function TMjData.Element(AArray: PmjtNum; ACount: Int64; AIndex: Integer;
  const AName: string): PmjtNum;
begin
  if (AIndex < 0) or (AIndex >= ACount) then
    raise EMuJoCo.CreateFmt('%s index %d out of range 0..%d', [AName, AIndex, ACount - 1]);
  Result := @AArray[AIndex];
end;

function TMjData.GetQPos(AIndex: Integer): mjtNum;
begin
  Result := Element(FHandle^.qpos, FModel.nq, AIndex, 'qpos')^;
end;

procedure TMjData.SetQPos(AIndex: Integer; const AValue: mjtNum);
begin
  Element(FHandle^.qpos, FModel.nq, AIndex, 'qpos')^ := AValue;
end;

function TMjData.GetQVel(AIndex: Integer): mjtNum;
begin
  Result := Element(FHandle^.qvel, FModel.nv, AIndex, 'qvel')^;
end;

procedure TMjData.SetQVel(AIndex: Integer; const AValue: mjtNum);
begin
  Element(FHandle^.qvel, FModel.nv, AIndex, 'qvel')^ := AValue;
end;

function TMjData.GetCtrl(AIndex: Integer): mjtNum;
begin
  Result := Element(FHandle^.ctrl, FModel.nu, AIndex, 'ctrl')^;
end;

procedure TMjData.SetCtrl(AIndex: Integer; const AValue: mjtNum);
begin
  Element(FHandle^.ctrl, FModel.nu, AIndex, 'ctrl')^ := AValue;
end;

function TMjData.GetAct(AIndex: Integer): mjtNum;
begin
  Result := Element(FHandle^.act, FModel.na, AIndex, 'act')^;
end;

procedure TMjData.SetAct(AIndex: Integer; const AValue: mjtNum);
begin
  Element(FHandle^.act, FModel.na, AIndex, 'act')^ := AValue;
end;

function TMjData.GetSensorData(AIndex: Integer): mjtNum;
begin
  Result := Element(FHandle^.sensordata, FModel.nsensordata, AIndex, 'sensordata')^;
end;

end.
