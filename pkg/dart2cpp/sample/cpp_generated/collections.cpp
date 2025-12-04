#include "dart2cpp.h"

// 工具宏定义

Nullable testLists() {
  dart_print(dart_string("\n📌 测试 List 操作"));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"));
auto mixed = dart_literal(dart_int(1), dart_string("hello"), dart_bool(true), dart_double(3.14));
auto emptyList = _GrowableList::(dart_int(0));
dart_print(dart_string("  List 创建:"));
dart_print(dart_concat(dart_string("    数字列表: "), numbers));
dart_print(dart_concat(dart_string("    水果列表: "), fruits));
dart_print(dart_concat(dart_string("    混合列表: "), mixed));
dart_print(dart_concat(dart_string("    空列表: "), emptyList));
dart_print(dart_string("  List 访问:"));
dart_print(dart_concat(dart_string("    第一个数字: "), numbers->[](dart_int(0))));
dart_print(dart_concat(dart_string("    最后一个水果: "), fruits->[]((fruits->size() - dart_int(1)))));
dart_print(dart_concat(dart_string("    使用 first: "), numbers->first));
dart_print(dart_concat(dart_string("    使用 last: "), numbers->last));
numbers->[]=(dart_int(0), dart_int(10));
dart_print(dart_concat(dart_string("  修改后的数字列表: "), numbers));
numbers->add(dart_int(6));
numbers->addAll(dart_literal(dart_int(7), dart_int(8), dart_int(9)));
dart_print(dart_concat(dart_string("  添加元素后: "), numbers));
numbers->insert(dart_int(1), dart_int(15));
numbers->insertAll(dart_int(2), dart_literal(dart_int(11), dart_int(12)));
dart_print(dart_concat(dart_string("  插入元素后: "), numbers));
numbers->remove(dart_int(15));
numbers->removeAt(dart_int(0));
numbers->removeLast();
dart_print(dart_concat(dart_string("  删除元素后: "), numbers));
dart_print(dart_string("  List 属性:"));
dart_print(dart_concat(dart_string("    长度: "), numbers->size()));
dart_print(dart_concat(dart_string("    是否为空: "), emptyList->isEmpty));
dart_print(dart_concat(dart_string("    是否不为空: "), numbers->isNotEmpty));
auto sublist = numbers->sublist(dart_int(1), dart_int(4));
auto reversed = numbers->reversed->toList();
dart_print(dart_concat(dart_string("  子列表 (1,4): "), sublist));
dart_print(dart_concat(dart_string("  反转列表: "), reversed));
dart_print(dart_string("  List 查找:"));
dart_print(dart_concat(dart_string("    包含3: "), numbers->contains(dart_int(3))));
dart_print(dart_concat(dart_string("    索引3的位置: "), numbers->indexOf(dart_int(3))));
dart_print(dart_concat(dart_string("    最后出现3的位置: "), numbers->lastIndexOf(dart_int(3))));
auto unsorted = dart_literal(dart_int(5), dart_int(2), dart_int(8), dart_int(1), dart_int(9), dart_int(3));
unsorted->sort();
dart_print(dart_concat(dart_string("  排序后: "), unsorted));
auto words = dart_literal(dart_string("banana"), dart_string("apple"), dart_string("cherry"), dart_string("date"));
words->sort([&](String a, String b) { return a->size()->compareTo(b->size()); });
dart_print(dart_concat(dart_string("  按长度排序: "), words));
}

