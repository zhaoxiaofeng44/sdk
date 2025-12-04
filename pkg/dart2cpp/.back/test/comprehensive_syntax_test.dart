/// Comprehensive Dart Syntax Test Suite
///
/// This file tests all major Dart language features to ensure
/// proper conversion to C++ code.

void main() {
  print('=== Comprehensive Dart to C++ Syntax Test ===\n');

  testBasicTypes();
  testArithmeticOperators();
  testComparisonOperators();
  testLogicalOperators();
  testStringOperations();
  testListOperations();
  testMapOperations();
  testSetOperations();
  testControlFlow();
  testFunctions();
  testClasses();
  testInheritance();
  testExceptionHandling();
  testTypeConversions();
  testNullSafety();

  print('\n=== All Tests Completed ===');
}

// ============================================================================
// 1. Basic Types Tests
// ============================================================================

void testBasicTypes() {
  print('Test 1: Basic Types');

  // Integer
  int intValue = 42;
  int negativeInt = -10;
  int zero = 0;

  // Double
  double doubleValue = 3.14159;
  double negativeDouble = -2.5;
  double scientificNotation = 1.5e3;

  // Boolean
  bool trueValue = true;
  bool falseValue = false;

  // String
  String simpleString = 'Hello';
  String doubleQuoteString = "World";
  String emptyString = '';

  print('  Int: $intValue, $negativeInt, $zero');
  print('  Double: $doubleValue, $negativeDouble, $scientificNotation');
  print('  Bool: $trueValue, $falseValue');
  print('  String: $simpleString, $doubleQuoteString, "$emptyString"');
  print('  ✓ Basic types test passed\n');
}

// ============================================================================
// 2. Arithmetic Operators Tests
// ============================================================================

void testArithmeticOperators() {
  print('Test 2: Arithmetic Operators');

  int a = 10;
  int b = 3;

  // Basic arithmetic
  int sum = a + b;
  int difference = a - b;
  int product = a * b;
  double quotient = a / b;
  int remainder = a % b;
  int intDivision = a ~/ b;

  // Unary operators
  int positive = a;
  int negative = -a;

  // Increment/Decrement
  int x = 5;
  x++;
  int y = 10;
  y--;

  // Compound assignment
  int c = 10;
  c += 5;
  c -= 2;
  c *= 2;
  c ~/= 3;

  print('  Addition: $sum');
  print('  Subtraction: $difference');
  print('  Multiplication: $product');
  print('  Division: $quotient');
  print('  Remainder: $remainder');
  print('  Integer Division: $intDivision');
  print('  Unary: $positive, -$negative');
  print('  Increment: $x, Decrement: $y');
  print('  Compound: $c');
  print('  ✓ Arithmetic operators test passed\n');
}

// ============================================================================
// 3. Comparison Operators Tests
// ============================================================================

void testComparisonOperators() {
  print('Test 3: Comparison Operators');

  int a = 10;
  int b = 20;
  int c = 10;

  bool equal = (a == c);
  bool notEqual = (a != b);
  bool lessThan = (a < b);
  bool lessOrEqual = (a <= c);
  bool greaterThan = (b > a);
  bool greaterOrEqual = (a >= c);

  print('  Equal (10 == 10): $equal');
  print('  Not Equal (10 != 20): $notEqual');
  print('  Less Than (10 < 20): $lessThan');
  print('  Less Or Equal (10 <= 10): $lessOrEqual');
  print('  Greater Than (20 > 10): $greaterThan');
  print('  Greater Or Equal (10 >= 10): $greaterOrEqual');
  print('  ✓ Comparison operators test passed\n');
}

// ============================================================================
// 4. Logical Operators Tests
// ============================================================================

void testLogicalOperators() {
  print('Test 4: Logical Operators');

  bool t = true;
  bool f = false;

  bool andResult = t && f;
  bool orResult = t || f;
  bool notResult = !t;

  // Short-circuit evaluation
  bool shortCircuitAnd = f && t;
  bool shortCircuitOr = t || f;

  print('  AND (true && false): $andResult');
  print('  OR (true || false): $orResult');
  print('  NOT (!true): $notResult');
  print('  Short-circuit AND: $shortCircuitAnd');
  print('  Short-circuit OR: $shortCircuitOr');
  print('  ✓ Logical operators test passed\n');
}

