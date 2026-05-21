// ============================================================================
// async/await 转换测试
// 验证 restorer 将 async/await 正确转换为 Promise + smAwait
// 注意：避免使用 int 运算符和 Future.delayed（platform dill stub 限制）
// ============================================================================

Future<String> greetAsync(String name) async {
  return 'hello $name';
}

Future<String> chainAsync(String prefix) async {
  final greeting = await greetAsync('world');
  return '$prefix: $greeting';
}

Future<String> multiAwait(String a, String b) async {
  final r1 = await greetAsync(a);
  final r2 = await greetAsync(b);
  return '$r1 and $r2';
}

Future<String> tryCatchAsync(String input) async {
  try {
    if (input == 'fail') {
      throw Exception('expected failure');
    }
    final result = await greetAsync(input);
    return 'ok: $result';
  } catch (e) {
    return 'caught: $e';
  }
}

Future<String> conditionalAsync(bool flag) async {
  if (flag) {
    return await greetAsync('yes');
  } else {
    return await greetAsync('no');
  }
}

void main() async {
  print('=== async/await 转换验证测试 ===\n');

  print('--- 1. 基础 async 函数 ---');
  final v1 = await greetAsync('dart');
  assert(v1 == 'hello dart', 'Expected "hello dart", got "$v1"');
  print('  ✓ greetAsync("dart") = "$v1"');

  print('\n--- 2. 串行 await ---');
  final v2 = await chainAsync('prefix');
  assert(v2 == 'prefix: hello world', 'Unexpected: "$v2"');
  print('  ✓ chainAsync("prefix") = "$v2"');

  print('\n--- 3. 多个 await ---');
  final v3 = await multiAwait('alice', 'bob');
  assert(v3 == 'hello alice and hello bob', 'Unexpected: "$v3"');
  print('  ✓ multiAwait("alice","bob") = "$v3"');

  print('\n--- 4. try-catch 中的 await ---');
  final v4a = await tryCatchAsync('ok_input');
  assert(v4a == 'ok: hello ok_input', 'Unexpected: "$v4a"');
  print('  ✓ tryCatchAsync("ok_input") = "$v4a"');
  final v4b = await tryCatchAsync('fail');
  assert(v4b == 'caught: Exception: expected failure', 'Unexpected: "$v4b"');
  print('  ✓ tryCatchAsync("fail") = "$v4b"');

  print('\n--- 5. 条件分支中的 await ---');
  final v5a = await conditionalAsync(true);
  final v5b = await conditionalAsync(false);
  assert(v5a == 'hello yes', 'Unexpected: "$v5a"');
  assert(v5b == 'hello no', 'Unexpected: "$v5b"');
  print('  ✓ conditionalAsync(true) = "$v5a"');
  print('  ✓ conditionalAsync(false) = "$v5b"');

  print('\n=== ✅ 全部 5 个 async/await 测试通过！ ===');
}
