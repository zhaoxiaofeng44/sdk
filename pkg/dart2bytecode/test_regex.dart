void main() {
  final testString = 'if (index.<(0) || index.>(self._length)) throw throw new IndexError(index, self));;';
  
  print('原始字符串: $testString');
  
  // 测试正则表达式
  String result = testString;
  
  result = result.replaceAll(RegExp(r'\.<\(([^)]+)\)'), r' < $1');
  result = result.replaceAll(RegExp(r'\.>\(([^)]+)\)'), r' > $1');
  
  print('处理后: $result');
  
  // 检查是否包含原始模式
  print('包含 index.<(0): ${testString.contains('index.<(0)')}');
  print('包含 index.>(self._length): ${testString.contains('index.>(self._length)')}');
  
  // 检查正则表达式匹配
  final lessThanPattern = RegExp(r'\.<\(([^)]+)\)');
  final greaterThanPattern = RegExp(r'\.>\(([^)]+)\)');
  
  print('匹配 < 模式: ${lessThanPattern.hasMatch(testString)}');
  print('匹配 > 模式: ${greaterThanPattern.hasMatch(testString)}');
  
  if (lessThanPattern.hasMatch(testString)) {
    print('找到匹配: ${lessThanPattern.firstMatch(testString)?.group(0)}');
  }
  
  if (greaterThanPattern.hasMatch(testString)) {
    print('找到匹配: ${greaterThanPattern.firstMatch(testString)?.group(0)}');
  }
} 