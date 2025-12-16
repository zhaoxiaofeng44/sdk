#include "dart2cpp.h"

// 工具宏定义

Nullable testLists();
Nullable testSets();
Nullable testMaps();
Nullable testCollectionMethods();
Nullable testCollectionLiterals();
Nullable testIterations();
Nullable testLists() {
  dart_print(dart_string("\n📌 测试 List 操作"));
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"));
auto mixed = dart_literal(dart_int(1), dart_string("hello"), dart_bool(true), dart_double(3.14));
auto emptyList = dart_literal(dart_int(0));
dart_print(dart_string("  List 创建:"));
dart_print(dart_string("    数字列表: ") + (numbers).toString());
dart_print(dart_string("    水果列表: ") + (fruits).toString());
dart_print(dart_string("    混合列表: ") + (mixed).toString());
dart_print(dart_string("    空列表: ") + (emptyList).toString());
dart_print(dart_string("  List 访问:"));
dart_print(dart_string("    第一个数字: ") + (numbers->operator_index(dart_int(0))).toString());
dart_print(dart_string("    最后一个水果: ") + (fruits->operator_index(fruits->size()->operator_sub(dart_int(1)))).toString());
dart_print(dart_string("    使用 first: ") + (numbers->first()).toString());
dart_print(dart_string("    使用 last: ") + (numbers->last()).toString());
numbers->operator_index_set(dart_int(0), dart_int(10));
dart_print(dart_string("  修改后的数字列表: ") + (numbers).toString());
numbers->add(dart_int(6));
numbers->addAll(dart_literal(dart_int(7), dart_int(8), dart_int(9)));
dart_print(dart_string("  添加元素后: ") + (numbers).toString());
numbers->insert(dart_int(1), dart_int(15));
numbers->insertAll(dart_int(2), dart_literal(dart_int(11), dart_int(12)));
dart_print(dart_string("  插入元素后: ") + (numbers).toString());
numbers->remove(dart_int(15));
numbers->removeAt(dart_int(0));
numbers->removeLast();
dart_print(dart_string("  删除元素后: ") + (numbers).toString());
dart_print(dart_string("  List 属性:"));
dart_print(dart_string("    长度: ") + (numbers->size()).toString());
dart_print(dart_string("    是否为空: ") + (emptyList->isEmpty()).toString());
dart_print(dart_string("    是否不为空: ") + (numbers->isNotEmpty()).toString());
auto sublist = numbers->sublist(dart_int(1), dart_int(4));
auto reversed = numbers->reversed()->toList();
dart_print(dart_string("  子列表 (1,4): ") + (sublist).toString());
dart_print(dart_string("  反转列表: ") + (reversed).toString());
dart_print(dart_string("  List 查找:"));
dart_print(dart_string("    包含3: ") + (numbers->contains(dart_int(3))).toString());
dart_print(dart_string("    索引3的位置: ") + (numbers->indexOf(dart_int(3))).toString());
dart_print(dart_string("    最后出现3的位置: ") + (numbers->lastIndexOf(dart_int(3))).toString());
auto unsorted = dart_literal(dart_int(5), dart_int(2), dart_int(8), dart_int(1), dart_int(9), dart_int(3));
unsorted->sort();
dart_print(dart_string("  排序后: ") + (unsorted).toString());
auto words = dart_literal(dart_string("banana"), dart_string("apple"), dart_string("cherry"), dart_string("date"));
words->sort(makeFunction([&](String a, String b) { return a->size()->compareTo(b->size()); }));
dart_print(dart_string("  按长度排序: ") + (words).toString());
return Void;
}

