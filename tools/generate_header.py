# Copyright 2026 John Hutchings. Licensed under the Apache License, Version 2.0.
"""Generate src/PasMuJoCo.pas and the record-layout tests from MuJoCo's headers.

Inputs (both from the same MuJoCo release tag):
  --introspect  python/mujoco/introspect from the MuJoCo source tree. Its
                structs.py / functions.py / enums.py are read as data with
                the ast module; they are never imported or executed.
  --include     include/ from the binary release (for #define constants,
                mjVERSION_HEADER and mjbatch.h).

Hand-written parts (callback typedefs, plugin/batch structs, the dynamic
loader) live in tools/PasMuJoCo.template.pas; this script fills its
{%...%} placeholders.

Usage:
  python3 tools/generate_header.py --introspect <dir> --include <dir>
"""
import argparse, os, re, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import introspect_data  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ----------------------------------------------------------------------------
# configuration

# Skipped: the OpenGL/GLFW UI used by MuJoCo's "simulate" app. Its item
# union refers to structs that introspect does not describe, and PasMuJoCo
# is renderer-free.
def skip_struct(name):
    return name.startswith('mjui') or name.startswith('mjUI')

def skip_function(name):
    return name.startswith('mjui_')

# C scalar -> Pascal scalar
BASE = {
    'void': None, 'char': 'AnsiChar', 'unsigned char': 'Byte',
    'int': 'Int32', 'unsigned int': 'UInt32', 'float': 'Single',
    'double': 'Double', 'size_t': 'NativeUInt', 'uintptr_t': 'NativeUInt',
    'uint64_t': 'UInt64', 'int64_t': 'Int64',
    'mjtNum': 'mjtNum', 'mjtByte': 'mjtByte', 'mjtSize': 'mjtSize',
    'mjtBool': 'mjtBool',
    # C++ containers in mjspec.h are "void" when seen from C
    'mjString': 'mjVoidT', 'mjStringVec': 'mjVoidT', 'mjIntVec': 'mjVoidT',
    'mjIntVecVec': 'mjVoidT', 'mjFloatVec': 'mjVoidT', 'mjFloatVecVec': 'mjVoidT',
    'mjDoubleVec': 'mjVoidT', 'mjByteVec': 'mjVoidT',
}

# Pointers to scalars get their own "Pmj" names (PmjInt32 = ^Int32) rather
# than the RTL's PInteger/PDouble, because Delphi only allows indexing
# (m^.geom_type[i]) on pointer types declared under {$POINTERMATH ON}.
# PAnsiChar and PByte are indexable already; void* stays Pointer.
RTL_POINTERS = {
    'AnsiChar': 'PAnsiChar', 'PAnsiChar': 'PPAnsiChar', 'Byte': 'PByte',
    'Pointer': 'PPointer', 'mjVoidT': 'Pointer',
}
SCALAR_POINTERS = {'Int32', 'UInt32', 'Single', 'Double', 'NativeUInt', 'UInt64', 'Int64'}

RESERVED = set('''
and array as asm begin case class const constructor destructor dispinterface
div do downto else end except exports file finalization finally for function
goto if implementation in inherited initialization inline interface is label
library mod nil not object of or packed procedure program property raise
record repeat resourcestring set shl shr string then threadvar to try type
unit until uses var while with xor operator
'''.split())

# ----------------------------------------------------------------------------
# helpers

def ident(name):
    return '&' + name if name.lower() in RESERVED else name

def strip_struct(name):
    name = name.replace('struct ', '').replace('enum ', '')
    return name[:-1] if name.endswith('_') else name

def comment(doc, indent):
    if not doc:
        return []
    return [indent + '// ' + line.strip() for line in doc.strip().splitlines() if line.strip()]

def enum_values(e):
    v = e['values']
    pairs = v['_args'][0] if isinstance(v, dict) else v
    return [(k, val) for k, val in pairs]


