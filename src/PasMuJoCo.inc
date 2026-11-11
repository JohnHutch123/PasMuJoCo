{ PasMuJoCo.inc - shared compiler and platform defines.

  Copyright 2026 John Hutchings
  Licensed under the Apache License, Version 2.0 (see LICENSE). }

{$ifdef fpc}
  {$mode delphi}
  {$h+}
  {$packrecords c}
  {$packenum 4}
{$else}
  {$align 8}
  {$minenumsize 4}
{$endif}

// typed pointers into MuJoCo arrays can be indexed: m^.geom_type[i]
{$pointermath on}

{$ifdef MSWINDOWS}
  {$define PasMuJoCoWindows}
{$endif}
{$ifdef WINDOWS}
  {$define PasMuJoCoWindows}
{$endif}
{$ifdef LINUX}
  {$define PasMuJoCoLinux}
{$endif}

{$if not (defined(PasMuJoCoWindows) or defined(PasMuJoCoLinux))}
  {$message error 'PasMuJoCo supports Windows x64 and Linux x86_64 only'}
{$ifend}

{$if defined(CPU64) or defined(CPUX64) or defined(CPUX86_64)}
  {$define PasMuJoCo64}
{$else}
  {$message error 'PasMuJoCo requires a 64-bit target (MuJoCo ships 64-bit binaries only)'}
{$ifend}

{ mjtNum is double unless MuJoCo was built with mjUSESINGLE. The official
  binaries use double; define PasMuJoCoSingle only for a custom build. }
{.$define PasMuJoCoSingle}
