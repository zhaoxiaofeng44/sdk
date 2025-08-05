import 'dart:io';

void main() {
  final file = File('./transformed_dart.dart');
  if (!file.existsSync()) {
    print('❌ transformed_dart.dart 文件不存在');
    return;
  }
  
  final content = file.readAsStringSync();
  
  // 检查比较运算符的修复
  print('🔍 检查比较运算符修复:');
  
  // 检查是否还有 index.<(0) 这样的模式
  final badComparisonPatterns = [
    'index.<(0)',
    'index.>(self._length)',
    'self._length.>(1)',
    r'self.$1.>(1)'
  ];
  
  for (final pattern in badComparisonPatterns) {
    if (content.contains(pattern)) {
      print('❌ 发现未修复的比较运算符: $pattern');
    } else {
      print('✅ 未发现问题模式: $pattern');
    }
  }
  
  // 检查正确的比较运算符
  final goodComparisonPatterns = [
    'index < 0',
    'index > self._length',
    'self._length > 1'
  ];
  
  for (final pattern in goodComparisonPatterns) {
    if (content.contains(pattern)) {
      print('✅ 发现正确的比较运算符: $pattern');
    } else {
      print('⚠️  未发现正确模式: $pattern');
    }
  }
  
  // 检查 this/self 的使用
  print('\n🔍 检查 this/self 使用:');
  final thisCount = 'this'.allMatches(content).length;
  final selfCount = 'self'.allMatches(content).length;
  
  print('this 出现次数: $thisCount');
  print('self 出现次数: $selfCount');
  
  // 显示一些具体的代码片段
  print('\n📝 代码片段示例:');
  final lines = content.split('\n');
  for (int i = 176; i < 185 && i < lines.length; i++) {
    print('${i + 1}: ${lines[i]}');
  }
} 