Nullable testSets() {
  dart_print(dart_string("\n📌 测试 Set 操作"));
auto numbers = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto colors = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_string("red")); unnamed_var->add(dart_string("green")); unnamed_var->add(dart_string("blue")); return unnamed_var; })();
auto emptySet = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); return unnamed_var; })();
dart_print(dart_string("  Set 创建:"));
dart_print(dart_string("    数字集合: ") + (numbers).toString());
dart_print(dart_string("    颜色集合: ") + (colors).toString());
dart_print(dart_string("    空集合: ") + (emptySet).toString());
numbers->add(dart_int(3));
numbers->add(dart_int(6));
numbers->addAll(dart_literal(dart_int(7), dart_int(8), dart_int(3), dart_int(4)));
dart_print(dart_string("  添加元素后: ") + (numbers).toString());
numbers->remove(dart_int(1));
dart_print(dart_string("  删除元素1后: ") + (numbers).toString());
dart_print(dart_string("  Set 检查:"));
dart_print(dart_string("    包含3: ") + (numbers->contains(dart_int(3))).toString());
dart_print(dart_string("    包含10: ") + (numbers->contains(dart_int(10))).toString());
dart_print(dart_string("    长度: ") + (numbers->size()).toString());
dart_print(dart_string("    是否为空: ") + (emptySet->isEmpty()).toString());
auto otherNumbers = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); unnamed_var->add(dart_int(6)); unnamed_var->add(dart_int(7)); unnamed_var->add(dart_int(8)); unnamed_var->add(dart_int(9)); unnamed_var->add(dart_int(10)); return unnamed_var; })();
dart_print(dart_string("  Set 运算:"));
dart_print(dart_string("    原集合: ") + (numbers).toString());
dart_print(dart_string("    另一集合: ") + (otherNumbers).toString());
auto union = numbers->union(otherNumbers);
dart_print(dart_string("    并集: ") + (union).toString());
auto intersection = numbers->intersection(otherNumbers);
dart_print(dart_string("    交集: ") + (intersection).toString());
auto difference = numbers->difference(otherNumbers);
dart_print(dart_string("    差集: ") + (difference).toString());
auto numberList = numbers->toList();
dart_print(dart_string("    转为List: ") + (numberList).toString());
auto duplicates = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(4)); return unnamed_var; })();
dart_print(dart_string("  去重效果: ") + (duplicates).toString());
return Void;
}

Nullable testMaps() {
  dart_print(dart_string("\n📌 测试 Map 操作"));
auto scores = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}, {dart_string("Charlie"), dart_int(92)}});
auto person = Map<String, Any>::createFromEntries({{dart_string("name"), dart_string("John")}, {dart_string("age"), dart_int(30)}, {dart_string("isStudent"), dart_bool(false)}, {dart_string("hobbies"), dart_literal(dart_string("reading"), dart_string("swimming"))}});
auto indexMap = Map<Int, String>::createFromEntries({{dart_int(1), dart_string("first")}, {dart_int(2), dart_string("second")}, {dart_int(3), dart_string("third")}});
dart_print(dart_string("  Map 创建:"));
dart_print(dart_string("    分数映射: ") + (scores).toString());
dart_print(dart_string("    个人信息: ") + (person).toString());
dart_print(dart_string("    索引映射: ") + (indexMap).toString());
dart_print(dart_string("  Map 访问:"));
dart_print(dart_string("    Alice的分数: ") + (scores->operator_index(dart_string("Alice"))).toString());
dart_print(dart_string("    姓名: ") + (person->operator_index(dart_string("name"))).toString());
dart_print(dart_string("    年龄: ") + (person->operator_index(dart_string("age"))).toString());
scores->operator_index_set(dart_string("Alice"), dart_int(98));
person->operator_index_set(dart_string("age"), dart_int(31));
dart_print(dart_string("  修改后Alice的分数: ") + (scores->operator_index(dart_string("Alice"))).toString());
dart_print(dart_string("  修改后年龄: ") + (person->operator_index(dart_string("age"))).toString());
scores->operator_index_set(dart_string("David"), dart_int(89));
scores->operator_index_set(dart_string("Eve"), dart_int(94));
person->operator_index_set(dart_string("email"), dart_string("john@example.com"));
dart_print(dart_string("  添加后的分数: ") + (scores).toString());
dart_print(dart_string("  添加邮箱后: ") + (person->operator_index(dart_string("email"))).toString());
scores->remove(dart_string("Bob"));
person->remove(dart_string("isStudent"));
dart_print(dart_string("  删除Bob后: ") + (scores).toString());
dart_print(dart_string("  Map 检查:"));
dart_print(dart_string("    包含Charlie键: ") + (scores->containsKey(dart_string("Charlie"))).toString());
dart_print(dart_string("    包含分数95: ") + (scores->containsValue(dart_int(95))).toString());
dart_print(dart_string("    包含Frank键: ") + (scores->containsKey(dart_string("Frank"))).toString());
dart_print(dart_string("  Map 属性:"));
dart_print(dart_string("    键集合: ") + (scores->keys()).toString());
dart_print(dart_string("    值集合: ") + (scores->values()).toString());
dart_print(dart_string("    键值对: ") + (scores->entries()).toString());
dart_print(dart_string("    长度: ") + (scores->size()).toString());
dart_print(dart_string("    是否为空: ") + (scores->isEmpty()).toString());
auto bonusScores = scores->map(makeFunction([&](String key, Int value) { return ObjectPtr<MapEntry>(new MapEntry(key, value->operator_add(dart_int(5)))); }));
dart_print(dart_string("  加分后的分数: ") + (bonusScores).toString());
dart_print(dart_string("  遍历分数:"));
scores->forEach(makeFunction([&](String name, Int score) { dart_print(dart_concat(dart_string("    "), (name).toString(), dart_string(": "), (score).toString(), dart_string("分"))); }));
return Void;
}

