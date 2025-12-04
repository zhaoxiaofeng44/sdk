/// Edge Cases and Corner Cases Test
///
/// Tests edge cases, boundary conditions, and corner cases
/// to ensure robust C++ code generation.

void main() {
  print('=== Edge Cases and Corner Cases Test ===\n');

  testNumericEdgeCases();
  testStringEdgeCases();
  testCollectionEdgeCases();
  testNullEdgeCases();
  testDivisionEdgeCases();
  testOverflowCases();
  testEmptyCollections();
  testNestedStructures();
  testRecursionEdgeCases();
  testBoundaryConditions();

  print('\n=== All Edge Cases Tests Completed ===');
}

// ============================================================================
// 1. Numeric Edge Cases
// ============================================================================

void testNumericEdgeCases() {
  print('Test 1: Numeric Edge Cases');

  // Integer boundaries
  int maxInt = 2147483647;
  int minInt = -2147483648;
  int zero = 0;
  int one = 1;
  int minusOne = -1;

  print('  Max Int: $maxInt');
  print('  Min Int: $minInt');
  print('  Zero: $zero');
  print('  One: $one');
  print('  Minus One: $minusOne');

  // Double edge cases
  double positiveZero = 0.0;
  double negativeZero = -0.0;
  double verySmall = 0.0000001;
  double veryLarge = 1000000000.0;

  print('  Positive Zero: $positiveZero');
  print('  Negative Zero: $negativeZero');
  print('  Very Small: $verySmall');
  print('  Very Large: $veryLarge');

  // Operations with zero
  int addZero = 5 + 0;
  int multiplyZero = 5 * 0;
  int subtractZero = 5 - 0;

  print('  5 + 0 = $addZero');
  print('  5 * 0 = $multiplyZero');
  print('  5 - 0 = $subtractZero');

  // Negative number operations
  int negativeSum = -5 + (-3);
  int negativeProduct = -5 * -3;
  int negativeDifference = -5 - (-3);

  print('  -5 + (-3) = $negativeSum');
  print('  -5 * -3 = $negativeProduct');
  print('  -5 - (-3) = $negativeDifference');

  print('  ✓ Numeric edge cases test passed\n');
}

// ============================================================================
// 2. String Edge Cases
// ============================================================================

void testStringEdgeCases() {
  print('Test 2: String Edge Cases');

  // Empty string
  String empty = '';
  print('  Empty string length: ${empty.length}');
  print('  Empty string isEmpty: ${empty.isEmpty}');

  // Single character
  String single = 'a';
  print('  Single char: "$single", length: ${single.length}');

  // String with spaces
  String spaces = '   ';
  print('  Spaces length: ${spaces.length}');
  print('  Spaces trimmed: "${spaces.trim()}"');

  // String with special characters
  String special = 'Hello\nWorld\t!';
  print('  Special chars: "$special"');

  // Very long string
  String longString = 'a' * 100;
  print('  Long string length: ${longString.length}');

  // String concatenation edge cases
  String concat1 = '' + 'hello';
  String concat2 = 'hello' + '';
  String concat3 = '' + '';

  print('  Empty + hello: "$concat1"');
  print('  hello + empty: "$concat2"');
  print('  Empty + empty: "$concat3"');

  // Substring edge cases
  String str = 'Hello';
  String sub1 = str.substring(0, 0);
  String sub2 = str.substring(0, str.length);
  String sub3 = str.substring(str.length, str.length);

  print('  Substring (0,0): "$sub1"');
  print('  Substring (0,len): "$sub2"');
  print('  Substring (len,len): "$sub3"');

  // IndexOf edge cases
  int idx1 = str.indexOf('H');
  int idx2 = str.indexOf('o');
  int idx3 = str.indexOf('z');

  print('  IndexOf H: $idx1');
  print('  IndexOf o: $idx2');
  print('  IndexOf z: $idx3');

  print('  ✓ String edge cases test passed\n');
}

// ============================================================================
// 3. Collection Edge Cases
// ============================================================================

void testCollectionEdgeCases() {
  print('Test 3: Collection Edge Cases');

  // Empty list
  List<int> emptyList = [];
  print('  Empty list length: ${emptyList.length}');
  print('  Empty list isEmpty: ${emptyList.isEmpty}');

  // Single element list
  List<int> singleList = [42];
  print('  Single element list: $singleList');
  print('  First: ${singleList.first}, Last: ${singleList.last}');

  // List with duplicates
  List<int> duplicates = [1, 1, 2, 2, 3, 3];
  print('  List with duplicates: $duplicates');

  // List operations on empty list
  List<int> testList = [];
  testList.add(1);
  print('  After adding to empty: $testList');

  // Empty map
  Map<String, int> emptyMap = {};
  print('  Empty map length: ${emptyMap.length}');
  print('  Empty map isEmpty: ${emptyMap.isEmpty}');

  // Map with single entry
  Map<String, int> singleMap = {'key': 42};
  print('  Single entry map: $singleMap');

  // Empty set
  Set<int> emptySet = {};
  print('  Empty set length: ${emptySet.length}');
  print('  Empty set isEmpty: ${emptySet.isEmpty}');

  // Set with single element
  Set<int> singleSet = {42};
  print('  Single element set: $singleSet');

  // Set with duplicates (should remove)
  Set<int> setDuplicates = {1, 1, 2, 2, 3, 3};
  print('  Set with duplicates: $setDuplicates');

  print('  ✓ Collection edge cases test passed\n');
}

