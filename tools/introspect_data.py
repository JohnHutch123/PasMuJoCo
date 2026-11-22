# Copyright 2026 John Hutchings. Licensed under the Apache License, Version 2.0.
"""Load MuJoCo introspect tables as plain data, WITHOUT executing them.

Parses structs.py / functions.py / enums.py with the ast module and turns
the constructor calls (StructDecl(...), ValueType(...), ...) into dicts
of the form {'_': 'ValueType', 'name': ..., ...}.
"""
import ast, os

def _conv(node):
    if isinstance(node, ast.Call):
        d = {'_': node.func.id if isinstance(node.func, ast.Name) else ast.unparse(node.func)}
        if node.args:
            d['_args'] = [_conv(a) for a in node.args]
        for kw in node.keywords:
            d[kw.arg] = _conv(kw.value)
        return d
    if isinstance(node, (ast.Tuple, ast.List)):
        return [_conv(e) for e in node.elts]
    if isinstance(node, ast.Constant):
        return node.value
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
        return -_conv(node.operand)
    if isinstance(node, ast.BinOp):
        # implicit string concatenation is folded by the parser; anything else is unexpected
        raise ValueError('unexpected expression: ' + ast.unparse(node))
    raise ValueError('unexpected node: ' + ast.dump(node)[:200])

def load_table(path, varname):
    tree = ast.parse(open(path, encoding='utf-8').read(), path)
    for stmt in tree.body:
        if isinstance(stmt, (ast.Assign, ast.AnnAssign)):
            target = stmt.targets[0] if isinstance(stmt, ast.Assign) else stmt.target
            if isinstance(target, ast.Name) and target.id == varname:
                call = stmt.value              # dict([ (name, Decl), ... ])
                pairs = _conv(call.args[0])
                return dict((k, v) for k, v in pairs)
    raise KeyError(varname)

def load(introspect_dir):
    j = lambda f: os.path.join(introspect_dir, f)
    return (load_table(j('structs.py'), 'STRUCTS'),
            load_table(j('functions.py'), 'FUNCTIONS'),
            load_table(j('enums.py'), 'ENUMS'))
