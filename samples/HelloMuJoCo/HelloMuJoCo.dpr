{ HelloMuJoCo - smallest useful PasMuJoCo program.

  Loads a pendulum, holds it at 45 degrees with a PD controller for one
  second, then lets it swing freely, printing the angle as it goes.

  Usage: HelloMuJoCo [model.xml]
  Default model: pendulum.xml next to the executable (copy it from
  tests/models). mujoco.dll / libmujoco.so must be findable.

  Copyright 2026 John Hutchings
  Licensed under the Apache License, Version 2.0 (see LICENSE). }

program HelloMuJoCo;

{$i PasMuJoCo.inc}
{$apptype console}

uses
{$ifdef fpc}
  SysUtils,
{$else}
  System.SysUtils,
{$endif}
  PasMuJoCo, PasMuJoCoClasses;

const
  Target = Pi / 4;      // hold angle, radians
  Kp = 20.0;            // proportional gain
  Kd = 2.0;             // derivative gain

var
  ModelFile: string;
  Model: TMjModel;
  Data: TMjData;
  NextPrint: Double;
begin
  try
    ModelFile := ExtractFilePath(ParamStr(0)) + 'pendulum.xml';
    if ParamCount >= 1 then
      ModelFile := ParamStr(1);

    MuJoCoInitialize;
    WriteLn('MuJoCo ', mj_versionString());

    Model := TMjModel.CreateFromXML(ModelFile);
    try
      Data := TMjData.Create(Model);
      try
        WriteLn(Format('%s: %d dof, %d actuator(s), timestep %.4f s',
          [ModelFile, Model.nv, Model.nu, Model.Timestep]));
        NextPrint := 0;
        while Data.Time < 3.0 do
        begin
          if Data.Time < 1.0 then
            Data.Ctrl[0] := Kp * (Target - Data.QPos[0]) - Kd * Data.QVel[0]
          else
            Data.Ctrl[0] := 0;   // released
          Data.Step;
          if Data.Time >= NextPrint then
          begin
            WriteLn(Format('t=%5.2f  angle=%7.3f rad  ctrl=%6.3f',
              [Data.Time, Data.QPos[0], Data.Ctrl[0]]));
            NextPrint := NextPrint + 0.25;
          end;
        end;
      finally
        Data.Free;
      end;
    finally
      Model.Free;
    end;
  except
    on E: Exception do
    begin
      WriteLn(E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
{$ifndef fpc}
  if DebugHook <> 0 then
  begin
    Write('Press Enter to close...');
    ReadLn;
  end;
{$endif}
end.
