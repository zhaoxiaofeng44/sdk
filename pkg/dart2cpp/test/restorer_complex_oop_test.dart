// ============================================================================
// 复杂 OOP 边界测试用例
// 覆盖 mixin lowering / vptr / 继承链 的高难度边界场景
// ============================================================================

// ============================================================================
// 场景 1: 菱形继承 — 多个 mixin 提供同名方法，最后一个 mixin 胜出
// ============================================================================
mixin Logger {
  String get prefix => 'LOG';
  String format(String msg) => '[$prefix] $msg';
}

mixin Formatter {
  String get prefix => 'FMT';
  String format(String msg) => '{$prefix: $msg}';
}

// DiamondClass with Logger, Formatter → Formatter.format 胜出（最后一个 mixin）
class DiamondClass with Logger, Formatter {
  final String name;
  DiamondClass(this.name);

  String display(String msg) => '$name: ${format(msg)}';
}

// ============================================================================
// 场景 2: mixin 中互相调用 getter/setter + 方法链
// ============================================================================
mixin StatefulMixin {
  int _counter = 0;

  int get counter => _counter;
  set counter(int value) => _counter = value;

  void increment() => counter = counter + 1;
  void decrement() => counter = counter - 1;

  String get counterStatus => 'count=$counter';
}

class StatefulWidget with StatefulMixin {
  final String id;
  StatefulWidget(this.id);

  @override
  String toString() => 'Widget($id, $counterStatus)';
}

// ============================================================================
// 场景 3: 深层 mixin 链 — M3 覆盖 M1 的方法，M2 不覆盖
// ============================================================================
mixin LayerA {
  String layer() => 'A';
  String onlyA() => 'onlyA';
}

mixin LayerB {
  String layer() => 'B';
  String onlyB() => 'onlyB';
}

mixin LayerC {
  String layer() => 'C';
  String onlyC() => 'onlyC';
}

// 最终 layer() 来自 LayerC（最后一个 mixin）
class DeepMixinClass with LayerA, LayerB, LayerC {
  String allLayers() => '${layer()}-${onlyA()}-${onlyB()}-${onlyC()}';
}

// ============================================================================
// 场景 4: 泛型类 + 泛型 mixin 组合
// ============================================================================
mixin Mappable<T> {
  T get value;
  R mapValue<R>(R Function(T) transform) => transform(value);
  String describe() => 'Mappable<$T>($value)';
}

mixin Filterable<T> {
  T get value;
  bool test(bool Function(T) predicate) => predicate(value);
}

class Box<T> with Mappable<T>, Filterable<T> {
  @override
  final T value;

  Box(this.value);

  @override
  String toString() => 'Box($value)';
}

// ============================================================================
// 场景 5: 抽象类 + mixin + implements 三合一
// ============================================================================
abstract class Identifiable {
  String get id;
}

abstract class Describable {
  String describe();
}

mixin Taggable {
  final List<String> _tags = [];
  void tag(String t) => _tags.add(t);
  List<String> get allTags => List.unmodifiable(_tags);
  bool hasTag(String t) => _tags.contains(t);
}

class Resource implements Identifiable, Describable {
  @override
  final String id;
  final String type;

  Resource(this.id, this.type);

  @override
  String describe() => 'Resource($id, type=$type)';
}

class TaggedResource extends Resource with Taggable {
  TaggedResource(super.id, super.type);

  @override
  String describe() => '${super.describe()}, tags=$allTags';
}

// ============================================================================
// 场景 6: 子类重写父类方法并调用 super
// ============================================================================
class BaseProcessor {
  String process(String input) => input.trim();
  String get processorName => 'Base';
}

class UpperProcessor extends BaseProcessor {
  @override
  String process(String input) => super.process(input).toUpperCase();

  @override
  String get processorName => '${super.processorName}->Upper';
}

class PrefixProcessor extends UpperProcessor {
  final String prefix;
  PrefixProcessor(this.prefix);

  @override
  String process(String input) => '$prefix:${super.process(input)}';

  @override
  String get processorName => '${super.processorName}->Prefix($prefix)';
}

// ============================================================================
// 场景 7: mixin 中定义 operator
// ============================================================================
mixin Addable {
  int get numericValue;
  int addValues(int other) => numericValue + other;
  int doubleValue() => addValues(numericValue);
}

class Amount with Addable {
  @override
  final int numericValue;

  Amount(this.numericValue);

