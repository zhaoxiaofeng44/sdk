void main() {
  final testStrings = [
    r'if (start < $1 || start > $1 || end < $1 || end > $1) $1;',
    r'if ($1 < 0 || $1 > self._length) $1;',
    r'for (int i = 0; $1.$2; i = $1.$2) $1, $1.$2, $1.$2);',
    r'self._length = self._length.+(replacementLength.-(rangeLength));'
  ];
  
  for (final testString in testStrings) {
    print('原始: $testString');
    final result = _fixPlaceholderVariables(testString);
    print('修复后: $result');
    print('---');
  }
}

String _fixPlaceholderVariables(String str) {
  String result = str;
  
  // 根据上下文替换$1为正确的变量名
  // 在比较操作中，$1通常是0或self._length
  result = result.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*) < \$1'), r'$1 < 0');
  result = result.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*) > \$1'), r'$1 > self._length');
  result = result.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*) <= \$1'), r'$1 <= 0');
  result = result.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*) >= \$1'), r'$1 >= self._length');
  
  // 在算术操作中，$1通常是1
  result = result.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*) \+ \$1'), r'$1 + 1');
  result = result.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*) - \$1'), r'$1 - 1');
  
  // 在方法调用中，$1通常是索引
  result = result.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\.\$1\(([^)]+)\)'), r'$1.$2');
  
  return result;
} 