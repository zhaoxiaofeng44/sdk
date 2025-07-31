# 访问器修复总结

## 问题描述

在 `lib/compile_to_cpp.dart` 文件中，代码使用了不支持的语法来设置 `RecursiveVisitor` 的 `defaultNode` 方法：

```dart
node.visitChildren(RecursiveVisitor()
  ..defaultNode = (Node child) {
    // 处理逻辑
    return null;
  });
```

这种写法在 Dart 中不被支持，因为不能直接给方法赋值。

## 修复方案

将原来的匿名访问器改为具体的类实现：

### 1. 创建 `_LocalVariableCollector` 类

用于收集函数体中声明的局部变量：

```dart
/// 局部变量收集器
class _LocalVariableCollector extends RecursiveVisitor {
  final Set<VariableDeclaration> localVariables;
  
  _LocalVariableCollector(this.localVariables);
  
  @override
  Node? defaultNode(Node node) {
    if (node is TreeNode) {
      _collectLocalVariablesStatic(node, localVariables);
    }
    return null;
  }
  
  static void _collectLocalVariablesStatic(TreeNode? node, Set<VariableDeclaration> localVariables) {
    if (node == null) return;
    
    if (node is VariableDeclaration) {
      localVariables.add(node);
    } else if (node is FunctionDeclaration) {
      localVariables.add(node.variable);
    } else if (node is Let) {
      localVariables.add(node.variable);
    }
  }
}
```

### 2. 创建 `_VariableReferenceAnalyzer` 类

用于分析变量引用，识别闭包中捕获的外部变量：

```dart
/// 变量引用分析器
class _VariableReferenceAnalyzer extends RecursiveVisitor {
  final Set<VariableDeclaration> parameterVariables;
  final Set<VariableDeclaration> localVariables;
  final List<ClosureVariable> capturedVariables;
  
  _VariableReferenceAnalyzer(this.parameterVariables, this.localVariables, this.capturedVariables);
  
  @override
  Node? defaultNode(Node node) {
    if (node is TreeNode) {
      _analyzeVariableReferencesStatic(node, parameterVariables, localVariables, capturedVariables);
    }
    return null;
  }
  
  static void _analyzeVariableReferencesStatic(
      TreeNode? node,
      Set<VariableDeclaration> parameterVariables,
      Set<VariableDeclaration> localVariables,
      List<ClosureVariable> capturedVariables) {
    // 分析逻辑...
  }
}
```

## 修复位置

1. **第312-317行**：修复了 `_collectLocalVariables` 方法中的访问器使用
2. **第369-373行**：修复了 `_analyzeVariableReferences` 方法中的访问器使用

## 修复效果

- 消除了编译错误
- 保持了原有的功能逻辑
- 代码更加清晰和可维护
- 符合 Dart 语言规范

## 相关方法

修复涉及的主要方法：

1. `_findCapturedVariables` - 查找函数中引用的外部变量
2. `_collectLocalVariables` - 收集函数体中声明的局部变量  
3. `_analyzeVariableReferences` - 分析变量引用

这些方法用于支持闭包变量的分析，为 C++ 代码生成提供必要的信息。 