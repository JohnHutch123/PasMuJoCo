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

> **Status:** the full MuJoCo 3.17.0 header and dynamic loader are in place
> and tested on Linux with Free Pascal. The wrapper classes come next; see
> [Roadmap](#roadmap).

## Targets

| Platform     | Compiler                     | MuJoCo library   |
|--------------|------------------------------|------------------|
| Windows x64  | Delphi 12 or Delphi 13       | `mujoco.dll`     |
| Linux x86_64 | Free Pascal 3.2.2 or later   | `libmujoco.so`   |

MuJoCo version: **3.17.0**. The loader checks `mj_version()` when it loads the
library and refuses a library that doesn't match the header's version,
because MuJoCo's struct layouts change between releases.

## Layout

```
src/                  Pascal units (header, loader, wrapper classes)
  PasMuJoCo.inc       Compiler / platform defines shared by all units
  PasMuJoCo.pas       MuJoCo C API translation + dynamic loader (generated)
packages/Delphi12/    Delphi 12 runtime package (PasMuJoCo.dpk)
packages/Delphi13/    Delphi 13 runtime package (PasMuJoCo.dpk)
samples/              Small console programs
tests/                Record-layout and smoke tests
tools/                Header generator (see tools/README.md)
```

## Getting MuJoCo

Download a 3.x release from
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
  every record (1803 checks) against the C layout of the same release.
- `tests/smoke/SmokeTest.dpr` loads the library, loads
  `tests/models/pendulum.xml` and steps it.

On Linux, `tests/run_tests_linux.sh /path/to/mujoco-3.17.0` builds and runs
both with Free Pascal. On Windows, build both `.dpr` files in Delphi with
`src` on the search path, and run them with `mujoco.dll` next to the exe.

## Roadmap

1. Repo skeleton. *(done)*
2. `PasMuJoCo.pas`: types, enums, structs and API function pointers, the
   dynamic loader, and record-layout tests against the C headers. *(done)*
3. Thin classes, `TMjModel` (load from XML or `.mjb`) and `TMjData` (`Step`,
   `Forward`, `Reset`), with a console sample for Win64 and Linux.

Rendering is out of scope here. Vulkan visualisation of MuJoCo scenes lives in
[Vulkan_Package_PRO](https://github.com/JohnHutch123/Vulkan_Package_PRO).

## Licence

Apache License 2.0, the same licence as MuJoCo. See [LICENSE](LICENSE) and
[NOTICE](NOTICE).
