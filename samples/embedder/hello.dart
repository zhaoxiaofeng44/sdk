// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

//@pragma('vm:entry-point', 'call')
// void main(List<String> args) {
//   var ttt = ["1", "2", "3", "4792hsdfssafkka"];
//   ttt.add("xmyyhssdgsgsg");
//   double ee = 7.4323;
//   int g = ee.ceil() % 4;

//   greet("aaaaa" + ttt[g]);
// }

// void greet(String person) {
//   double ee = 7.4323;
//   double ttt = ee + 6.2;
//   print("hi, ${ttt.ceil()}!");
// }

void main() {
  // var ttt = ["1", "2", "3", "4792hsdfssafkka"];
  // ttt.add("xmyyhssdgsgsg");
  double ee = 7.4323;
  int g = ee.ceil() % 4;

  greet(g);
}

void greet(int person) {
  double ee = 7.4323;
  double ttt = ee + 6.2 + person;
  print(person);
}
