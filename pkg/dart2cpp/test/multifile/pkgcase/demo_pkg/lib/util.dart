// 多 package 测试 — demo_pkg 的工具库：同时依赖 demo_core 与 animal.dart
import 'package:demo_core/base.dart';
import 'animal.dart';

String formatPet(Pet p) => 'Pet: ${p.describe()}';

int pkgHelper(int x) => coreHelper(x) * 2;
