import 'package:test/test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import '../lib/compile_to_dart.dart';

void main() {
  group('文件前缀功能测试', () {
    test('应该为不同文件的类生成不同的前缀', () {
      // 创建测试组件
      final component = Component();

      // 创建两个不同的库
      final library1 = Library(
        fileUri: Uri.parse('file:///path/to/file1.dart'),
        name: 'file1',
        procedures: [],
        classes: [],
        fields: [],
      );

      final library2 = Library(
        fileUri: Uri.parse('file:///path/to/file2.dart'),
        name: 'file2',
        procedures: [],
        classes: [],
        fields: [],
      );

      // 创建两个同名的类
      final class1 = Class(
        name: 'TestClass',
        fileUri: library1.fileUri,
        supertype: null,
        implementedTypes: [],
        fields: [],
        constructors: [],
        procedures: [],
        typeParameters: [],
        annotations: [],
      );

      final class2 = Class(
        name: 'TestClass',
        fileUri: library2.fileUri,
        supertype: null,
        implementedTypes: [],
        fields: [],
        constructors: [],
        procedures: [],
        typeParameters: [],
        annotations: [],
      );

      library1.classes.add(class1);
      library2.classes.add(class2);
      component.libraries.addAll([library1, library2]);

      // 创建转换器
      final transformer = DartToDartTransformer();

      // 收集文件路径信息
      transformer._collectAllFilePaths(component);

      // 验证生成了不同的前缀
      final prefixedName1 = transformer._getPrefixedClassName('TestClass');
      final prefixedName2 = transformer._getPrefixedClassName('TestClass');

      // 由于两个类来自不同文件，它们应该有不同的前缀
      expect(prefixedName1, isNot(equals(prefixedName2)));
      expect(prefixedName1, startsWith('\$'));
      expect(prefixedName2, startsWith('\$'));
    });

    test('应该生成文件编码注解', () {
      // 创建测试组件
      final component = Component();

      // 创建库和类
      final library = Library(
        fileUri: Uri.parse('file:///path/to/test.dart'),
        name: 'test',
        procedures: [],
        classes: [],
        fields: [],
      );

      final cls = Class(
        name: 'TestClass',
        fileUri: library.fileUri,
        supertype: null,
        implementedTypes: [],
        fields: [],
        constructors: [],
        procedures: [],
        typeParameters: [],
        annotations: [],
      );

      library.classes.add(cls);
      component.libraries.add(library);

      // 创建转换器
      final transformer = DartToDartTransformer();

      // 收集文件路径信息
      transformer._collectAllFilePaths(component);

      // 验证文件编码映射
      expect(transformer._filePathToCode.isNotEmpty, isTrue);
      expect(transformer._codeToFilePath.isNotEmpty, isTrue);

      // 验证编码格式（应该是2个字符）
      final code = transformer._filePathToCode.values.first;
      expect(code.length, equals(2));
      expect(code, matches(r'^[A-Z0-9]{2}$'));
    });

    test('应该正确处理类名替换映射', () {
      // 创建测试组件
      final component = Component();

      // 创建库
      final library = Library(
        fileUri: Uri.parse('file:///path/to/test.dart'),
        name: 'test',
        procedures: [],
        classes: [],
        fields: [],
      );

      // 创建带有cpp:patch注解的类
      final pragmaAnnotation = ConstantExpression(
        InstanceConstant(
          Class(name: 'pragma', fileUri: library.fileUri),
          {
            'name': StringConstant('cpp:patch'),
            'arguments': ListConstant([StringConstant('Error')])
          },
        ),
      );

      final cls = Class(
        name: 'CppError',
        fileUri: library.fileUri,
        supertype: null,
        implementedTypes: [],
        fields: [],
        constructors: [],
        procedures: [],
        typeParameters: [],
        annotations: [pragmaAnnotation],
      );

      library.classes.add(cls);
      component.libraries.add(library);

      // 创建转换器
      final transformer = DartToDartTransformer();

      // 收集文件路径信息
      transformer._collectAllFilePaths(component);

      // 验证类名替换
      expect(transformer._classNameReplacements['Error'], equals('CppError'));

      // 验证带前缀的类名
      final prefixedName = transformer._getPrefixedClassName('Error');
      expect(prefixedName, startsWith('\$'));
      expect(prefixedName, endsWith('_CppError'));
    });
  });
}
