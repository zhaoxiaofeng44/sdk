import 'package:dart2cpp/restorer/runtime_classes.dart';

Promise<String> greetAsync(String name) {
  final env = ClosureEnv_greetAsync_0(name);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> chainAsync(String prefix) {
  final env = ClosureEnv_chainAsync_1(prefix);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> multiAwait(String a, String b) {
  final env = ClosureEnv_multiAwait_2(a, b);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> tryCatchAsync(String input) {
  final env = ClosureEnv_tryCatchAsync_3(input);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> conditionalAsync(bool flag) {
  final env = ClosureEnv_conditionalAsync_4(flag);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

void main() {
  staticPrint('=== async/await 转换验证测试 ===\n');
  staticPrint('--- 1. 基础 async 函数 ---');
  final String v1 = smAwait(greetAsync('dart'));
  assert((v1 == 'hello dart'), 'Expected "hello dart", got "${v1}"');
  staticPrint('  ✓ greetAsync("dart") = "${v1}"');
  staticPrint('\n--- 2. 串行 await ---');
  final String v2 = smAwait(chainAsync('prefix'));
  assert((v2 == 'prefix: hello world'), 'Unexpected: "${v2}"');
  staticPrint('  ✓ chainAsync("prefix") = "${v2}"');
  staticPrint('\n--- 3. 多个 await ---');
  final String v3 = smAwait(multiAwait('alice', 'bob'));
  assert((v3 == 'hello alice and hello bob'), 'Unexpected: "${v3}"');
  staticPrint('  ✓ multiAwait("alice","bob") = "${v3}"');
  staticPrint('\n--- 4. try-catch 中的 await ---');
  final String v4a = smAwait(tryCatchAsync('ok_input'));
  assert((v4a == 'ok: hello ok_input'), 'Unexpected: "${v4a}"');
  staticPrint('  ✓ tryCatchAsync("ok_input") = "${v4a}"');
  final String v4b = smAwait(tryCatchAsync('fail'));
  assert((v4b == 'caught: Exception: expected failure'), 'Unexpected: "${v4b}"');
  staticPrint('  ✓ tryCatchAsync("fail") = "${v4b}"');
  staticPrint('\n--- 5. 条件分支中的 await ---');
  final String v5a = smAwait(conditionalAsync(true));
  final String v5b = smAwait(conditionalAsync(false));
  assert((v5a == 'hello yes'), 'Unexpected: "${v5a}"');
  assert((v5b == 'hello no'), 'Unexpected: "${v5b}"');
  staticPrint('  ✓ conditionalAsync(true) = "${v5a}"');
  staticPrint('  ✓ conditionalAsync(false) = "${v5b}"');
  staticPrint('\n=== ✅ 全部 5 个 async/await 测试通过！ ===');
}

class ClosureEnv_greetAsync_0 {
  StringBox name;
  Promise<String> _promise;
  ClosureEnv_greetAsync_0(String name) : _promise = Promise<String>(), name = StringBox(name);
  void call() => ClosureEnv_greetAsync_0_call(this);
}
void ClosureEnv_greetAsync_0_call(ClosureEnv_greetAsync_0 env) {
  env._promise.complete('hello ${env.name.value}');
  return;
}
class ClosureEnv_chainAsync_1 {
  StringBox prefix;
  Promise<String> _promise;
  ClosureEnv_chainAsync_1(String prefix) : _promise = Promise<String>(), prefix = StringBox(prefix);
  void call() => ClosureEnv_chainAsync_1_call(this);
}
void ClosureEnv_chainAsync_1_call(ClosureEnv_chainAsync_1 env) {
  final String greeting = smAwait(greetAsync('world'));
  env._promise.complete('${env.prefix.value}: ${greeting}');
  return;
}
class ClosureEnv_multiAwait_2 {
  StringBox a;
  StringBox b;
  Promise<String> _promise;
  ClosureEnv_multiAwait_2(String a, String b) : _promise = Promise<String>(), a = StringBox(a), b = StringBox(b);
  void call() => ClosureEnv_multiAwait_2_call(this);
}
void ClosureEnv_multiAwait_2_call(ClosureEnv_multiAwait_2 env) {
  final String r1 = smAwait(greetAsync(env.a.value));
  final String r2 = smAwait(greetAsync(env.b.value));
  env._promise.complete('${r1} and ${r2}');
  return;
}
class ClosureEnv_tryCatchAsync_3 {
  StringBox input;
  Promise<String> _promise;
  ClosureEnv_tryCatchAsync_3(String input) : _promise = Promise<String>(), input = StringBox(input);
  void call() => ClosureEnv_tryCatchAsync_3_call(this);
}
void ClosureEnv_tryCatchAsync_3_call(ClosureEnv_tryCatchAsync_3 env) {
  try {
    if ((env.input.value == 'fail')) {
      throw Exception('expected failure');
    }
    final String result = smAwait(greetAsync(env.input.value));
    env._promise.complete('ok: ${result}');
    return;
  }
 catch (e) {
    env._promise.complete('caught: ${e}');
    return;
  }
}
class ClosureEnv_conditionalAsync_4 {
  BoolBox flag;
  Promise<String> _promise;
  ClosureEnv_conditionalAsync_4(bool flag) : _promise = Promise<String>(), flag = BoolBox(flag);
  void call() => ClosureEnv_conditionalAsync_4_call(this);
}
void ClosureEnv_conditionalAsync_4_call(ClosureEnv_conditionalAsync_4 env) {
  if (env.flag.value) {
    env._promise.complete(smAwait(greetAsync('yes')));
    return;
  }
 else {
    env._promise.complete(smAwait(greetAsync('no')));
    return;
  }
}