// ============================================================================
// 5. String Operations Tests
// ============================================================================

void testStringOperations() {
  print('Test 5: String Operations');

  String str1 = 'Hello';
  String str2 = 'World';

  // Concatenation
  String concat = str1 + ' ' + str2;

  // String interpolation
  int value = 42;
  String interpolated = 'The answer is $value';
  String expression = 'Sum: ${10 + 20}';

  // String properties
  int length = str1.length;
  bool isEmpty = emptyString.isEmpty;
  bool isNotEmpty = str1.isNotEmpty;

  // String methods
  String upper = str1.toUpperCase();
  String lower = str2.toLowerCase();
  String trimmed = '  spaces  '.trim();
  String substring = str1.substring(0, 4);
  bool contains = str1.contains('ell');
  bool startsWith = str1.startsWith('He');
  bool endsWith = str1.endsWith('lo');
  int indexOf = str1.indexOf('l');
  String replaced = str1.replaceAll('l', 'L');

  print('  Concatenation: $concat');
  print('  Interpolation: $interpolated');
  print('  Expression: $expression');
  print('  Length: $length');
  print('  isEmpty: $isEmpty, isNotEmpty: $isNotEmpty');
  print('  Upper: $upper, Lower: $lower');
  print('  Trimmed: "$trimmed"');
  print('  Substring: $substring');
  print('  Contains: $contains');
  print('  StartsWith: $startsWith, EndsWith: $endsWith');
  print('  IndexOf: $indexOf');
  print('  Replaced: $replaced');
  print('  ✓ String operations test passed\n');
}

String emptyString = '';

// ============================================================================
// 6. List Operations Tests
// ============================================================================

void testListOperations() {
  print('Test 6: List Operations');

  // List creation
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> fruits = ['apple', 'banana', 'orange'];
  List<int> emptyList = [];

  // List properties
  int length = numbers.length;
  bool isEmpty = emptyList.isEmpty;
  bool isNotEmpty = numbers.isNotEmpty;
  int first = numbers.first;
  int last = numbers.last;

  // List methods
  numbers.add(6);
  numbers.addAll([7, 8]);
  numbers.insert(0, 0);
  bool contains = numbers.contains(5);
  int indexOf = numbers.indexOf(3);

  // List access
  int element = numbers[2];
  numbers[2] = 99;

  // List iteration
  int sum = 0;
  for (int i = 0; i < numbers.length; i++) {
    sum += numbers[i];
  }

  print('  Numbers: $numbers');
  print('  Fruits: $fruits');
  print('  Length: $length');
  print('  isEmpty: $isEmpty, isNotEmpty: $isNotEmpty');
  print('  First: $first, Last: $last');
  print('  Contains 5: $contains');
  print('  IndexOf 3: $indexOf');
  print('  Element at [2]: $element');
  print('  Sum: $sum');
  print('  ✓ List operations test passed\n');
}

// ============================================================================
// 7. Map Operations Tests
// ============================================================================

void testMapOperations() {
  print('Test 7: Map Operations');

  // Map creation
  Map<String, int> scores = {'Alice': 95, 'Bob': 87, 'Charlie': 92};
  Map<String, String> emptyMap = {};

  // Map properties
  int length = scores.length;
  bool isEmpty = emptyMap.isEmpty;
  bool isNotEmpty = scores.isNotEmpty;

  // Map methods
  scores['David'] = 89;
  bool containsKey = scores.containsKey('Alice');
  bool containsValue = scores.containsValue(95);
  int? aliceScore = scores['Alice'];

  // Map iteration
  int totalScore = 0;
  for (String key in scores.keys) {
    totalScore += scores[key]!;
  }

  print('  Scores: $scores');
  print('  Length: $length');
  print('  isEmpty: $isEmpty, isNotEmpty: $isNotEmpty');
  print('  ContainsKey Alice: $containsKey');
  print('  ContainsValue 95: $containsValue');
  print('  Alice Score: $aliceScore');
  print('  Total Score: $totalScore');
  print('  ✓ Map operations test passed\n');
}