  Amount operator +(Amount other) => Amount(numericValue + other.numericValue);
  Amount operator -(Amount other) => Amount(numericValue - other.numericValue);
  bool operator <(Amount other) => numericValue < other.numericValue;
  bool operator >(Amount other) => numericValue > other.numericValue;

  @override
  String toString() => 'Amount($numericValue)';
}

// ============================================================================
// 场景 8: 多层继承中的 toString 链 + mixin 覆盖 toString
// ============================================================================
mixin Printable2 {
  String toPrettyString();
  void prettyPrint() => print('>> ${toPrettyString()}');
}

class Vehicle {
  final String make;
  final int year;

  Vehicle(this.make, this.year);

  @override
  String toString() => 'Vehicle($make, $year)';
}

class Car extends Vehicle with Printable2 {
  final int doors;

  Car(super.make, super.year, this.doors);

  @override
  String toPrettyString() => 'Car[$make, $year, ${doors}dr]';

  @override
  String toString() => 'Car($make, $year, ${doors}dr)';
}

class ElectricCar extends Car {
  final int range;

  ElectricCar(super.make, super.year, super.doors, this.range);

  @override
  String toPrettyString() => '${super.toPrettyString()}+EV(${range}km)';

  @override
  String toString() => 'ElectricCar($make, $year, ${doors}dr, ${range}km)';
}

// ============================================================================
// 场景 9: 泛型约束 + mixin on 约束组合
// ============================================================================
abstract class Measurable {
  double measure();
}

mixin Scalable on Measurable {
  double scale(double factor) => measure() * factor;
  String measureInfo() => 'measure=${measure().toStringAsFixed(1)}';
}

class Segment extends Measurable with Scalable {
  final double length;
  Segment(this.length);

  @override
  double measure() => length;

  @override
  String toString() => 'Segment($length, ${measureInfo()})';
}

class WeightedSegment extends Segment {
  final double weight;
  WeightedSegment(super.length, this.weight);

  @override
  double measure() => length * weight;

  @override
  String toString() => 'WeightedSegment(len=$length, w=$weight, ${measureInfo()})';
}

// ============================================================================
// 场景 10: 多个 mixin 共享同名 getter，子类覆盖
// ============================================================================
mixin NamedMixin {
  String get label => 'NamedMixin';
  String greet() => 'Hello from $label';
}

mixin DescribedMixin {
  String get label => 'DescribedMixin';
  String info() => 'Info: $label';
}

class MultiMixinEntity with NamedMixin, DescribedMixin {
  @override
  String get label => 'Entity';

  String fullInfo() => '${greet()} | ${info()}';
}

// ============================================================================
// 场景 11: 接口默认实现被 mixin 覆盖 + 子类再覆盖
// ============================================================================
abstract class Encoder {
  String encode(String input);
}

mixin Base64Mixin implements Encoder {
  @override
  String encode(String input) => 'base64($input)';
}

mixin HexMixin implements Encoder {
  @override
  String encode(String input) => 'hex($input)';
}

class MultiEncoder with Base64Mixin, HexMixin {
  // HexMixin 胜出
  String encodeAll(String input) => encode(input);
}

class CustomEncoder extends MultiEncoder {
  @override
  String encode(String input) => 'custom(${super.encode(input)})';
}

// ============================================================================
// 场景 12: 复杂泛型继承链 + 方法覆盖
// ============================================================================
class Container<T> {
  final T item;
  Container(this.item);

  String describe() => 'Container<$T>($item)';
  T get content => item;
}

class LabeledContainer<T> extends Container<T> {
  final String label;
  LabeledContainer(super.item, this.label);

  @override
  String describe() => 'Labeled[$label]: ${super.describe()}';
}

class PriorityContainer<T> extends LabeledContainer<T> {
  final int priority;
  PriorityContainer(super.item, super.label, this.priority);

  @override
  String describe() => '(P$priority) ${super.describe()}';
}

// ============================================================================
// 场景 13: mixin 中使用 this 的方法互相调用形成调用链
// ============================================================================
mixin ChainMixin {
  String step1() => 'S1';
  String step2() => '${step1()}->S2';
  String step3() => '${step2()}->S3';
  String fullChain() => '${step3()}->done';
}

class ChainClass with ChainMixin {
  @override
  String step1() => 'X1';
  // step2, step3, fullChain 继承自 mixin，但 step1 被覆盖
  // 所以 fullChain() 应该是 X1->S2->S3->done
}

