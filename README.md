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

> **Status:** early scaffolding. The header translation and wrapper classes
> are being written now; see [Roadmap](#roadmap).

## Targets

| Platform     | Compiler                     | MuJoCo library   |
|--------------|------------------------------|------------------|
| Windows x64  | Delphi 12 or Delphi 13       | `mujoco.dll`     |
| Linux x86_64 | Free Pascal 3.2.2 or later   | `libmujoco.so`   |

MuJoCo version: **3.x** (latest release). The loader checks `mj_version()`
when it loads the library and refuses a library that doesn't match the
header's version.

## Layout

```
src/                  Pascal units (header, loader, wrapper classes)
  PasMuJoCo.inc       Compiler / platform defines shared by all units
  PasMuJoCo.pas       MuJoCo C API translation + dynamic loader
packages/Delphi12/    Delphi 12 runtime package (PasMuJoCo.dpk)
packages/Delphi13/    Delphi 13 runtime package (PasMuJoCo.dpk)
samples/              Small console programs
tests/                Record-layout and smoke tests
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

## Roadmap

1. Repo skeleton (this commit).
2. `PasMuJoCo.pas`: types, enums, structs (`mjModel`, `mjData`, `mjOption`,
   `mjContact`, `mjv*` scene structs) and API function pointers, plus the
   dynamic loader and a record-size test against the C headers.
3. Thin classes, `TMjModel` (load from XML or `.mjb`) and `TMjData` (`Step`,
   `Forward`, `Reset`), with a console sample for Win64 and Linux.

Rendering is out of scope here. Vulkan visualisation of MuJoCo scenes lives in
[Vulkan_Package_PRO](https://github.com/JohnHutch123/Vulkan_Package_PRO).

## Licence

Apache License 2.0, the same licence as MuJoCo. See [LICENSE](LICENSE) and
[NOTICE](NOTICE).
