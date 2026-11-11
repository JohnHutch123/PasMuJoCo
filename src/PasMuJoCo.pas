{ PasMuJoCo - Object Pascal header for the MuJoCo 3.x C API.

  Copyright 2026 John Hutchings
  Licensed under the Apache License, Version 2.0 (see LICENSE).

  Contains translations of the MuJoCo C headers,
  Copyright 2021 DeepMind Technologies Limited, Apache License 2.0.

  STATUS: skeleton. The full type and API translation arrives in step 2 of
  the roadmap; this unit currently holds only the library names and the
  basic scalar types so the packages and build scripts compile. }

unit PasMuJoCo;

{$i PasMuJoCo.inc}

interface

const
{$ifdef PasMuJoCoWindows}
  MuJoCoLibraryName = 'mujoco.dll';
{$else}
  MuJoCoLibraryName = 'libmujoco.so';
{$endif}

type
{$ifdef PasMuJoCoSingle}
  mjtNum = Single;
{$else}
  mjtNum = Double;
{$endif}
  PmjtNum = ^mjtNum;

  mjtByte = Byte;
  PmjtByte = ^mjtByte;

  mjtSize = UInt64;

implementation

end.