Nullable testCollectionMethods() {
  dart_print(dart_string("\n📌 测试集合操作方法"));
auto numbers = List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)});
auto doubled = numbers->map(makeFunction([&](Int n) { return n->operator_mul(dart_int(2)); }))->toList();
auto strings = numbers->map(makeFunction([&](Int n) { return dart_string("Number: ") + (n).toString(); }))->toList();
dart_print(dart_string("  map 转换:"));
dart_print(dart_string("    翻倍: ") + (doubled).toString());
dart_print(dart_concat(dart_string("    转字符串: "), (strings->take(dart_int(3))->toList()).toString(), dart_string("...")));
auto evens = numbers->where(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }))->toList();
auto greaterThan5 = numbers->where(makeFunction([&](Int n) { return n->operator_greater(dart_int(5)); }))->toList();
dart_print(dart_string("  where 过滤:"));
dart_print(dart_string("    偶数: ") + (evens).toString());
dart_print(dart_string("    大于5: ") + (greaterThan5).toString());
auto sum = numbers->reduce(makeFunction([&](Int a, Int b) { return a->operator_add(b); }));
auto product = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4))->reduce(makeFunction([&](Int a, Int b) { return a->operator_mul(b); }));
dart_print(dart_string("  reduce 归约:"));
dart_print(dart_string("    求和: ") + (sum).toString());
dart_print(dart_string("    求积: ") + (product).toString());
auto sumWithInitial = numbers->fold(dart_int(0), makeFunction([&](Int prev, Int element) { return prev->operator_add(element); }));
auto concatenated = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"))->fold(dart_string(""), makeFunction([&](String prev, String element) { return prev->operator_add(element); }));
dart_print(dart_string("  fold 折叠:"));
dart_print(dart_string("    带初值求和: ") + (sumWithInitial).toString());
dart_print(dart_string("    字符串连接: ") + (concatenated).toString());
auto hasEven = numbers->any(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }));
auto hasNegative = numbers->any(makeFunction([&](Int n) { return n->operator_less(dart_int(0)); }));
dart_print(dart_string("  any 检查:"));
dart_print(dart_string("    有偶数: ") + (hasEven).toString());
dart_print(dart_string("    有负数: ") + (hasNegative).toString());
auto allPositive = numbers->every(makeFunction([&](Int n) { return n->operator_greater(dart_int(0)); }));
auto allEven = numbers->every(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }));
dart_print(dart_string("  every 检查:"));
dart_print(dart_string("    都是正数: ") + (allPositive).toString());
dart_print(dart_string("    都是偶数: ") + (allEven).toString());
auto firstEven = numbers->firstWhere(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }));
auto lastOdd = numbers->lastWhere(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(1)); }));
dart_print(dart_string("  查找元素:"));
dart_print(dart_string("    第一个偶数: ") + (firstEven).toString());
dart_print(dart_string("    最后一个奇数: ") + (lastOdd).toString());
auto firstThree = numbers->take(dart_int(3))->toList();
auto skipThree = numbers->skip(dart_int(3))->toList();
auto middleThree = numbers->skip(dart_int(3))->take(dart_int(3))->toList();
dart_print(dart_string("  take/skip 操作:"));
dart_print(dart_string("    前3个: ") + (firstThree).toString());
dart_print(dart_concat(dart_string("    跳过前3个: "), (skipThree->take(dart_int(5))->toList()).toString(), dart_string("...")));
dart_print(dart_string("    中间3个: ") + (middleThree).toString());
auto expanded = dart_literal(dart_int(1), dart_int(2), dart_int(3))->expand(makeFunction([&](Int n) { return dart_literal(n, n->operator_mul(dart_int(10))); }))->toList();
auto words = dart_literal(dart_string("hello"), dart_string("world"))->expand(makeFunction([&](String word) { return word->split(dart_string("")); }))->toList();
dart_print(dart_string("  expand 展开:"));
dart_print(dart_string("    数字展开: ") + (expanded).toString());
dart_print(dart_string("    单词展开: ") + (words).toString());
return Void;
}