// ============================================================================
// 4. Null Edge Cases
// ============================================================================

void testNullEdgeCases() {
  print('Test 4: Null Edge Cases');

  // Null variables
  int? nullInt;
  String? nullString;
  List<int>? nullList;

  print('  Null int: $nullInt');
  print('  Null string: $nullString');
  print('  Null list: $nullList');

  // Null coalescing with null
  int value1 = nullInt ?? 0;
  String value2 = nullString ?? 'default';

  print('  Coalesced int: $value1');
  print('  Coalesced string: $value2');

  // Null coalescing with non-null
  int? nonNullInt = 42;
  int value3 = nonNullInt ?? 0;
  print('  Coalesced non-null: $value3');

  // Null-aware access
  String? name = 'Alice';
  int? length1 = name?.length;
  print('  Length of non-null: $length1');

  name = null;
  int? length2 = name?.length;
  print('  Length of null: $length2');

  // Null-aware assignment
  String? text;
  text ??= 'default';
  print('  After null-aware assignment: $text');

  text ??= 'another';
  print('  After second assignment: $text');

  print('  ✓ Null edge cases test passed\n');
}

// ============================================================================
// 5. Division Edge Cases
// ============================================================================

void testDivisionEdgeCases() {
  print('Test 5: Division Edge Cases');

  // Division by positive numbers
  double div1 = 10 / 2;
  double div2 = 10 / 3;
  double div3 = 1 / 2;

  print('  10 / 2 = $div1');
  print('  10 / 3 = $div2');
  print('  1 / 2 = $div3');

  // Integer division
  int intDiv1 = 10 ~/ 2;
  int intDiv2 = 10 ~/ 3;
  int intDiv3 = 1 ~/ 2;

  print('  10 ~/ 2 = $intDiv1');
  print('  10 ~/ 3 = $intDiv2');
  print('  1 ~/ 2 = $intDiv3');

  // Modulo operations
  int mod1 = 10 % 3;
  int mod2 = 10 % 2;
  int mod3 = 5 % 10;

  print('  10 % 3 = $mod1');
  print('  10 % 2 = $mod2');
  print('  5 % 10 = $mod3');

  // Division with negative numbers
  double negDiv1 = -10 / 2;
  double negDiv2 = 10 / -2;
  double negDiv3 = -10 / -2;

  print('  -10 / 2 = $negDiv1');
  print('  10 / -2 = $negDiv2');
  print('  -10 / -2 = $negDiv3');

  // Modulo with negative numbers
  int negMod1 = -10 % 3;
  int negMod2 = 10 % -3;

  print('  -10 % 3 = $negMod1');
  print('  10 % -3 = $negMod2');

  print('  ✓ Division edge cases test passed\n');
}

// ============================================================================
// 6. Overflow Cases
// ============================================================================

void testOverflowCases() {
  print('Test 6: Overflow Cases');

  // Large number operations
  int large1 = 1000000;
  int large2 = 1000000;
  int largeProduct = large1 * large2;

  print('  1000000 * 1000000 = $largeProduct');

  // Large additions
  int largeSum = 2000000000 + 100000000;
  print('  2000000000 + 100000000 = $largeSum');

  // Double precision
  double precise1 = 0.1 + 0.2;
  print('  0.1 + 0.2 = $precise1');

  double precise2 = 1.0 / 3.0;
  print('  1.0 / 3.0 = $precise2');

  // Very small numbers
  double small1 = 0.0000001;
  double small2 = 0.0000002;
  double smallSum = small1 + small2;

  print('  0.0000001 + 0.0000002 = $smallSum');

  print('  ✓ Overflow cases test passed\n');
}

// ============================================================================
// 7. Empty Collections
// ============================================================================