class Gen:
    def __init__(self, structs, functions, enums, template_names):
        self.S, self.F, self.E = structs, functions, enums
        self.template_names = {n.lower() for n in template_names}
        self.pointers = {}          # alias -> target, in creation order
        self.opaque = set()
        self.anon_records = []      # (name, fields) for anonymous sub-structs
        self.type_names = set()

    # --- type mapping -------------------------------------------------------
    def scalar(self, name):
        name = strip_struct(name)
        if name in BASE:
            return BASE[name]
        if name in self.E:
            return name
        if name in self.S or name.lower() in self.template_names:
            return name
        if name.startswith('mj'):
            self.opaque.add(name)
            return name
        raise KeyError('unknown C type ' + name)

    def pointer_to(self, target):
        if target is None:
            return 'Pointer'
        if target in RTL_POINTERS:
            return RTL_POINTERS[target]
        alias = ('Pmj' if target in SCALAR_POINTERS else 'P') + target
        if alias.lower() not in self.template_names and alias not in self.pointers:
            self.pointers[alias] = target
        return alias

    def ptype(self, t, in_param=False):
        """Pascal type for a value/pointer/array node."""
        k = t['_']
        if k == 'ValueType':
            return self.scalar(t['name'])
        if k == 'PointerType':
            inner = t['inner_type']
            if inner['_'] == 'ArrayType':
                return 'Pointer'
            return self.pointer_to(self.ptype(inner))
        if k == 'ArrayType':
            inner = self.ptype(t['inner_type'])
            if in_param:                     # C arrays decay to pointers
                return self.pointer_to(inner)
            dims = ', '.join('0..%d' % (n - 1) for n in t['extents'])
            return 'array[%s] of %s' % (dims, inner)
        raise ValueError(k)

    # --- sections -----------------------------------------------------------
    def enums(self):
        types, consts = [], []
        for name, e in self.E.items():
            types.append('  %s = Int32;' % name)
            consts.append('  // %s' % name)
            for k, v in enum_values(e):
                consts.append('  %s = %d;' % (k, v))
            consts.append('')
        return '\n'.join(types), '\n'.join(consts)

    def record(self, name, fields, out, doc=None):
        lines = []
        lines += comment(doc, '  ')
        lines.append('  %s = record' % name)
        seen = set()
        for f in fields:
            if f['_'] != 'StructFieldDecl':
                raise ValueError('unsupported %s in %s' % (f['_'], name))
            fname = f['name']
            if fname.lower() in seen:
                raise ValueError('case-insensitive field clash %s.%s' % (name, fname))
            seen.add(fname.lower())
            t = f['type']
            if t['_'] == 'AnonymousStructDecl':
                sub = '%s_%s' % (name, fname)
                self.pointer_to(sub)
                self.record(sub, t['fields'], out)
                tp = sub
            else:
                tp = self.ptype(t)
            line = '    %s: %s;' % (ident(fname), tp)
            if f.get('doc'):
                line = line.ljust(48) + ' // ' + ' '.join(f['doc'].split())
            lines.append(line)
        lines.append('  end;')
        lines.append('')
        out.append('\n'.join(lines))

    def records(self):
        out = []
        for name, s in self.S.items():
            if skip_struct(name):
                continue
            self.pointer_to(name)
            self.record(name, s['fields'], out)
        return '\n'.join(out)

    def params(self, fn):
        names = set()
        parts = []
        for p in fn['parameters']:
            pname = p['name'] or 'arg%d' % len(parts)
            # a parameter must not shadow a type that a later parameter uses
            if pname.lower() in self.type_names or pname.lower() in names:
                pname = 'a' + pname
            names.add(pname.lower())
            tp = self.ptype(p['type'], in_param=True)
            parts.append('%s: %s' % (ident(pname), tp))
        return '; '.join(parts)

    def functions(self):
        types, vars_, loads = [], [], []
        for name, fn in self.F.items():
            if skip_function(name):
                continue
            ret = self.ptype(fn['return_type'], in_param=True) \
                if not (fn['return_type']['_'] == 'ValueType' and fn['return_type']['name'] == 'void') else None
            args = self.params(fn)
            sig = '(%s)' % args if args else ''
            if ret:
                decl = 'function%s: %s; cdecl;' % (sig, ret)
            else:
                decl = 'procedure%s; cdecl;' % sig
            types += comment(fn.get('doc'), '  ')
            types.append('  T%s = %s' % (name, decl))
            vars_.append('  %s: T%s = nil;' % (name, name))
            loads.append("  @%s := mjGetProc('%s');" % (name, name))
        return '\n'.join(types), '\n'.join(vars_), '\n'.join(loads)