Nullable testCollectionLiterals() {
  dart_print(dart_string("\n📌 测试集合字面量"));
auto emptyList = dart_literal(dart_int(0));
auto numberList = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto stringList = dart_literal(dart_string("a"), dart_string("b"), dart_string("c"));
auto mixedList = dart_literal(dart_int(1), dart_string("hello"), dart_bool(true));
dart_print(dart_string("  List 字面量:"));
dart_print(dart_string("    空列表: ") + (emptyList).toString());
dart_print(dart_string("    数字列表: ") + (numberList).toString());
dart_print(dart_string("    字符串列表: ") + (stringList).toString());
dart_print(dart_string("    混合列表: ") + (mixedList).toString());
auto emptySet = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); return unnamed_var; })();
auto numberSet = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(1)); return unnamed_var; })();
auto stringSet = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_string("x")); unnamed_var->add(dart_string("y")); unnamed_var->add(dart_string("z")); return unnamed_var; })();
dart_print(dart_string("  Set 字面量:"));
dart_print(dart_string("    空集合: ") + (emptySet).toString());
dart_print(dart_string("    数字集合: ") + (numberSet).toString());
dart_print(dart_string("    字符串集合: ") + (stringSet).toString());
auto emptyMap = Map<String, Int>::create();
auto scoreMap = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}});
auto mixedMap = Map<String, Any>::createFromEntries({{dart_string("name"), dart_string("John")}, {dart_string("age"), dart_int(30)}, {dart_string("scores"), dart_literal(dart_int(95), dart_int(87), dart_int(92))}});
dart_print(dart_string("  Map 字面量:"));
dart_print(dart_string("    空映射: ") + (emptyMap).toString());
dart_print(dart_string("    分数映射: ") + (scoreMap).toString());
dart_print(dart_string("    混合映射: ") + (mixedMap).toString());
auto list1 = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto list2 = dart_literal(dart_int(4), dart_int(5), dart_int(6));
auto combined = ([&]() { const auto unnamed_var = List::of(list1, Bool(Null)); unnamed_var->addAll(list2); return unnamed_var; })();
auto withExtra = ([&]() { const auto unnamed_var = dart_literal(dart_int(0)); unnamed_var->addAll(list1); unnamed_var->add(dart_int(99)); unnamed_var->addAll(list2); unnamed_var->add(dart_int(100)); return unnamed_var; })();
dart_print(dart_string("  展开操作符:"));
dart_print(dart_string("    合并列表: ") + (combined).toString());
dart_print(dart_string("    带额外元素: ") + (withExtra).toString());
auto includeExtra = dart_bool(true);
auto conditionalList = ([&]() { const auto unnamed_var = dart_literal(dart_int(1), dart_int(2), dart_int(3)); if (includeExtra) {
unnamed_var->addAll(dart_literal(dart_int(4), dart_int(5), dart_int(6)));
} unnamed_var->add(dart_int(7)); unnamed_var->add(dart_int(8)); unnamed_var->add(dart_int(9)); return unnamed_var; })();
dart_print(dart_string("    条件展开: ") + (conditionalList).toString());
auto repeated = ([&]() { const auto unnamed_var = dart_literal(dart_int(0)); for (auto i = dart_int(0); i->operator_less(dart_int(3)); i = i->operator_add(dart_int(1))) {
unnamed_var->add(i->operator_mul(dart_int(2)));
} return unnamed_var; })();
dart_print(dart_string("    循环展开: ") + (repeated).toString());
auto set1 = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); return unnamed_var; })();
auto set2 = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto combinedSet = ([&]() { const auto unnamed_var = LinkedHashSet::of(set1); unnamed_var->addAll(set2); return unnamed_var; })();
dart_print(dart_string("    合并集合: ") + (combinedSet).toString());
auto map1 = Map<String, Int>::createFromEntries({{dart_string("a"), dart_int(1)}, {dart_string("b"), dart_int(2)}});
auto map2 = Map<String, Int>::createFromEntries({{dart_string("c"), dart_int(3)}, {dart_string("d"), dart_int(4)}});
auto combinedMap = ([&]() { const auto unnamed_var = LinkedHashMap::of(map1); unnamed_var->addAll(map2); return unnamed_var; })();
dart_print(dart_string("    合并映射: ") + (combinedMap).toString());
return Void;
}