class ChainSubClass extends ChainClass {
  @override
  String step2() => '${step1()}->Y2';
  // fullChain() 应该是 X1->Y2->S3->done
}

// ============================================================================
// 场景 14: 抽象类层级 + 工厂构造函数 + 多态
// ============================================================================
abstract class Expression2 {
  double evaluate();
  String display();
}

class NumberExpr extends Expression2 {
  final double value;
  NumberExpr(this.value);

  @override
  double evaluate() => value;

  @override
  String display() => value == value.toInt() ? '${value.toInt()}' : '$value';
}

class BinaryExpr extends Expression2 {
  final Expression2 left;
  final Expression2 right;
  final String op;
  final double Function(double, double) _compute;

  BinaryExpr(this.left, this.right, this.op, this._compute);

  factory BinaryExpr.add(Expression2 l, Expression2 r) =>
      BinaryExpr(l, r, '+', (a, b) => a + b);

  factory BinaryExpr.mul(Expression2 l, Expression2 r) =>
      BinaryExpr(l, r, '*', (a, b) => a * b);

  @override
  double evaluate() => _compute(left.evaluate(), right.evaluate());

  @override
  String display() => '(${left.display()} $op ${right.display()})';
}

// ============================================================================
// 场景 15: 多个 mixin 各自有 getter，子类通过 super 链调用
// ============================================================================
mixin HealthMixin {
  int get maxHealth => 100;
  int get health => maxHealth;
  String healthBar() => 'HP:$health/$maxHealth';
}

mixin ManaMixin {
  int get maxMana => 50;
  int get mana => maxMana;
  String manaBar() => 'MP:$mana/$maxMana';
}

mixin StaminaMixin {
  int get maxStamina => 80;
  int get stamina => maxStamina;
  String staminaBar() => 'SP:$stamina/$maxStamina';
}

class GameCharacter with HealthMixin, ManaMixin, StaminaMixin {
  final String name;
  GameCharacter(this.name);

  String statusBars() => '$name: ${healthBar()} ${manaBar()} ${staminaBar()}';
}

class Warrior extends GameCharacter {
  Warrior(super.name);

  @override
  int get maxHealth => 150;

  @override
  int get maxStamina => 120;
}

class Mage extends GameCharacter {
  Mage(super.name);

  @override
  int get maxMana => 200;

  @override
  int get maxHealth => 60;
}

