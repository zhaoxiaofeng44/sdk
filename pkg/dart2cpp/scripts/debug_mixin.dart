import 'dart:io';
import 'package:kernel/ast.dart';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_prototype/compiler_options.dart';
import 'package:front_end/src/api_prototype/kernel_generator.dart';

void main() async {
  final uri = Uri.file(
    '${Directory.current.path}/pkg/dart2cpp/test/restorer_full_test.dart',
  );
  final options = CompilerOptions()
    ..sdkRoot = Uri.directory('${Directory.current.path}/')
    ..packagesFileUri = Uri.file(
      '${Directory.current.path}/pkg/dart2cpp/.dart_tool/package_config.json',
    );
  final component = (await kernelForProgram(uri, options))!.component!;
  for (final lib in component.libraries) {
    if (lib.importUri.toString().contains('restorer_full_test')) {
      for (final cls in lib.classes) {
        if (cls.name == 'Dog' || cls.name == 'Cat' || cls.name.contains('&')) {
          print('=== ${cls.name} ===');
          print('  superclass: ${cls.superclass?.name}');
          print('  mixedInType: ${cls.mixedInType?.classNode.name}');
          print('  implementedTypes: ${cls.implementedTypes.map((t) => t.classNode.name).toList()}');
          print('  supertype: ${cls.supertype?.classNode.name}');
          print('  isMixinClass: ${cls.isMixinClass}');
          print('  isMixinDeclaration: ${cls.isMixinDeclaration}');
          var s = cls.superclass;
          int depth = 0;
          while (s != null && depth < 5) {
            print('  superchain[$depth]: ${s.name}, mixedIn: ${s.mixedInType?.classNode.name}');
            s = s.superclass;
            depth++;
          }
        }
      }
    }
  }
}
