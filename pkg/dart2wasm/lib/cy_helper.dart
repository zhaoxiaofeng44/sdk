class TreeNode<T> {
  final T value;
  final List<TreeNode<T>> children;
  TreeNode<T>? parent;

  TreeNode(this.value, {this.parent, List<TreeNode<T>>? children})
      : children = children ?? [];

  TreeNode<T> addChild(TreeNode<T> child) {
    children.add(child);
    child.parent = this;
    return this;
  }
}

class TreeTraversal {
  // 根据父节点关系构建树
  static TreeNode<T> buildTree<T>({
    required List<Map<String, dynamic>> data,
  }) {
    // 创建节点映射
    final Map<T, TreeNode<T>> nodeMap = {};

    // 首先创建所有节点
    for (final item in data) {
      final T value = item['value'] as T;
      nodeMap[value] = TreeNode<T>(value);
    }

    // 建立父子关系
    for (final item in data) {
      final T value = item['value'] as T;
      final dynamic parentValueRaw = item['parent'];
      final T? parentValue =
          parentValueRaw != null ? parentValueRaw as T : null;

      if (parentValue != null) {
        // 确保父节点存在
        final parentNode = nodeMap[parentValue];
        if (parentNode == null) {
          throw ArgumentError('Parent node $parentValue not found');
        }

        parentNode.addChild(nodeMap[value]!);
      }
    }

    // 找到根节点（没有父节点的节点）
    final rootCandidates =
        nodeMap.values.where((node) => node.parent == null).toList();

    if (rootCandidates.isEmpty) {
      throw ArgumentError('No root node found');
    }

    if (rootCandidates.length > 1) {
      throw ArgumentError('Multiple root nodes found');
    }

    return rootCandidates.first;
  }

  // 中序遍历
  static List<T> inorderTraversal<T>(TreeNode<T>? node) {
    final result = <T>[];

    void traverse(TreeNode<T>? current) {
      if (current == null) return;

      // 访问当前节点
      result.add(current.value);
      // 先遍历左子树
      if (current.children.isNotEmpty) {
        for (var node in current.children) {
          // 访问当前节点的子节点
          traverse(node);
        }
      }
    }

    traverse(node);
    return result;
  }
}

class Person {
  final String name;
  final int id;

  const Person(this.name, this.id);

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is Person && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

void main(List<String> args) {
  // 自定义对象类型
  // 测试：对象类型树
  Record aa;
  final personTreeData = <Map<String, dynamic>>[
    {'value': Person('Charlie', 3), 'parent': Person('Bob', 5)},
    {'value': Person('David', 7), 'parent': Person('Bob', 5)},
    {'value': Person('Bob', 5), 'parent': null},
    {'value': Person('Alice', 1), 'parent': Person('Charlie', 3)},
    {'value': Person('Eve', 4), 'parent': Person('Charlie', 3)},
  ];

  final personRoot = TreeTraversal.buildTree<Person>(data: personTreeData);

  final personInorderResult = TreeTraversal.inorderTraversal(personRoot);
  print('对象类型中序遍历结果：$personInorderResult');

  // 测试：整数类型
  final intTreeData = <Map<String, dynamic>>[
    {'value': 3, 'parent': 5},
    {'value': 7, 'parent': 5},
    {'value': 5, 'parent': null},
    {'value': 1, 'parent': 3},
    {'value': 4, 'parent': 3},
    {'value': 6, 'parent': 7},
    {'value': 8, 'parent': 7},
  ];

  final intRoot = TreeTraversal.buildTree<int>(data: intTreeData);

  final intInorderResult = TreeTraversal.inorderTraversal(intRoot);
  print('整数类型中序遍历结果：$intInorderResult');

  int a = 3;
  double b = 5.4;
  num c = a;
  num d = b;
  num k = d + c;
  print(k);
}
