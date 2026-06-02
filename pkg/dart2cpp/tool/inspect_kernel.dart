// Inspect the kernel structure of a specific class's constructor initializers.
//
// Usage: dart run tool/inspect_kernel.dart <dillPath> <ClassName>
//
// Prints each constructor's initializer list with the runtimeType of each
// value expression so we can see exactly what kernel shape a Matrix2D-style
// `_data = List.generate(rows, ...)` ends up as.

import 'dart:io';
import 'package:kernel/kernel.dart' as k;

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln('usage: dart run tool/inspect_kernel.dart <dillPath> <ClassName>');
    exit(2);
  }
  final dillPath = args[0];
  final className = args[1];
  final component = k.loadComponentFromBinary(dillPath);
  for (final lib in component.libraries) {
    for (final cls in lib.classes) {
      if (cls.name != className) continue;
      stdout.writeln('class ${cls.name} @ ${lib.importUri}');
      for (final ctor in cls.constructors) {
        stdout.writeln('  constructor "${ctor.name.text}":');
        for (final init in ctor.initializers) {
          stdout.writeln('    init ${init.runtimeType}: $init');
          if (init is k.FieldInitializer) {
            _dump('      ', init.value);
          }
        }
      }
    }
  }
}

void _dump(String pad, k.Expression e, [int depth = 0]) {
  stdout.writeln('${pad}${e.runtimeType}: $e');
  if (depth > 6) return;
  if (e is k.StaticInvocation) {
    stdout.writeln('${pad}  target=${e.target.enclosingClass?.name}.${e.target.name.text} (isFactory=${e.target.isFactory})');
    for (var i = 0; i < e.arguments.positional.length; i++) {
      _dump('$pad  [$i] ', e.arguments.positional[i], depth + 1);
    }
  } else if (e is k.ConstructorInvocation) {
    stdout.writeln('${pad}  ctor=${e.target.enclosingClass.name}.${e.target.name.text}');
    for (var i = 0; i < e.arguments.positional.length; i++) {
      _dump('$pad  [$i] ', e.arguments.positional[i], depth + 1);
    }
  } else if (e is k.FunctionExpression) {
    stdout.writeln('${pad}  function: returnType=${e.function.returnType}');
    final body = e.function.body;
    stdout.writeln('${pad}  body type=${body?.runtimeType}');
  } else if (e is k.Let) {
    stdout.writeln('${pad}  var=${e.variable.name}: type=${e.variable.type}');
    _dump('$pad  body= ', e.body, depth + 1);
  }
}