# ----------------------------------------------------------------------------
# small C prototype parser for headers that introspect does not cover

def parse_c_type(text):
    text = text.strip()
    stars = text.count('*')
    words = [w for w in re.split(r'[\s*]+', text) if w and w != 'const']
    t = {'_': 'ValueType', 'name': ' '.join(words)}
    for _ in range(stars):
        t = {'_': 'PointerType', 'inner_type': t}
    return t

def parse_prototypes(path):
    src = open(path, encoding='utf-8').read()
    src = re.sub(r'/\*.*?\*/', '', src, flags=re.S)
    funcs = {}
    for m in re.finditer(r'((?://[^\n]*\n)*)MJAPI\s+([^;(]*?)\b(\w+)\s*\(([^)]*)\)\s*;', src):
        doc = '\n'.join(l.strip()[2:].strip() for l in m.group(1).splitlines())
        doc = '\n'.join(l for l in doc.splitlines() if not l.startswith('Nullable'))
        params = []
        for p in [x.strip() for x in m.group(4).split(',') if x.strip() and x.strip() != 'void']:
            pm = re.match(r'(.*?)(\w+)\s*(\[\d*\])?$', p)
            t = parse_c_type(pm.group(1))
            if pm.group(3):
                t = {'_': 'PointerType', 'inner_type': t}
            params.append({'name': pm.group(2), 'type': t})
        funcs[m.group(3)] = {'name': m.group(3), 'return_type': parse_c_type(m.group(2)),
                             'parameters': params, 'doc': doc}
    return funcs


def read_constants(include):
    consts, seen = [], set()
    order = ['mjtype.h', 'mjmodel.h', 'mjdata.h', 'mjvisualize.h', 'mjrender.h',
             'mjspec.h', 'mujoco.h']
    for h in order:
        for line in open(os.path.join(include, 'mujoco', h), encoding='utf-8'):
            m = re.match(r'\s*#define\s+(mj[A-Za-z0-9_]+)\s+([-+0-9.eE]+)f?\s*(//(.*))?$', line)
            if not m or m.group(1) in seen or m.group(1) == 'mjVERSION_HEADER':
                continue
            seen.add(m.group(1))
            val = m.group(2)
            line = '  %s = %s;' % (m.group(1), val)
            if m.group(4):
                line = line.ljust(40) + ' // ' + m.group(4).strip()
            consts.append(line)
    return '\n'.join(consts)