Nullable testSets() {
  dart_print(dart_string("\n📌 测试 Set 操作"));
auto numbers = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto colors = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_string("red")); unnamed_var->add(dart_string("green")); unnamed_var->add(dart_string("blue")); return unnamed_var; })();
auto emptySet = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); return unnamed_var; })();
dart_print(dart_string("  Set 创建:"));
dart_print(dart_concat(dart_string("    数字集合: "), numbers));
dart_print(dart_concat(dart_string("    颜色集合: "), colors));
dart_print(dart_concat(dart_string("    空集合: "), emptySet));
numbers->add(dart_int(3));
numbers->add(dart_int(6));
numbers->addAll(dart_literal(dart_int(7), dart_int(8), dart_int(3), dart_int(4)));
dart_print(dart_concat(dart_string("  添加元素后: "), numbers));
numbers->remove(dart_int(1));
dart_print(dart_concat(dart_string("  删除元素1后: "), numbers));
dart_print(dart_string("  Set 检查:"));
dart_print(dart_concat(dart_string("    包含3: "), numbers->contains(dart_int(3))));
dart_print(dart_concat(dart_string("    包含10: "), numbers->contains(dart_int(10))));
dart_print(dart_concat(dart_string("    长度: "), numbers->size()));
dart_print(dart_concat(dart_string("    是否为空: "), emptySet->isEmpty));
auto otherNumbers = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); unnamed_var->add(dart_int(6)); unnamed_var->add(dart_int(7)); unnamed_var->add(dart_int(8)); unnamed_var->add(dart_int(9)); unnamed_var->add(dart_int(10)); return unnamed_var; })();
dart_print(dart_string("  Set 运算:"));
dart_print(dart_concat(dart_string("    原集合: "), numbers));
dart_print(dart_concat(dart_string("    另一集合: "), otherNumbers));
auto union = numbers->union(otherNumbers);
dart_print(dart_concat(dart_string("    并集: "), union));
auto intersection = numbers->intersection(otherNumbers);
dart_print(dart_concat(dart_string("    交集: "), intersection));
auto difference = numbers->difference(otherNumbers);
dart_print(dart_concat(dart_string("    差集: "), difference));
auto numberList = numbers->toList();
dart_print(dart_concat(dart_string("    转为List: "), numberList));
auto duplicates = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(4)); return unnamed_var; })();
dart_print(dart_concat(dart_string("  去重效果: "), duplicates));
}

Nullable testMaps() {
  dart_print(dart_string("\n📌 测试 Map 操作"));
auto scores = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}, {dart_string("Charlie"), dart_int(92)}});
auto person = Map<String, Any>::createFromEntries({{dart_string("name"), dart_string("John")}, {dart_string("age"), dart_int(30)}, {dart_string("isStudent"), dart_bool(false)}, {dart_string("hobbies"), dart_literal(dart_string("reading"), dart_string("swimming"))}});
auto indexMap = Map<Int, String>::createFromEntries({{dart_int(1), dart_string("first")}, {dart_int(2), dart_string("second")}, {dart_int(3), dart_string("third")}});
dart_print(dart_string("  Map 创建:"));
dart_print(dart_concat(dart_string("    分数映射: "), scores));
dart_print(dart_concat(dart_string("    个人信息: "), person));
dart_print(dart_concat(dart_string("    索引映射: "), indexMap));
dart_print(dart_string("  Map 访问:"));
dart_print(dart_concat(dart_string("    Alice的分数: "), scores->[](dart_string("Alice"))));
dart_print(dart_concat(dart_string("    姓名: "), person->[](dart_string("name"))));
dart_print(dart_concat(dart_string("    年龄: "), person->[](dart_string("age"))));
scores->[]=(dart_string("Alice"), dart_int(98));
person->[]=(dart_string("age"), dart_int(31));
dart_print(dart_concat(dart_string("  修改后Alice的分数: "), scores->[](dart_string("Alice"))));
dart_print(dart_concat(dart_string("  修改后年龄: "), person->[](dart_string("age"))));
scores->[]=(dart_string("David"), dart_int(89));
scores->[]=(dart_string("Eve"), dart_int(94));
person->[]=(dart_string("email"), dart_string("john@example.com"));
dart_print(dart_concat(dart_string("  添加后的分数: "), scores));
dart_print(dart_concat(dart_string("  添加邮箱后: "), person->[](dart_string("email"))));
scores->remove(dart_string("Bob"));
person->remove(dart_string("isStudent"));
dart_print(dart_concat(dart_string("  删除Bob后: "), scores));
dart_print(dart_string("  Map 检查:"));
dart_print(dart_concat(dart_string("    包含Charlie键: "), scores->containsKey(dart_string("Charlie"))));
dart_print(dart_concat(dart_string("    包含分数95: "), scores->containsValue(dart_int(95))));
dart_print(dart_concat(dart_string("    包含Frank键: "), scores->containsKey(dart_string("Frank"))));
dart_print(dart_string("  Map 属性:"));
dart_print(dart_concat(dart_string("    键集合: "), scores->keys));
dart_print(dart_concat(dart_string("    值集合: "), scores->values));
dart_print(dart_concat(dart_string("    键值对: "), scores->entries));
dart_print(dart_concat(dart_string("    长度: "), scores->size()));
dart_print(dart_concat(dart_string("    是否为空: "), scores->isEmpty));
auto bonusScores = scores->map([&](String key, Int value) { return ObjectPtr<MapEntry>(new MapEntry(key, (value + dart_int(5)))); });
dart_print(dart_concat(dart_string("  加分后的分数: "), bonusScores));
dart_print(dart_string("  遍历分数:"));
scores->forEach([&](String name, Int score) { dart_print(dart_concat(dart_string("    "), name, dart_string(": "), score, dart_string("分"))); });
}

