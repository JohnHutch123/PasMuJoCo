# Regenerating the header

`src/PasMuJoCo.pas` and `tests/layout/LayoutTest.dpr` are generated. Don't
edit them by hand: change `PasMuJoCo.template.pas` or `generate_header.py`
and regenerate.

## What the generator reads

| Input | From | Used for |
|---|---|---|
| `python/mujoco/introspect/` | MuJoCo source tree at the release tag | structs, enums, functions, doc comments |
| `include/mujoco/*.h` | MuJoCo binary release | `#define` constants, `mjVERSION_HEADER`, `mjbatch.h` |
| `PasMuJoCo.template.pas` | this folder | hand-written parts: callback types, plugin and batch records, library variables, loader |

The introspect files are MuJoCo's own machine-readable description of its C
API. `introspect_data.py` reads them as data with Python's `ast` module and
never imports or runs them.

## Steps (Linux, Python 3.8+, gcc, Free Pascal)

```sh
VER=3.17.0
# 1. MuJoCo release (headers + library) and the matching introspect metadata
curl -LO https://github.com/google-deepmind/mujoco/releases/download/$VER/mujoco-$VER-linux-x86_64.tar.gz
tar xzf mujoco-$VER-linux-x86_64.tar.gz
git clone --depth 1 --branch $VER --filter=blob:none --sparse \
  https://github.com/google-deepmind/mujoco mujoco-src
git -C mujoco-src sparse-checkout set python/mujoco/introspect

GEN="python3 tools/generate_header.py --introspect mujoco-src/python/mujoco/introspect --include mujoco-$VER/include"

# 2. generate the header and the C layout program
$GEN

# 3. record the C layout of this release
gcc -std=c11 -Imujoco-$VER/include tests/layout/layout_c.c -o /tmp/layout_c
/tmp/layout_c > tests/layout/expected_$VER.txt

# 4. regenerate LayoutTest.dpr with those expected values, then run the tests
$GEN --expected tests/layout/expected_$VER.txt
MUJOCO_INCLUDE_CHECK=1 tests/run_tests_linux.sh mujoco-$VER
```

Delete the previous `expected_*.txt` when you move to a new release.

The C struct layouts are identical on Windows x64 and Linux x86_64 (MuJoCo
uses no `long`), so the expected file recorded on Linux is also correct for
Win64. Build and run `LayoutTest.dpr` in Delphi to check Delphi's record
layout without needing a C compiler on Windows.