void testEmptyCollections() {
  print('Test 7: Empty Collections');

  // Empty list operations
  List<int> emptyList = [];
  bool listIsEmpty = emptyList.isEmpty;
  bool listIsNotEmpty = emptyList.isNotEmpty;
  int listLength = emptyList.length;

  print('  Empty list isEmpty: $listIsEmpty');
  print('  Empty list isNotEmpty: $listIsNotEmpty');
  print('  Empty list length: $listLength');

  // Empty map operations
  Map<String, int> emptyMap = {};
  bool mapIsEmpty = emptyMap.isEmpty;
  bool mapIsNotEmpty = emptyMap.isNotEmpty;
  int mapLength = emptyMap.length;

  print('  Empty map isEmpty: $mapIsEmpty');
  print('  Empty map isNotEmpty: $mapIsNotEmpty');
  print('  Empty map length: $mapLength');

  // Empty set operations
  Set<int> emptySet = {};
  bool setIsEmpty = emptySet.isEmpty;
  bool setIsNotEmpty = emptySet.isNotEmpty;
  int setLength = emptySet.length;

  print('  Empty set isEmpty: $setIsEmpty');
  print('  Empty set isNotEmpty: $setIsNotEmpty');
  print('  Empty set length: $setLength');

  // Operations on empty collections
  emptyList.add(1);
  print('  After adding to empty list: $emptyList');

  emptyMap['key'] = 1;
  print('  After adding to empty map: $emptyMap');

  emptySet.add(1);
  print('  After adding to empty set: $emptySet');

  print('  ✓ Empty collections test passed\n');
}

// ============================================================================
// 8. Nested Structures
// ============================================================================

void testNestedStructures() {
  print('Test 8: Nested Structures');

  // Nested lists
  List<List<int>> nestedList = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ];

  print('  Nested list: $nestedList');
  print('  Element [1][2]: ${nestedList[1][2]}');

  // Nested maps
  Map<String, Map<String, int>> nestedMap = {
    'group1': {'a': 1, 'b': 2},
    'group2': {'c': 3, 'd': 4}
  };

  print('  Nested map: $nestedMap');
  print('  Element [group1][a]: ${nestedMap['group1']!['a']}');

  // List of maps
  List<Map<String, int>> listOfMaps = [
    {'x': 1, 'y': 2},
    {'x': 3, 'y': 4}
  ];

  print('  List of maps: $listOfMaps');
  print('  Element [0][x]: ${listOfMaps[0]['x']}');

  // Map of lists
  Map<String, List<int>> mapOfLists = {
    'evens': [2, 4, 6],
    'odds': [1, 3, 5]
  };

  print('  Map of lists: $mapOfLists');
  print('  Element [evens][1]: ${mapOfLists['evens']![1]}');

  print('  ✓ Nested structures test passed\n');
}

// ============================================================================
// 9. Recursion Edge Cases
// ============================================================================

void testRecursionEdgeCases() {
  print('Test 9: Recursion Edge Cases');

  // Factorial edge cases
  int fact0 = factorial(0);
  int fact1 = factorial(1);
  int fact5 = factorial(5);

  print('  Factorial(0): $fact0');
  print('  Factorial(1): $fact1');
  print('  Factorial(5): $fact5');

  // Fibonacci edge cases
  int fib0 = fibonacci(0);
  int fib1 = fibonacci(1);
  int fib10 = fibonacci(10);

  print('  Fibonacci(0): $fib0');
  print('  Fibonacci(1): $fib1');
  print('  Fibonacci(10): $fib10');

  // Sum of digits
  int sum1 = sumOfDigits(0);
  int sum2 = sumOfDigits(5);
  int sum3 = sumOfDigits(123);

  print('  Sum of digits(0): $sum1');
  print('  Sum of digits(5): $sum2');
  print('  Sum of digits(123): $sum3');

  print('  ✓ Recursion edge cases test passed\n');
}

int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

int fibonacci(int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

int sumOfDigits(int n) {
  if (n == 0) return 0;
  return (n % 10) + sumOfDigits(n ~/ 10);
}

// ============================================================================
// 10. Boundary Conditions
// ============================================================================

void testBoundaryConditions() {
  print('Test 10: Boundary Conditions');

  // List boundary access
  List<int> numbers = [1, 2, 3, 4, 5];
  int firstElement = numbers[0];
  int lastElement = numbers[numbers.length - 1];

  print('  First element: $firstElement');
  print('  Last element: $lastElement');

  // String boundary access
  String text = 'Hello';
  String firstChar = text[0];
  String lastChar = text[text.length - 1];

  print('  First char: $firstChar');
  print('  Last char: $lastChar');

  // Loop boundary conditions
  int sum = 0;
  for (int i = 0; i < numbers.length; i++) {
    sum += numbers[i];
  }
  print('  Sum using boundary: $sum');

  // Range checks
  bool inRange1 = 5 >= 0 && 5 < numbers.length;
  bool inRange2 = -1 >= 0 && -1 < numbers.length;
  bool inRange3 = 10 >= 0 && 10 < numbers.length;

  print('  Index 5 in range: $inRange1');
  print('  Index -1 in range: $inRange2');
  print('  Index 10 in range: $inRange3');

  // Comparison boundaries
  int value = 50;
  bool lessThan = value < 100;
  bool lessOrEqual = value <= 50;
  bool greaterThan = value > 0;
  bool greaterOrEqual = value >= 50;

  print('  50 < 100: $lessThan');
  print('  50 <= 50: $lessOrEqual');
  print('  50 > 0: $greaterThan');
  print('  50 >= 50: $greaterOrEqual');

  print('  ✓ Boundary conditions test passed\n');
}