// ============================================================================
// 8. Set Operations Tests
// ============================================================================

void testSetOperations() {
  print('Test 8: Set Operations');

  // Set creation
  Set<int> numbers = {1, 2, 3, 4, 5};
  Set<String> fruits = {'apple', 'banana', 'orange'};
  Set<int> emptySet = {};

  // Set properties
  int length = numbers.length;
  bool isEmpty = emptySet.isEmpty;
  bool isNotEmpty = numbers.isNotEmpty;

  // Set methods
  numbers.add(6);
  numbers.add(3); // Duplicate, won't be added
  numbers.addAll({7, 8});
  bool contains = numbers.contains(5);

  // Set operations
  Set<int> set1 = {1, 2, 3};
  Set<int> set2 = {3, 4, 5};
  Set<int> union = set1.union(set2);
  Set<int> intersection = set1.intersection(set2);
  Set<int> difference = set1.difference(set2);

  print('  Numbers: $numbers');
  print('  Fruits: $fruits');
  print('  Length: $length');
  print('  isEmpty: $isEmpty, isNotEmpty: $isNotEmpty');
  print('  Contains 5: $contains');
  print('  Union: $union');
  print('  Intersection: $intersection');
  print('  Difference: $difference');
  print('  ✓ Set operations test passed\n');
}

// ============================================================================
// 9. Control Flow Tests
// ============================================================================

void testControlFlow() {
  print('Test 9: Control Flow');

  // if-else
  int score = 85;
  String grade;
  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else if (score >= 70) {
    grade = 'C';
  } else {
    grade = 'F';
  }

  // Ternary operator
  String result = (score >= 60) ? 'Pass' : 'Fail';

  // for loop
  int forSum = 0;
  for (int i = 1; i <= 5; i++) {
    forSum += i;
  }

  // for-in loop
  List<int> numbers = [1, 2, 3, 4, 5];
  int forInSum = 0;
  for (int num in numbers) {
    forInSum += num;
  }

  // while loop
  int whileSum = 0;
  int i = 1;
  while (i <= 5) {
    whileSum += i;
    i++;
  }

  // do-while loop
  int doWhileSum = 0;
  int j = 1;
  do {
    doWhileSum += j;
    j++;
  } while (j <= 5);

  // break and continue
  int breakSum = 0;
  for (int k = 1; k <= 10; k++) {
    if (k == 6) break;
    if (k % 2 == 0) continue;
    breakSum += k;
  }

  // switch-case
  int day = 3;
  String dayName;
  switch (day) {
    case 1:
      dayName = 'Monday';
      break;
    case 2:
      dayName = 'Tuesday';
      break;
    case 3:
      dayName = 'Wednesday';
      break;
    default:
      dayName = 'Unknown';
  }

  print('  Grade: $grade');
  print('  Result: $result');
  print('  For Sum: $forSum');
  print('  For-in Sum: $forInSum');
  print('  While Sum: $whileSum');
  print('  Do-While Sum: $doWhileSum');
  print('  Break/Continue Sum: $breakSum');
  print('  Day Name: $dayName');
  print('  ✓ Control flow test passed\n');
}

// ============================================================================
// 10. Functions Tests
// ============================================================================

void testFunctions() {
  print('Test 10: Functions');

  // Simple function
  int sum = add(5, 3);

  // Function with return
  int product = multiply(4, 7);

  // Function with optional parameters
  String greeting1 = greet('Alice');
  String greeting2 = greet('Bob', 'Mr.');

  // Function with named parameters
  String user1 = createUser(name: 'Charlie', age: 25);
  String user2 = createUser(name: 'David', age: 30, email: 'david@example.com');

  // Recursive function
  int factorial5 = factorial(5);

  // Function as parameter
  int result = applyOperation(10, 5, add);

  print('  Add: $sum');
  print('  Multiply: $product');
  print('  Greeting 1: $greeting1');
  print('  Greeting 2: $greeting2');
  print('  User 1: $user1');
  print('  User 2: $user2');
  print('  Factorial 5: $factorial5');
  print('  Apply Operation: $result');
  print('  ✓ Functions test passed\n');
}

