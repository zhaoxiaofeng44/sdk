import 'package:dart2cpp/restorer/runtime_classes.dart';

Promise<String> greetAsync(String name) {
  return Promise.value<String>('hello ${name}');
}

Promise<String> chainAsync(String prefix) {
  String greeting = smAwait(greetAsync('world'));
  return Promise.value<String>('${prefix}: ${greeting}');
}

Promise<String> multiAwait(String a, String b) {
  String r1 = smAwait(greetAsync(a));
  String r2 = smAwait(greetAsync(b));
  return Promise.value<String>('${r1} and ${r2}');
}

Promise<String> tryCatchAsync(String input) {
  try {
    if ((input == 'fail')) {
      throw Exception('expected failure');
    }
    String result = smAwait(greetAsync(input));
    return Promise.value<String>('ok: ${result}');
  } on dynamic catch ( e) {
    return Promise.value<String>('caught: ${e}');
  }
}

Promise<String> conditionalAsync(bool flag) {
  if (flag) {
    return Promise.value<String>(smAwait(greetAsync('yes')));
  } else {
    return Promise.value<String>(smAwait(greetAsync('no')));
  }
}

void main() {
  staticPrint('=== async/await 转换验证测试 ===\n');
  staticPrint('--- 1. 基础 async 函数 ---');
  String v1 = smAwait(greetAsync('dart'));
  assert((v1 == 'hello dart'), 'Expected "hello dart", got "${v1}"');
  staticPrint('  ✓ greetAsync("dart") = "${v1}"');
  staticPrint('\n--- 2. 串行 await ---');
  String v2 = smAwait(chainAsync('prefix'));
  assert((v2 == 'prefix: hello world'), 'Unexpected: "${v2}"');
  staticPrint('  ✓ chainAsync("prefix") = "${v2}"');
  staticPrint('\n--- 3. 多个 await ---');
  String v3 = smAwait(multiAwait('alice', 'bob'));
  assert((v3 == 'hello alice and hello bob'), 'Unexpected: "${v3}"');
  staticPrint('  ✓ multiAwait("alice","bob") = "${v3}"');
  staticPrint('\n--- 4. try-catch 中的 await ---');
  String v4a = smAwait(tryCatchAsync('ok_input'));
  assert((v4a == 'ok: hello ok_input'), 'Unexpected: "${v4a}"');
  staticPrint('  ✓ tryCatchAsync("ok_input") = "${v4a}"');
  String v4b = smAwait(tryCatchAsync('fail'));
  assert((v4b == 'caught: Exception: expected failure'), 'Unexpected: "${v4b}"');
  staticPrint('  ✓ tryCatchAsync("fail") = "${v4b}"');
  staticPrint('\n--- 5. 条件分支中的 await ---');
  String v5a = smAwait(conditionalAsync(true));
  String v5b = smAwait(conditionalAsync(false));
  assert((v5a == 'hello yes'), 'Unexpected: "${v5a}"');
  assert((v5b == 'hello no'), 'Unexpected: "${v5b}"');
  staticPrint('  ✓ conditionalAsync(true) = "${v5a}"');
  staticPrint('  ✓ conditionalAsync(false) = "${v5b}"');
  staticPrint('\n=== ✅ 全部 5 个 async/await 测试通过！ ===');
}

