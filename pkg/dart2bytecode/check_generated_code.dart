import 'dart:io';

void main() {
  final file = File('./transformed_dart.dart');
  if (!file.existsSync()) {
    print('❌ transformed_dart.dart 文件不存在');
    return;
  }

  final content = file.readAsStringSync();
  print('✅ 文件存在，大小: ${content.length} 字符');
  print('📄 行数: ${content.split('\n').length}');

  // 检查基本的 Dart 语法结构
  if (content.contains('import')) {
    print('✅ 包含 import 语句');
  } else {
    print('❌ 缺少 import 语句');
  }

  if (content.contains('class')) {
    print('✅ 包含类定义');
  } else {
    print('❌ 缺少类定义');
  }

  // 检查是否有明显的语法错误
  final problematicPatterns = [
    'EmptyStatement',
    'ForStatement',
    'InstanceSet',
    'InstanceGet',
    'DynamicGet',
    'DynamicInvocation',
    'InstanceInvocation'
  ];

  for (final pattern in problematicPatterns) {
    if (content.contains(pattern)) {
      print('⚠️  发现可能的问题模式: $pattern');
    }
  }

  // 显示文件的前几行
  print('\n📝 文件前10行:');
  final lines = content.split('\n');
  for (int i = 0; i < 10 && i < lines.length; i++) {
    print('${i + 1}: ${lines[i]}');
  }
}