int add(int a, int b) {
  return a + b;
}

int multiply(int a, int b) {
  return a * b;
}

String greet(String name, [String? title]) {
  if (title != null) {
    return 'Hello, $title $name';
  }
  return 'Hello, $name';
}

String createUser({required String name, required int age, String? email}) {
  if (email != null) {
    return 'User: $name, Age: $age, Email: $email';
  }
  return 'User: $name, Age: $age';
}

int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

int applyOperation(int a, int b, int Function(int, int) operation) {
  return operation(a, b);
}

// ============================================================================
// 11. Classes Tests
// ============================================================================

void testClasses() {
  print('Test 11: Classes');

  // Basic class
  Person person = Person('Alice', 25);
  print('  Person: ${person.name}, ${person.age}');
  person.introduce();

  // Class with methods
  Rectangle rect = Rectangle(10, 20);
  print('  Rectangle: ${rect.width} x ${rect.height}');
  print('  Area: ${rect.area()}');
  print('  Perimeter: ${rect.perimeter()}');

  // Class with getters and setters
  BankAccount account = BankAccount('123456', 1000.0);
  account.deposit(500.0);
  account.withdraw(200.0);
  print('  Balance: ${account.balance}');

  // Class with static members
  print('  Circle count: ${Circle.count}');
  Circle circle1 = Circle(5.0);
  Circle circle2 = Circle(10.0);
  print('  Circle count after creation: ${Circle.count}');

  // Class with named constructor
  Point point1 = Point(3, 4);
  Point point2 = Point.origin();
  print('  Point 1: (${point1.x}, ${point1.y})');
  print('  Point 2: (${point2.x}, ${point2.y})');

  print('  ✓ Classes test passed\n');
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('    I am $name, $age years old');
  }
}

class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  double area() {
    return width * height;
  }

  double perimeter() {
    return 2 * (width + height);
  }
}

class BankAccount {
  String accountNumber;
  double _balance;

  BankAccount(this.accountNumber, this._balance);

  double get balance => _balance;

  void deposit(double amount) {
    _balance += amount;
  }

  void withdraw(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
    }
  }
}

class Circle {
  static int count = 0;
  double radius;

  Circle(this.radius) {
    count++;
  }

  double area() {
    return 3.14159 * radius * radius;
  }
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  Point.origin() : this(0, 0);
}

// ============================================================================
// 12. Inheritance Tests
// ============================================================================

void testInheritance() {
  print('Test 12: Inheritance');

  // Basic inheritance
  Student student = Student('Bob', 20, 'S001');
  student.introduce();
  student.study();

  Teacher teacher = Teacher('Dr. Smith', 45, 'Computer Science');
  teacher.introduce();
  teacher.teach();

  // Polymorphism
  List<Person> people = [
    Person('Alice', 30),
    Student('Charlie', 19, 'S002'),
    Teacher('Prof. Johnson', 50, 'Mathematics')
  ];

  for (Person p in people) {
    p.introduce();
  }

  // Abstract class
  Shape circle = CircleShape(5.0);
  Shape square = SquareShape(4.0);

  print('  Circle area: ${circle.area()}');
  print('  Square area: ${square.area()}');

  print('  ✓ Inheritance test passed\n');
}

class Student extends Person {
  String studentId;

  Student(String name, int age, this.studentId) : super(name, age);

  @override
  void introduce() {
    print('    Student: $name, $age years old, ID: $studentId');
  }

  void study() {
    print('    $name is studying');
  }
}

class Teacher extends Person {
  String subject;

  Teacher(String name, int age, this.subject) : super(name, age);