// ============================================================================
// 主函数：综合测试
// ============================================================================
void main() {
  print('=== 复杂 OOP 边界测试 ===\n');

  // ---- 场景 1: 菱形继承 ----
  print('--- 1. 菱形继承 ---');
  final diamond = DiamondClass('DC');
  print('prefix: ${diamond.prefix}');
  print('format: ${diamond.format("hello")}');
  print('display: ${diamond.display("world")}');

  // ---- 场景 2: mixin 中 getter/setter 互调 ----
  print('\n--- 2. StatefulMixin ---');
  final widget = StatefulWidget('btn1');
  print('initial: $widget');
  widget.increment();
  widget.increment();
  widget.increment();
  print('after 3 inc: $widget');
  widget.decrement();
  print('after 1 dec: $widget');
  widget.counter = 10;
  print('after set 10: $widget');

  // ---- 场景 3: 深层 mixin 链 ----
  print('\n--- 3. 深层 mixin 链 ---');
  final deep = DeepMixinClass();
  print('layer: ${deep.layer()}');
  print('allLayers: ${deep.allLayers()}');

  // ---- 场景 4: 泛型类 + 泛型 mixin ----
  print('\n--- 4. 泛型 mixin ---');
  final intBox = Box<int>(42);
  print('intBox: $intBox');
  print('describe: ${intBox.describe()}');
  print('mapValue: ${intBox.mapValue((v) => v * 2)}');
  print('test >10: ${intBox.test((v) => v > 10)}');
  print('test >100: ${intBox.test((v) => v > 100)}');
  final strBox = Box<String>('dart');
  print('strBox mapValue: ${strBox.mapValue((s) => s.toUpperCase())}');

  // ---- 场景 5: 抽象类 + mixin + implements ----
  print('\n--- 5. 抽象+mixin+implements ---');
  final res = TaggedResource('r1', 'file');
  res.tag('important');
  res.tag('v2');
  print('describe: ${res.describe()}');
  print('id: ${res.id}');
  print('hasTag important: ${res.hasTag("important")}');
  print('hasTag draft: ${res.hasTag("draft")}');

  // ---- 场景 6: super 调用链 ----
  print('\n--- 6. super 调用链 ---');
  final base = BaseProcessor();
  print('base: ${base.process("  hello  ")} (${base.processorName})');
  final upper = UpperProcessor();
  print('upper: ${upper.process("  hello  ")} (${upper.processorName})');
  final prefix = PrefixProcessor('PRE');
  print('prefix: ${prefix.process("  hello  ")} (${prefix.processorName})');

  // ---- 场景 7: mixin + operator ----
  print('\n--- 7. mixin + operator ---');
  final a1 = Amount(10);
  final a2 = Amount(5);
  print('a1 + a2: ${a1 + a2}');
  print('a1 - a2: ${a1 - a2}');
  print('a1 < a2: ${a1 < a2}');
  print('a1 > a2: ${a1 > a2}');
  print('doubleValue: ${a1.doubleValue()}');
  print('addValues: ${a1.addValues(3)}');

  // ---- 场景 8: 多层继承 toString + mixin ----
  print('\n--- 8. 多层继承+mixin ---');
  final car = Car('Toyota', 2024, 4);
  print('car: $car');
  car.prettyPrint();
  final ev = ElectricCar('Tesla', 2025, 4, 500);
  print('ev: $ev');
  ev.prettyPrint();

  // ---- 场景 9: mixin on 约束 + 泛型 ----
  print('\n--- 9. mixin on 约束 ---');
  final seg = Segment(10.0);
  print('seg: $seg');
  print('scale(2): ${seg.scale(2.0)}');
  final wseg = WeightedSegment(10.0, 0.5);
  print('wseg: $wseg');
  print('wseg.scale(3): ${wseg.scale(3.0)}');

  // ---- 场景 10: 多 mixin 同名 getter ----
  print('\n--- 10. 多 mixin 同名 getter ---');
  final entity = MultiMixinEntity();
  print('label: ${entity.label}');
  print('greet: ${entity.greet()}');
  print('info: ${entity.info()}');
  print('fullInfo: ${entity.fullInfo()}');

  // ---- 场景 11: 接口被 mixin 覆盖 ----
  print('\n--- 11. 接口+mixin 覆盖 ---');
  final multi = MultiEncoder();
  print('multi.encode: ${multi.encode("abc")}');
  print('multi.encodeAll: ${multi.encodeAll("xyz")}');
  final custom = CustomEncoder();
  print('custom.encode: ${custom.encode("abc")}');
  print('custom.encodeAll: ${custom.encodeAll("xyz")}');

  // ---- 场景 12: 复杂泛型继承链 ----
  print('\n--- 12. 泛型继承链 ---');
  final c1 = Container<int>(42);
  print('c1: ${c1.describe()}');
  final c2 = LabeledContainer<String>('hello', 'greeting');
  print('c2: ${c2.describe()}');
  final c3 = PriorityContainer<double>(3.14, 'pi', 1);
  print('c3: ${c3.describe()}');
  print('c3.content: ${c3.content}');

  // ---- 场景 13: mixin 方法调用链 + 子类覆盖中间步骤 ----
  print('\n--- 13. mixin 调用链 ---');
  final chain1 = ChainClass();
  print('chain1.fullChain: ${chain1.fullChain()}');
  print('chain1.step3: ${chain1.step3()}');
  final chain2 = ChainSubClass();
  print('chain2.fullChain: ${chain2.fullChain()}');
  print('chain2.step3: ${chain2.step3()}');

  // ---- 场景 14: 抽象类 + 工厂构造函数 + 多态 ----
  print('\n--- 14. 表达式树 ---');
  final expr = BinaryExpr.add(
    NumberExpr(3),
    BinaryExpr.mul(NumberExpr(4), NumberExpr(5)),
  );
  print('expr: ${expr.display()}');
  print('result: ${expr.evaluate()}');

  // ---- 场景 15: 多 mixin 各自 getter + 子类覆盖 ----
  print('\n--- 15. 游戏角色 ---');
  final hero = GameCharacter('Hero');
  print(hero.statusBars());
  final warrior = Warrior('Conan');
  print(warrior.statusBars());
  final mage = Mage('Gandalf');
  print(mage.statusBars());

  print('\n=== 所有复杂 OOP 测试通过 ✅ ===');
}