Nullable testIterations() {
  dart_print(dart_string("\n📌 测试集合迭代"));
auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"), dart_string("grape"));
auto numbers = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto scores = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}, {dart_string("Charlie"), dart_int(92)}});
dart_print(dart_string("  for-in 循环:"));
dart_print(dart_string("    水果:"));
auto sync_for_iterator = fruits->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto fruit = sync_for_iterator->next();
dart_print(dart_string("      ") + (fruit).toString());
}
dart_print(dart_string("    数字:"));
auto sync_for_iterator = numbers->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto number = sync_for_iterator->next();
dart_print(dart_string("      ") + (number).toString());
}
dart_print(dart_string("    分数 (键值对):"));
auto sync_for_iterator = scores->entries()->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto entry = sync_for_iterator->next();
dart_print(dart_concat(dart_string("      "), (entry->key).toString(), dart_string(": "), (entry->value).toString()));
}
dart_print(dart_string("    分数 (键):"));
auto sync_for_iterator = scores->keys()->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto name = sync_for_iterator->next();
dart_print(dart_concat(dart_string("      "), (name).toString(), dart_string(": "), (scores->operator_index(name)).toString()));
}
dart_print(dart_string("  forEach 方法:"));
dart_print(dart_string("    水果处理:"));
fruits->forEach(makeFunction([&](String fruit) { return dart_print(dart_string("      处理: ") + (fruit).toString()); }));
dart_print(dart_string("    数字处理:"));
numbers->forEach(makeFunction([&](Int number) { return dart_print(dart_string("      数字: ") + (number).toString()); }));
dart_print(dart_string("    分数处理:"));
scores->forEach(makeFunction([&](String name, Int score) { return dart_print(dart_concat(dart_string("      "), (name).toString(), dart_string(" 得了 "), (score).toString(), dart_string(" 分"))); }));
dart_print(dart_string("  索引迭代:"));
for (auto i = dart_int(0); i->operator_less(fruits->size()); i = i->operator_add(dart_int(1))) {
dart_print(dart_concat(dart_string("    索引 "), (i).toString(), dart_string(": "), (fruits->operator_index(i)).toString()));
}
dart_print(dart_string("  asMap 索引:"));
fruits->asMap()->forEach(makeFunction([&](Int index, String fruit) { dart_print(dart_concat(dart_string("    位置 "), (index).toString(), dart_string(": "), (fruit).toString())); }));
dart_print(dart_string("  迭代器:"));
auto iterator = fruits->iterator();
while (iterator->hasNext()) {
dart_print(dart_string("    迭代器: ") + (iterator->next()).toString());
}
dart_print(dart_string("  链式操作:"));
auto result = numbers->where(makeFunction([&](Int n) { return (n->operator_mod(dart_int(2)) == dart_int(0)); }))->map(makeFunction([&](Int n) { return n->operator_mul(n); }))->toList();
dart_print(dart_string("    偶数平方: ") + (result).toString());
auto processed = fruits->where(makeFunction([&](String fruit) { return fruit->size()->operator_greater(dart_int(5)); }))->map(makeFunction([&](String fruit) { return fruit->toUpperCase(); }))->toList();
dart_print(dart_string("    长水果名大写: ") + (processed).toString());
return Void;
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