Nullable testCollectionMethods() {
  dart_print(dart_string("\n📌 测试集合操作方法"));
auto numbers = List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)});
auto doubled = numbers->map([&](Int n) { return (n * dart_int(2)); })->toList();
auto strings = numbers->map([&](Int n) { return dart_concat(dart_string("Number: "), n); })->toList();
dart_print(dart_string("  map 转换:"));
dart_print(dart_concat(dart_string("    翻倍: "), doubled));
dart_print(dart_concat(dart_string("    转字符串: "), strings->take(dart_int(3))->toList(), dart_string("...")));
auto evens = numbers->where([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->toList();
auto greaterThan5 = numbers->where([&](Int n) { return (n > dart_int(5)); })->toList();
dart_print(dart_string("  where 过滤:"));
dart_print(dart_concat(dart_string("    偶数: "), evens));
dart_print(dart_concat(dart_string("    大于5: "), greaterThan5));
auto sum = numbers->reduce([&](Int a, Int b) { return (a + b); });
auto product = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4))->reduce([&](Int a, Int b) { return (a * b); });
dart_print(dart_string("  reduce 归约:"));
dart_print(dart_concat(dart_string("    求和: "), sum));
dart_print(dart_concat(dart_string("    求积: "), product));
auto sumWithInitial = numbers->fold(dart_int(0), [&](Object prev, Int element) { return /* Invalid: temp_dart_source.dart:270:64: Error: The operator '+' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the operator to an existing operator, or defining a '+' operator.
  var sumWithInitial = numbers.fold(0, (prev, element) => prev + element);
                                                               ^ */; });
auto concatenated = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"))->fold(dart_string(""), [&](Object prev, String element) { return /* Invalid: temp_dart_source.dart:271:71: Error: The operator '+' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the operator to an existing operator, or defining a '+' operator.
  var concatenated = ['a', 'b', 'c'].fold('', (prev, element) => prev + element);
                                                                      ^ */; });
dart_print(dart_string("  fold 折叠:"));
dart_print(dart_concat(dart_string("    带初值求和: "), sumWithInitial));
dart_print(dart_concat(dart_string("    字符串连接: "), concatenated));
auto hasEven = numbers->any([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); });
auto hasNegative = numbers->any([&](Int n) { return (n < dart_int(0)); });
dart_print(dart_string("  any 检查:"));
dart_print(dart_concat(dart_string("    有偶数: "), hasEven));
dart_print(dart_concat(dart_string("    有负数: "), hasNegative));
auto allPositive = numbers->every([&](Int n) { return (n > dart_int(0)); });
auto allEven = numbers->every([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); });
dart_print(dart_string("  every 检查:"));
dart_print(dart_concat(dart_string("    都是正数: "), allPositive));
dart_print(dart_concat(dart_string("    都是偶数: "), allEven));
auto firstEven = numbers->firstWhere([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); });
auto lastOdd = numbers->lastWhere([&](Int n) { return ((n % dart_int(2)) == dart_int(1)); });
dart_print(dart_string("  查找元素:"));
dart_print(dart_concat(dart_string("    第一个偶数: "), firstEven));
dart_print(dart_concat(dart_string("    最后一个奇数: "), lastOdd));
auto firstThree = numbers->take(dart_int(3))->toList();
auto skipThree = numbers->skip(dart_int(3))->toList();
auto middleThree = numbers->skip(dart_int(3))->take(dart_int(3))->toList();
dart_print(dart_string("  take/skip 操作:"));
dart_print(dart_concat(dart_string("    前3个: "), firstThree));
dart_print(dart_concat(dart_string("    跳过前3个: "), skipThree->take(dart_int(5))->toList(), dart_string("...")));
dart_print(dart_concat(dart_string("    中间3个: "), middleThree));
auto expanded = dart_literal(dart_int(1), dart_int(2), dart_int(3))->expand([&](Int n) { return dart_literal(n, (n * dart_int(10))); })->toList();
auto words = dart_literal(dart_string("hello"), dart_string("world"))->expand([&](String word) { return word->split(dart_string("")); })->toList();
dart_print(dart_string("  expand 展开:"));
dart_print(dart_concat(dart_string("    数字展开: "), expanded));
dart_print(dart_concat(dart_string("    单词展开: "), words));
}

