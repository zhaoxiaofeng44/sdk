import 'dart:math';

import 'collection.dart';
import 'error.dart';
import 'string.dart';
import 'Iterable.dart';

void main() {
  testCollectionMethods();
  testIterableMethods();
}

@pragma('wasm:entry-point')
void testCollectionMethods() {
  Random aa = Random();
  aa.nextDouble();
  aa.nextDouble();
  aa.nextDouble();

  // 测试 CppList
  CppList<int> list = CppList<int>.filled(3, 0);
  list[0] = 1;
  list[1] = 2;
  list[2] = 3;

  assert(list.length == 3);
  assert(list[0] == 1);
  assert(list[1] == 2);
  assert(list[2] == 3);
  assert(list.contains(2));
  assert(!list.contains(4));

  list.add(4);
  assert(list.length == 4);
  assert(list[3] == 4);

  list.removeAt(1);
  assert(list.length == 3);
  assert(list[1] == 3);

  print('CppList 方法测试通过！');
}

@pragma('wasm:entry-point')
void testIterableMethods() {
  // 测试 CppIterable
  CppList<int> iterableList = CppList.from([1, 2, 3, 4, 5] as CppIterable);

  assert(iterableList.first == 1);
  assert(iterableList.last == 5);
  assert(iterableList.length == 5);
  assert(iterableList.any((element) => element > 3));
  assert(!iterableList.every((element) => element < 3));

  var mappedList = iterableList.map((e) => e * 2);
  assert(mappedList.toList().toString() == [2, 4, 6, 8, 10].toString());

  var filteredList = iterableList.where((e) => e % 2 == 0);
  assert(filteredList.toList().toString() == [2, 4].toString());

  print('CppIterable 方法测试通过！');

  CppStringBuffer buffer = CppStringBuffer();
  buffer.write('Hello');
  buffer.write('World');
  print(buffer.toString());

  CppError error = CppError();
  error.toString();

  StringBuffer buffer2 = StringBuffer("xx");
  buffer2.write('Hello');
  buffer2.write('World');
  print(buffer2.toString());

  var list = List.generate(10, (index) => index, growable: true);
  list.add(11);
  print(list.toString());

  int g1 = 1;
  int g2;
  g2 = 5;
  var ff = () {
    g1 += 1;
    g2 += 1;
    print(g1.toString() + " " + g2.toString());
  };

  ff();

  // 复杂for循环暂时注释掉，因为需要额外处理

  var list2 = [];
  for (var i = 0; i < 10; i++) {
    list2.add(() {
      print(i);
    });
  }

  list2.forEach((f) => f());

  {
    var list3 = [];
    var i = 0;
    for (i = 0; i < 10; i++) {
      list3.add(() {
        print(i);
      });
    }

    list3.forEach((f) => f());
  }

  // 测试for循环装箱
  {
    var list4 = [];
    for (int i = 0; i < 3; i++) {
      list4.add(() {
        print(i);
      });
    }
    list4.forEach((f) => f());
  }
}
