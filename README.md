# PasMuJoCo

Object Pascal headers and thin wrapper classes for the
[MuJoCo](https://github.com/google-deepmind/mujoco) physics engine, for
**Delphi** (RAD Studio 12 and 13, Win64) and **Free Pascal** (Linux x86_64).

The header style follows [PasVulkan](https://github.com/BeRo1985/pasvulkan):
a single translation unit whose API entry points are function pointers,
resolved at runtime from the MuJoCo shared library (`LoadLibrary` /
`GetProcAddress` on Windows, `dlopen` / `dlsym` on Linux). Nothing is linked
statically, so an application starts even when MuJoCo is missing and can
report that cleanly.

> **Status:** the MuJoCo 4.0.1 header, dynamic loader and thin wrapper
> classes are in place, tested with Delphi 12 (Win64) and Free Pascal (Linux).

## Targets

| Platform     | Compiler                     | MuJoCo library   |
|--------------|------------------------------|------------------|
| Windows x64  | Delphi 12 or Delphi 13       | `mujoco.dll`     |
| Linux x86_64 | Free Pascal 3.2.2 or later   | `libmujoco.so`   |

MuJoCo version: **4.0.1**. The loader checks `mj_version()` when it loads the
library and refuses a library that doesn't match the header's version,
because MuJoCo's struct layouts change between releases.

## Layout

```
src/                  Pascal units (header, loader, wrapper classes)
  PasMuJoCo.inc       Compiler / platform defines shared by all units
  PasMuJoCo.pas       MuJoCo C API translation + dynamic loader (generated)
  PasMuJoCoClasses.pas  TMjModel / TMjData wrappers and MuJoCoInitialize
packages/Delphi12/    Delphi 12 runtime package (PasMuJoCo.dpk)
packages/Delphi13/    Delphi 13 runtime package (PasMuJoCo.dpk)
samples/HelloMuJoCo/  Smallest useful program (PD control of a pendulum)
tests/                Record-layout and smoke tests
tools/                Header generator (see tools/README.md)
```

## Getting MuJoCo

Download the 4.0.1 release from
<https://github.com/google-deepmind/mujoco/releases>:

- **Windows:** use `mujoco-<ver>-windows-x86_64.zip` and put `bin\mujoco.dll`
  next to your executable or on `PATH`.
- **Linux:** use `mujoco-<ver>-linux-x86_64.tar.gz` and put `lib/libmujoco.so*`
  on `LD_LIBRARY_PATH`, or pass a full path to the loader.

## Using it

**Delphi 12 / 13:** open `packages/Delphi12/PasMuJoCo.dpk` or
`packages/Delphi13/PasMuJoCo.dpk`, or add `src` to your project's search
path. The IDE creates the `.dproj` and `.res` the first time you open the
`.dpk`. `{$LIBSUFFIX AUTO}` gives each IDE its own BPL name (`PasMuJoCo290.bpl`
for 12, `PasMuJoCo370.bpl` for 13), so both can be installed side by side.

**Free Pascal:** add `-Fusrc -Fisrc` to your `fpc` command line, or add `src`
to the unit paths of your Lazarus project.

## Quick start (classes)

```pascal
uses PasMuJoCo, PasMuJoCoClasses;

MuJoCoInitialize;                         // loads the library, masks FPU exceptions,
                                          // turns MuJoCo fatal errors into EMuJoCo
Model := TMjModel.CreateFromXML('pendulum.xml');
Data := TMjData.Create(Model);
try
  Data.Ctrl[0] := 0.5;
  Data.Step(1000);
  WriteLn(Data.Time:0:3, ' ', Data.QPos[0]:0:5);
finally
  Data.Free;                              // free data before its model
  Model.Free;
end;
```

- `TMjModel`: `CreateFromXML`, `CreateFromXMLString`, `CreateFromBinary`
  (`.mjb`), `CreateFromHandle`, `Clone`, `SaveBinary`, `NameToId`,
  `IdToName`, `Timestep`, and size properties (`nq`, `nv`, `nu`, `nbody`, ...).
- `TMjData`: `Step`, `Step(Count)`, `Step1`/`Step2`, `Forward`, `Inverse`,
  `Reset`, `ResetKeyframe`, `Time`, and range-checked `QPos[]`, `QVel[]`,
  `Ctrl[]`, `Act[]`, `SensorData[]`.
- Everything else is one call away through `Handle`:
  `mj_forward(Model.Handle, Data.Handle)`, `Data.Handle^.xpos[3 * body]`.
- Load and compile errors raise `EMuJoCo` with MuJoCo's own message. After a
  fatal MuJoCo error during simulation, call `Data.Reset` before stepping again.
- Call `MuJoCoMaskFPUExceptions` at the start of any extra thread that runs MuJoCo.

## Header conventions

- Names are MuJoCo's C names, so the [MuJoCo API docs](https://mujoco.readthedocs.io/en/stable/APIreference/index.html)
  apply directly. Pointer types add a `P`: `PmjModel = ^mjModel`.
  Pointers to plain scalars are `PmjInt32`, `PmjSingle`, `PmjDouble` and so on.
- Every function is a function-pointer variable (`mj_step: Tmj_step`), nil
  until `LoadMuJoCoLibrary` succeeds.
- Enums are `Int32` aliases with untyped constants (`mjtGeom`, `mjGEOM_PLANE`),
  so bit flags combine with `or` as in C.
- Model and data arrays are typed pointers you can index: `m^.geom_type[i]`.
- Pascal reserved words used as field names are escaped: `geom.&type`.
- Library variables are pointers into the library:
  `mjcb_control^ := @MyControlCallback;`
- Not translated: the `mjui_*` OpenGL/GLFW UI API, and the variadic
  arguments of `mju_error`, `mju_warning` and `mju_info`.

Mask floating-point exceptions before calling MuJoCo, because its C code
relies on IEEE NaN/Inf behaviour:

```pascal
SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow,
  exUnderflow, exPrecision]);   // unit Math / System.Math
```

```pascal
if not LoadMuJoCoLibrary then
  raise Exception.Create(MuJoCoLastError);
m := mj_loadXML('pendulum.xml', nil, @Error[0], SizeOf(Error));
d := mj_makeData(m);
mj_step(m, d);
```

## Tests

- `tests/layout/LayoutTest.dpr` checks `SizeOf` and every field offset of
  every record (1817 checks) against the C layout of the same release.
- `tests/smoke/SmokeTest.dpr` loads the library, loads
  `tests/models/pendulum.xml` and steps it, using the raw API only.
- `tests/classes/ClassesTest.dpr` covers the wrapper classes (23 checks),
  including error handling.

On Linux, `tests/run_tests_linux.sh /path/to/mujoco-4.0.1` builds and runs
them all with Free Pascal. On Windows, build the `.dpr` files in Delphi with
`src` on the search path, put `mujoco.dll` and `pendulum.xml` next to the
exe, and run them (started from the IDE they wait for Enter before closing).

## Roadmap

1. Repo skeleton. *(done)*
2. `PasMuJoCo.pas`: types, enums, structs and API function pointers, the
   dynamic loader, and record-layout tests against the C headers. *(done)*
3. Thin classes, `TMjModel` and `TMjData`, with a console sample. *(done)*

Rendering is out of scope here. Vulkan visualisation of MuJoCo scenes lives in
[Vulkan_Package_PRO](https://github.com/JohnHutch123/Vulkan_Package_PRO).

## Licence

Apache License 2.0, the same licence as MuJoCo. See [LICENSE](LICENSE) and
[NOTICE](NOTICE).
