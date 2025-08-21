# CppString 的 Match 实现说明

本文档说明 `pkg/dart2bytecode/lib/demo/string.dart` 中 `CppString` 的匹配对象与匹配方法实现。

## 目标

- 提供纯 `CppString` 环境下的匹配能力（不依赖 `String`/`Match`）：
  - `Iterable<CppStringMatch> allMatches(CppString string, [int start = 0])`
  - `CppStringMatch? matchAsPrefix(CppString string, [int start = 0])`
- 新增 `CppStringMatch`（非 `Match`），`groupCount == 0`，仅支持 `group(0)` 返回整段匹配。

## 关键实现

- `CppString.matchAsPrefix(CppString string, [int start = 0])`
  - 边界检查：`0 <= start <= string.length`
  - 逐字符（codeUnit）比对 `CppString` 与 `CppString` 在 `start` 处是否完全匹配；长度不足直接返回 `null`。
  - 返回 `CppStringMatch(start, string, pattern)`。

- `CppString.allMatches(CppString string, [int start = 0])`
  - 返回 `_CppStringAllMatchesIterable`，惰性地（非重叠）查找所有匹配。
  - 迭代器 `_CppStringAllMatchesIterator` 使用 `string.indexOf(pattern, index)` 寻找下一个匹配。
  - 对空模式做了“空匹配推进”处理：若 `end == index`，则令 `index = end + 1`，保证迭代前进。

- `CppStringMatch`（非 `Match`）
  - `start`、`end`、`input`、`pattern`（均为 `CppString`）。
  - `groupCount == 0`，`group(0)` 返回整段匹配，其余分组抛出 `RangeError`。

## 与标准库关系

- 此实现是纯 `CppString` 版本，不依赖 `String`/`Match`。
- 行为参考 `sdk/lib/_internal/vm/lib/string_patch.dart` 的 `_StringMatch`/`_StringAllMatchesIterable`，但类型完全独立。

## 测试

新增 `pkg/dart2bytecode/test/match_test.dart` 覆盖：

- `matchAsPrefix` 的命中/未命中与起始位移。
- `allMatches` 多次非重叠匹配与空模式行为（应产生 `length + 1` 个匹配）。


