// 继承关系修复验证测试
// 验证每个类只包含自己定义的方法，不包含从父类继承的方法

import 'dart:io';

void main() {
  print("=== 继承关系修复验证测试 ===");

  // 读取生成的头文件
  var headerFile = File('./output.h');
  if (!headerFile.existsSync()) {
    print("错误：output.h 文件不存在");
    return;
  }

  var content = headerFile.readAsStringSync();

  // 验证 CyBase 类只包含自己的方法
  print("\n--- 验证 CyBase 类 ---");
  var cyBaseMatch =
      RegExp(r'class CyBase : virtual public Object \{[^}]*\}', dotAll: true)
          .firstMatch(content);
  if (cyBaseMatch != null) {
    var cyBaseContent = cyBaseMatch.group(0)!;
    print("✓ CyBase 类定义找到");

    // 检查是否只包含自己的方法
    if (cyBaseContent.contains('CyBase_test') &&
        !cyBaseContent.contains('CyFather_') &&
        !cyBaseContent.contains('CyChild_')) {
      print("✓ CyBase 只包含自己的方法 (CyBase_test)");
    } else {
      print("✗ CyBase 包含了其他类的方法");
    }
  }

  // 验证 CyFather 类只包含自己的方法
  print("\n--- 验证 CyFather 类 ---");
  var cyFatherMatch =
      RegExp(r'class CyFather : virtual public CyBase \{[^}]*\}', dotAll: true)
          .firstMatch(content);
  if (cyFatherMatch != null) {
    var cyFatherContent = cyFatherMatch.group(0)!;
    print("✓ CyFather 类定义找到");

    // 检查是否只包含自己的方法（忽略Object_toString，因为所有类都需要实现）
    if (cyFatherContent.contains('CyFather_myTest') &&
        !cyFatherContent.contains('CyBase_test') &&
        !cyFatherContent.contains('CyChild_')) {
      print("✓ CyFather 只包含自己的方法 (CyFather_myTest)");
    } else {
      print("✗ CyFather 包含了其他类的方法");
      print("内容: ${cyFatherContent.substring(0, 200)}...");
    }
  }

  // 验证 CyChild 类只包含自己的方法
  print("\n--- 验证 CyChild 类 ---");
  var cyChildMatch =
      RegExp(r'class CyChild : virtual public CyFather \{[^}]*\}', dotAll: true)
          .firstMatch(content);
  if (cyChildMatch != null) {
    var cyChildContent = cyChildMatch.group(0)!;
    print("✓ CyChild 类定义找到");

    // 检查是否只包含自己的方法（忽略Object_toString，因为所有类都需要实现）
    if (cyChildContent.contains('CyChild_myTest') &&
        !cyChildContent.contains('CyBase_test') &&
        !cyChildContent.contains('CyFather_myTest')) {
      print("✓ CyChild 只包含自己的方法 (CyChild_myTest)");
    } else {
      print("✗ CyChild 包含了其他类的方法");
      print("内容: ${cyChildContent.substring(0, 200)}...");
    }
  }

  // 验证继承关系
  print("\n--- 验证继承关系 ---");
  if (content.contains('class CyBase : virtual public Object')) {
    print("✓ CyBase 继承自 Object");
  } else {
    print("✗ CyBase 继承关系错误");
  }

  if (content.contains('class CyFather : virtual public CyBase')) {
    print("✓ CyFather 继承自 CyBase");
  } else {
    print("✗ CyFather 继承关系错误");
  }

  if (content.contains('class CyChild : virtual public CyFather')) {
    print("✓ CyChild 继承自 CyFather");
  } else {
    print("✗ CyChild 继承关系错误");
  }

  print("\n=== 测试完成 ===");
}