Nullable testCollectionLiterals() {
  dart_print(dart_string("\n📌 测试集合字面量"));
auto emptyList = _GrowableList::(dart_int(0));
auto numberList = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto stringList = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"));
auto mixedList = dart_literal(dart_int(1), dart_string("hello"), dart_bool(true));
dart_print(dart_string("  List 字面量:"));
dart_print(dart_concat(dart_string("    空列表: "), emptyList));
dart_print(dart_concat(dart_string("    数字列表: "), numberList));
dart_print(dart_concat(dart_string("    字符串列表: "), stringList));
dart_print(dart_concat(dart_string("    混合列表: "), mixedList));
auto emptySet = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); return unnamed_var; })();
auto numberSet = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(1)); return unnamed_var; })();
auto stringSet = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_string("x")); unnamed_var->add(dart_string("y")); unnamed_var->add(dart_string("z")); return unnamed_var; })();
dart_print(dart_string("  Set 字面量:"));
dart_print(dart_concat(dart_string("    空集合: "), emptySet));
dart_print(dart_concat(dart_string("    数字集合: "), numberSet));
dart_print(dart_concat(dart_string("    字符串集合: "), stringSet));
auto emptyMap = Map<String, Int>::create();
auto scoreMap = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}});
auto mixedMap = Map<String, Any>::createFromEntries({{dart_string("name"), dart_string("John")}, {dart_string("age"), dart_int(30)}, {dart_string("scores"), dart_literal(dart_int(95), dart_int(87), dart_int(92))}});
dart_print(dart_string("  Map 字面量:"));
dart_print(dart_concat(dart_string("    空映射: "), emptyMap));
dart_print(dart_concat(dart_string("    分数映射: "), scoreMap));
dart_print(dart_concat(dart_string("    混合映射: "), mixedMap));
auto list1 = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto list2 = dart_literal(dart_int(4), dart_int(5), dart_int(6));
auto combined = ([&]() { const auto unnamed_var = List::of(list1); unnamed_var->addAll(list2); return unnamed_var; })();
auto withExtra = ([&]() { const auto unnamed_var = dart_literal(dart_int(0)); unnamed_var->addAll(list1); unnamed_var->add(dart_int(99)); unnamed_var->addAll(list2); unnamed_var->add(dart_int(100)); return unnamed_var; })();
dart_print(dart_string("  展开操作符:"));
dart_print(dart_concat(dart_string("    合并列表: "), combined));
dart_print(dart_concat(dart_string("    带额外元素: "), withExtra));
auto includeExtra = dart_bool(true);
auto conditionalList = ([&]() { const auto unnamed_var = dart_literal(dart_int(1), dart_int(2), dart_int(3)); if (includeExtra) {
unnamed_var->addAll(dart_literal(dart_int(4), dart_int(5), dart_int(6)));
} unnamed_var->add(dart_int(7)); unnamed_var->add(dart_int(8)); unnamed_var->add(dart_int(9)); return unnamed_var; })();
dart_print(dart_concat(dart_string("    条件展开: "), conditionalList));
auto repeated = ([&]() { const auto unnamed_var = _GrowableList::(dart_int(0)); for (auto i = dart_int(0); (i < dart_int(3)); ++i) {
unnamed_var->add((i * dart_int(2)));
} return unnamed_var; })();
dart_print(dart_concat(dart_string("    循环展开: "), repeated));
auto set1 = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); return unnamed_var; })();
auto set2 = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto combinedSet = ([&]() { const auto unnamed_var = LinkedHashSet::of(set1); unnamed_var->addAll(set2); return unnamed_var; })();
dart_print(dart_concat(dart_string("    合并集合: "), combinedSet));
auto map1 = Map<String, Int>::createFromEntries({{dart_string("a"), dart_int(1)}, {dart_string("b"), dart_int(2)}});
auto map2 = Map<String, Int>::createFromEntries({{dart_string("c"), dart_int(3)}, {dart_string("d"), dart_int(4)}});
auto combinedMap = ([&]() { const auto unnamed_var = LinkedHashMap::of(map1); unnamed_var->addAll(map2); return unnamed_var; })();
dart_print(dart_concat(dart_string("    合并映射: "), combinedMap));
}