def template_identifiers(text):
    names = set(re.findall(r'^\s*(\w+)\s*=', text, flags=re.M))
    return names


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--introspect', required=True)
    ap.add_argument('--include', required=True)
    ap.add_argument('--out', default=os.path.join(ROOT, 'src', 'PasMuJoCo.pas'))
    ap.add_argument('--tests', default=os.path.join(ROOT, 'tests', 'layout'))
    ap.add_argument('--expected', help='output of layout_c.c; regenerates LayoutTest.dpr')
    a = ap.parse_args()

    S, F, E = introspect_data.load(a.introspect)
    F = dict(F)
    # function-pointer parameter: hand-typed as mjfCleanup in the template
    F['mjs_setUserValueWithCleanup'] = {
        'name': 'mjs_setUserValueWithCleanup',
        'return_type': {'_': 'ValueType', 'name': 'void'},
        'parameters': [
            {'name': 'element', 'type': {'_': 'PointerType', 'inner_type': {'_': 'ValueType', 'name': 'mjsElement'}}},
            {'name': 'key', 'type': {'_': 'PointerType', 'inner_type': {'_': 'ValueType', 'name': 'char'}}},
            {'name': 'data', 'type': {'_': 'PointerType', 'inner_type': {'_': 'ValueType', 'name': 'void'}}},
            {'name': 'cleanup', 'type': {'_': 'ValueType', 'name': 'mjfCleanup'}},
        ],
        'doc': 'Set user payload, with a cleanup function called when the element is destroyed.'}
    batch = parse_prototypes(os.path.join(a.include, 'mujoco', 'mjbatch.h'))
    F.update(batch)

    template_path = os.path.join(ROOT, 'tools', 'PasMuJoCo.template.pas')
    template = open(template_path, encoding='utf-8').read()

    version = re.search(r'#define\s+mjVERSION_HEADER\s+(\d+)',
                        open(os.path.join(a.include, 'mujoco', 'mujoco.h')).read()).group(1)

    g = Gen(S, F, E, template_identifiers(template))
    g.type_names = {n.lower() for n in list(S) + list(E)} | g.template_names | \
                   {v.lower() for v in BASE.values() if v} | {'pointer'}
    enum_types, enum_consts = g.enums()
    records = g.records()
    ftypes, fvars, floads = g.functions()

    pointers = '\n'.join('  %s = ^%s;' % (k, v) for k, v in g.pointers.items())
    opaque = '\n'.join('  %s = record end;' % n for n in sorted(g.opaque)
                       if n.lower() not in g.template_names)

    out = template
    for key, val in [('VERSION', version), ('CONSTANTS', read_constants(a.include)),
                     ('ENUM_TYPES', enum_types), ('ENUM_CONSTS', enum_consts),
                     ('OPAQUE', opaque), ('POINTERS', pointers), ('RECORDS', records),
                     ('FUNCTION_TYPES', ftypes), ('FUNCTION_VARS', fvars),
                     ('FUNCTION_LOADS', floads),
                     ('VERSION_DOTTED', '%d.%d.%d' % (int(version) // 1000000,
                                                      int(version) // 1000 % 1000,
                                                      int(version) % 1000))]:
        out = out.replace('{%' + key + '%}', val)
    leftover = re.findall(r'\{%\w+%\}', out)
    if leftover:
        raise SystemExit('unfilled placeholders: %s' % leftover)

    # global, case-insensitive identifier clash check
    decl = re.findall(r'^\s+(&?\w+)\s*[:=]', out, flags=re.M)
    clash = {}
    section_names = set()
    for n in re.findall(r'^  (\w+)\s*(?:=|:)', out, flags=re.M):
        clash.setdefault(n.lower(), set()).add(n)
    dupes = {k: v for k, v in clash.items() if len(v) > 1}
    if dupes:
        raise SystemExit('case-insensitive identifier clashes: %s' % dupes)

    with open(a.out, 'w', encoding='utf-8', newline='\r\n') as fh:
        fh.write(out)
    print('wrote', a.out, '(%d functions, %d structs, %d enums)' % (
        len(fvars.splitlines()), sum(1 for s in S if not skip_struct(s)), len(E)))

    write_layout_tests(S, a.tests, a.expected, '%d.%d.%d' % (
        int(version) // 1000000, int(version) // 1000 % 1000, int(version) % 1000))


# ----------------------------------------------------------------------------
# layout tests: the same list of sizeof/offsetof lines from C and from Pascal

# records written by hand in the template: (name, [fields])
MANUAL_LAYOUT = [
    ('mjResource', ['name', 'data', 'vfs', 'timestamp', 'provider', 'args']),
    ('mjpResourceProvider', ['prefix', 'open', 'read', 'close', 'mount', 'unmount',
                             'modified', 'write', 'data']),
    ('mjpDecoder', ['content_type', 'extension', 'can_decode', 'decode']),
    ('mjpEncoder', ['content_type', 'extension', 'encode', 'close_resource']),
    ('mjpPlugin', ['name', 'nattribute', 'attributes', 'capabilityflags', 'needstage',
                   'nstate', 'nsensordata', 'init', 'destroy', 'copy', 'reset', 'compute',
                   'advance', 'visualize', 'actuator_act_dot', 'sdf_distance',
                   'sdf_gradient', 'sdf_staticdistance', 'sdf_attribute', 'sdf_aabb']),
    ('mjBatchConfig', ['nthread', 'persistent']),
    ('mjBatchRecord', ['field', 'spec', 'buf']),
]
PROCEDURAL_FIELDS = set(MANUAL_LAYOUT[1][1][1:8] + MANUAL_LAYOUT[2][1][2:] +
                        MANUAL_LAYOUT[3][1][2:] + MANUAL_LAYOUT[4][1][5:])


def is_procedural(t):
    return t['_'] == 'ValueType' and (t.get('procedural') or
                                       strip_struct(t.get('name', '')).startswith('mjf'))


def layout_entries(S):
    """(key, C expression, Pascal expression) for every size and offset."""
    entries = []
    def add_struct(name, fields):
        entries.append((name, 'sizeof(%s)' % name, 'SizeOf(%s)' % name))
        def walk(fields, cpath, ppath):
            for f in fields:
                cp = cpath + [f['name']]
                pp = ppath + [ident(f['name'])]
                # "@" on a procedural field yields the function address in
                # Delphi mode; "@@" yields the address of the field itself
                at = '@@' if is_procedural(f['type']) else '@'
                entries.append(('%s.%s' % (name, '.'.join(cp)),
                                'offsetof(%s, %s)' % (name, '.'.join(cp)),
                                'NativeUInt(%sP%s(nil)^.%s)' % (at, name, '.'.join(pp))))
                if f['type']['_'] == 'AnonymousStructDecl':
                    walk(f['type']['fields'], cp, pp)
        walk(fields, [], [])
    for name, s in S.items():
        if not skip_struct(name):
            add_struct(name, s['fields'])
    for name, fields in MANUAL_LAYOUT:
        add_struct(name, [{'name': f, 'type': {'_': 'ValueType', 'procedural': f in PROCEDURAL_FIELDS}}
                          for f in fields])
    return entries


def write_layout_tests(S, outdir, expected_path, version):
    """layout_c.c prints the C layout; LayoutTest.dpr checks the Pascal layout
    against that output (expected_<version>.txt), so the Pascal test needs no
    C compiler on the machine that runs it."""
    os.makedirs(outdir, exist_ok=True)
    entries = layout_entries(S)
    c = ['// Generated by tools/generate_header.py. Prints sizeof/offsetof for every',
         '// MuJoCo struct; its output is the expected data for LayoutTest.dpr.',
         '#include <stdio.h>', '#include <stddef.h>', '#include <mujoco/mujoco.h>',
         '#include <mujoco/mjbatch.h>', '', 'int main(void) {']
    for key, cexpr, _ in entries:
        c.append('  printf("%s %%zu\\n", %s);' % (key, cexpr))
    c += ['  return 0;', '}', '']
    with open(os.path.join(outdir, 'layout_c.c'), 'w', newline='\n') as fh:
        fh.write('\n'.join(c))
    print('wrote layout_c.c (%d entries)' % len(entries))

    if not expected_path:
        print('no --expected file: LayoutTest.dpr not regenerated')
        return
    expected = dict(line.split() for line in open(expected_path) if line.strip())
    missing = [k for k, _, _ in entries if k not in expected]
    if missing:
        raise SystemExit('expected file lacks %d entries, e.g. %s' % (len(missing), missing[:3]))
    p = ['{ Generated by tools/generate_header.py - DO NOT EDIT.',
         '  Checks SizeOf and field offsets of every PasMuJoCo record against the',
         '  C layout of MuJoCo %s (output of layout_c.c). Exit code 0 = all match. }' % version,
         '', 'program LayoutTest;', '', '{$i PasMuJoCo.inc}', '{$apptype console}', '',
         'uses', '  PasMuJoCo;', '',
         'var', '  Failures, Checked: Integer;', '',
         'procedure Check(const AName: string; AActual, AExpected: NativeUInt);',
         'begin', '  Inc(Checked);', '  if AActual <> AExpected then', '  begin',
         '    Inc(Failures);',
         "    WriteLn('MISMATCH ', AName, ': Pascal ', AActual, ', C ', AExpected);",
         '  end;', 'end;', '', 'begin', '  Failures := 0;', '  Checked := 0;']
    for key, _, pexpr in entries:
        p.append("  Check('%s', %s, %s);" % (key, pexpr, expected[key]))
    p += ["  WriteLn(Checked, ' layout checks, ', Failures, ' mismatches');",
          '  if Failures > 0 then', '    Halt(1);', 'end.', '']
    with open(os.path.join(outdir, 'LayoutTest.dpr'), 'w', newline='\r\n') as fh:
        fh.write('\n'.join(p))
    print('wrote LayoutTest.dpr')


if __name__ == '__main__':
    main()