  @override
  void introduce() {
    print('    Teacher: $name, $age years old, Subject: $subject');
  }

  void teach() {
    print('    $name is teaching $subject');
  }
}

abstract class Shape {
  double area();
}

class CircleShape extends Shape {
  double radius;

  CircleShape(this.radius);

  @override
  double area() {
    return 3.14159 * radius * radius;
  }
}

class SquareShape extends Shape {
  double side;

  SquareShape(this.side);

  @override
  double area() {
    return side * side;
  }
}

// ============================================================================
// 13. Exception Handling Tests
// ============================================================================

void testExceptionHandling() {
  print('Test 13: Exception Handling');

  // Basic try-catch
  try {
    int result = divide(10, 0);
    print('  Result: $result');
  } catch (e) {
    print('  Caught exception: Division by zero');
  }

  // Try-catch with specific exception
  try {
    validateAge(-5);
  } on ArgumentError catch (e) {
    print('  Caught ArgumentError: ${e.message}');
  }

  // Try-catch-finally
  try {
    riskyOperation();
  } catch (e) {
    print('  Caught exception in risky operation');
  } finally {
    print('  Finally block executed');
  }

  // Multiple catch blocks
  try {
    processData(null);
  } on ArgumentError catch (e) {
    print('  Argument error: ${e.message}');
  } catch (e) {
    print('  General error: $e');
  }

  print('  ✓ Exception handling test passed\n');
}

int divide(int a, int b) {
  if (b == 0) {
    throw ArgumentError('Cannot divide by zero');
  }
  return a ~/ b;
}

void validateAge(int age) {
  if (age < 0) {
    throw ArgumentError('Age cannot be negative');
  }
}

void riskyOperation() {
  throw Exception('Risky operation failed');
}

void processData(String? data) {
  if (data == null) {
    throw ArgumentError('Data cannot be null');
  }
}

// ============================================================================
// 14. Type Conversions Tests
// ============================================================================

void testTypeConversions() {
  print('Test 14: Type Conversions');

  // Int to Double
  int intValue = 42;
  double intToDouble = intValue.toDouble();

  // Double to Int
  double doubleValue = 3.14;
  int doubleToInt = doubleValue.toInt();

  // Number to String
  String intToString = intValue.toString();
  String doubleToString = doubleValue.toString();

  // String to Number
  String numStr = '123';
  int strToInt = int.parse(numStr);

  String doubleStr = '3.14';
  double strToDouble = double.parse(doubleStr);

  // Bool to String
  bool boolValue = true;
  String boolToString = boolValue.toString();

  // Type checking
  dynamic value = 42;
  bool isInt = value is int;
  bool isString = value is String;

  print('  Int to Double: $intToDouble');
  print('  Double to Int: $doubleToInt');
  print('  Int to String: $intToString');
  print('  Double to String: $doubleToString');
  print('  String to Int: $strToInt');
  print('  String to Double: $strToDouble');
  print('  Bool to String: $boolToString');
  print('  Is Int: $isInt');
  print('  Is String: $isString');
  print('  ✓ Type conversions test passed\n');
}

// ============================================================================
// 15. Null Safety Tests
// ============================================================================

void testNullSafety() {
  print('Test 15: Null Safety');

  // Nullable types
  int? nullableInt;
  String? nullableString = null;

  // Null coalescing
  int value1 = nullableInt ?? 0;
  String value2 = nullableString ?? 'default';

  // Null-aware access
  String? name = 'Alice';
  int? length = name?.length;

  // Non-null assertion
  String nonNullName = name!;

  // Null check
  if (name != null) {
    print('  Name is not null: $name');
  }

  // Null-aware assignment
  String? text;
  text ??= 'default value';

  print('  Nullable Int: $nullableInt');
  print('  Nullable String: $nullableString');
  print('  Coalesced value 1: $value1');
  print('  Coalesced value 2: $value2');
  print('  Null-aware length: $length');
  print('  Non-null name: $nonNullName');
  print('  Null-aware assigned: $text');
  print('  ✓ Null safety test passed\n');
}