Nullable testIterations() {
  dart_print(dart_string("\n📌 测试集合迭代"));
auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"), dart_string("grape"));
auto numbers = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto scores = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}, {dart_string("Charlie"), dart_int(92)}});
dart_print(dart_string("  for-in 循环:"));
dart_print(dart_string("    水果:"));
auto sync_for_iterator = fruits->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto fruit = sync_for_iterator->current;
dart_print(dart_concat(dart_string("      "), fruit));
}
dart_print(dart_string("    数字:"));
auto sync_for_iterator = numbers->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto number = sync_for_iterator->current;
dart_print(dart_concat(dart_string("      "), number));
}
dart_print(dart_string("    分数 (键值对):"));
auto sync_for_iterator = scores->entries->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto entry = sync_for_iterator->current;
dart_print(dart_concat(dart_string("      "), entry->key, dart_string(": "), entry->value));
}
dart_print(dart_string("    分数 (键):"));
auto sync_for_iterator = scores->keys->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto name = sync_for_iterator->current;
dart_print(dart_concat(dart_string("      "), name, dart_string(": "), scores->[](name)));
}
dart_print(dart_string("  forEach 方法:"));
dart_print(dart_string("    水果处理:"));
fruits->forEach([&](String fruit) { return dart_print(dart_concat(dart_string("      处理: "), fruit)); });
dart_print(dart_string("    数字处理:"));
numbers->forEach([&](Int number) { return dart_print(dart_concat(dart_string("      数字: "), number)); });
dart_print(dart_string("    分数处理:"));
scores->forEach([&](String name, Int score) { return dart_print(dart_concat(dart_string("      "), name, dart_string(" 得了 "), score, dart_string(" 分"))); });
dart_print(dart_string("  索引迭代:"));
for (auto i = dart_int(0); (i < fruits->size()); ++i) {
dart_print(dart_concat(dart_string("    索引 "), i, dart_string(": "), fruits->[](i)));
}
dart_print(dart_string("  asMap 索引:"));
fruits->asMap()->forEach([&](Int index, String fruit) { dart_print(dart_concat(dart_string("    位置 "), index, dart_string(": "), fruit)); });
dart_print(dart_string("  迭代器:"));
auto iterator = fruits->iterator;
while (iterator->moveNext()) {
dart_print(dart_concat(dart_string("    迭代器: "), iterator->current));
}
dart_print(dart_string("  链式操作:"));
auto result = numbers->where([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->map([&](Int n) { return (n * n); })->toList();
dart_print(dart_concat(dart_string("    偶数平方: "), result));
auto processed = fruits->where([&](String fruit) { return (fruit->size() > dart_int(5)); })->map([&](String fruit) { return fruit->toUpperCase(); })->toList();
dart_print(dart_concat(dart_string("    长水果名大写: "), processed));
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 集合操作测试开始"));
testLists();
testSets();
testMaps();
testCollectionMethods();
testCollectionLiterals();
testIterations();
dart_print(dart_string("✅ 集合操作测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
