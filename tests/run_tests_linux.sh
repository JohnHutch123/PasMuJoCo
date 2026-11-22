#!/usr/bin/env bash
# Build and run the PasMuJoCo tests with Free Pascal on Linux.
#
#   tests/run_tests_linux.sh /path/to/mujoco-3.x.y
#
# The argument is an extracted MuJoCo release (it must contain lib/libmujoco.so).
# With MUJOCO_INCLUDE_CHECK=1 the C layout program is also compiled with gcc and
# its output compared with tests/layout/expected_*.txt.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
root="$(dirname "$here")"
mujoco="${1:?usage: $0 /path/to/mujoco-release}"
out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT

fpcbuild() {
  fpc -vw -Fu"$root/src" -Fi"$root/src" -FU"$out" -FE"$out" "$1" >"$out/build.log" 2>&1 ||
    { cat "$out/build.log"; exit 1; }
  grep -i "warning" "$out/build.log" || true
}

echo "== layout test"
fpcbuild "$here/layout/LayoutTest.dpr"
"$out/LayoutTest" | tail -n 20

if [ "${MUJOCO_INCLUDE_CHECK:-0}" = 1 ]; then
  echo "== C layout vs expected file"
  gcc -std=c11 -I"$mujoco/include" "$here/layout/layout_c.c" -o "$out/layout_c"
  "$out/layout_c" | diff -u "$(ls "$here"/layout/expected_*.txt | tail -n 1)" -
  echo "C layout matches"
fi

echo "== smoke test"
fpcbuild "$here/smoke/SmokeTest.dpr"
LD_LIBRARY_PATH="$mujoco/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
  "$out/SmokeTest" "$here/models/pendulum.xml"
