// 简化测试：只验证 mixin lowering 是否正确
import 'dart:io';
import 'package:kernel/kernel.dart';
import '../lib/dart_to_dart_restorer.dart';

Future<void> main() async {
  // 创建简化的测试源码
  final testSource = '''
mixin Printable {
  String get displayName;
  void printInfo() => print('[\$displayName]');
}

mixin Orderable<T> {
  int compareTo(T other);
  bool isLessThan(T other) => compareTo(other) < 0;
}

class Animal {
  final String name;
  final int age;
  Animal(this.name, this.age);
  String speak() => '...';
}

class Dog extends Animal with Printable, Orderable<Dog> {
  final String breed;
  Dog(super.name, super.age, this.breed);

  @override
  String get displayName => 'Dog:\$name';

  @override
  String speak() => 'Woof!';

  @override
  int compareTo(Dog other) => age.compareTo(other.age);
}

void main() {
  final dog = Dog('Rex', 5, 'Labrador');
  dog.printInfo();
  print(dog.speak());
  final dog2 = Dog('Buddy', 3, 'Golden');
  print('dog < dog2: \${dog.isLessThan(dog2)}');
}
''';

  // 写入临时文件
  final tempFile = File('/tmp/mixin_test_source.dart');
  await tempFile.writeAsString(testSource);
  final dillFile = File('/tmp/mixin_test_source.dill');

  print('=== 测试 Mixin Lowering ===\n');
  print('原始源码:');
  print(testSource);
  print('\n--- 编译为 Kernel AST ---');

  // 编译
  final compileResult = await Process.run(
    'dart',
    ['compile', 'kernel', tempFile.path, '-o', dillFile.path],
  );

  if (compileResult.exitCode != 0) {
    print('❌ 编译失败');
    print('stderr:\n${compileResult.stderr}');
    await tempFile.delete();
    return;
  }
  print('✅ 编译成功');

  // 加载 component
  final component = loadComponentFromBinary(dillFile.path);

  // 还原
  print('\n--- DartRestorer 还原 ---');
  final restoredSource = restoreDartFromComponent(component);
  print('还原后的代码:');
  print(restoredSource);

  // 写入还原后的文件
  final restoredFile = File('/tmp/mixin_test_restored.dart');
  await restoredFile.writeAsString(restoredSource);
  print('\n✅ 已写入: /tmp/mixin_test_restored.dart');

  // 尝试运行还原后的代码
  print('\n--- 运行还原后的代码 ---');
  final runResult = await Process.run('dart', [restoredFile.path]);
  if (runResult.exitCode == 0) {
    print('✅ 运行成功');
    print('输出:');
    print(runResult.stdout);
  } else {
    print('❌ 运行失败 (exit=${runResult.exitCode})');
    print('stderr:');
    print(runResult.stderr);
  }

  // 清理
  await tempFile.delete();
  await dillFile.delete();
}
