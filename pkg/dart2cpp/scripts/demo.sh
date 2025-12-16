#!/bin/bash

# Dart2Cpp 快速演示脚本
# 展示如何使用自动化脚本快速转换和运行Dart代码

echo "🚀 Dart2Cpp 快速演示"
echo "==================="
echo ""

# 创建演示Dart文件
cat > /tmp/demo.dart << 'EOF'
void main() {
  print('🌟 Dart2Cpp 演示程序');
  print('====================');
  
  // 基本类型演示
  int age = 25;
  double height = 1.75;
  String name = '张三';
  bool isStudent = true;
  
  print('👤 基本信息:');
  print('  姓名: $name');
  print('  年龄: $age 岁');
  print('  身高: $height 米');
  print('  学生: $isStudent');
  
  // 列表演示
  List<String> hobbies = ['读书', '游泳', '编程'];
  print('');  
  print('📚 兴趣爱好:');
  for (int i = 0; i < hobbies.length; i++) {
    print('  ${i + 1}. ${hobbies[i]}');
  }
  
  // 条件演示
  print('');
  if (age >= 18) {
    print('✅ 已成年');
  } else {
    print('👶 未成年');
  }
  
  // 函数演示
  print('');
  print('🧮 计算结果:');
  int sum = addNumbers(10, 20);
  print('  10 + 20 = $sum');
  
  print('');
  print('🎉 演示完成!');
}

int addNumbers(int a, int b) {
  return a + b;
}
EOF

echo "📝 创建演示Dart程序: /tmp/demo.dart"
echo ""

# 使用基础脚本运行
echo "▶️ 使用基础脚本运行..."
echo ""

cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp
./scripts/dart_to_cpp_run.sh /tmp/demo.dart

echo ""
echo "✅ 演示完成!"
echo ""
echo "💡 提示: 您也可以使用高级脚本保存生成的文件:"
echo "   ./scripts/dart_to_cpp_run_advanced.sh /tmp/demo.dart -s -e -o ./output -n demo"