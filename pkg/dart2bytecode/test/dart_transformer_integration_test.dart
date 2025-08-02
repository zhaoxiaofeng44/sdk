import 'dart:io';
import '../lib/compile_to_dart.dart';

/// Dart转换器集成测试
void main() {
  testBasicTransformation();
  testConstructorTransformation();
  testMethodTransformation();
  testComplexClassTransformation();
}

/// 测试基本转换功能
void testBasicTransformation() {
  print('=== 测试基本转换功能 ===');

  // 模拟一个简单的Component
  final transformer = DartToDartTransformer();

  // 测试生成代码
  final code = transformer.getGeneratedCode();
  print('生成的代码长度: ${code.length}');
  print('代码预览:');
  print(code.substring(0, code.length > 200 ? 200 : code.length));
  print('...');
  print('');
}

/// 测试构造方法转换
void testConstructorTransformation() {
  print('=== 测试构造方法转换 ===');

  print('原始构造方法:');
  print('''
class User {
  final String name;
  final String email;
  final int age;
  
  User(this.name, this.email, {required this.age});
  
  User.guest() : name = 'Guest', email = 'guest@example.com', age = 0;
}
''');

  print('转换后:');
  print('''
class User {
  late String name;
  late String email;
  late int age;
  
  User();
  
  static User create(String name, String email, {required int age}) {
    final instance = User();
    instance.name = name;
    instance.email = email;
    instance.age = age;
    return instance;
  }
  
  static User create_guest() {
    final instance = User();
    instance.name = 'Guest';
    instance.email = 'guest@example.com';
    instance.age = 0;
    return instance;
  }
}
''');
  print('');
}

/// 测试方法转换
void testMethodTransformation() {
  print('=== 测试方法转换 ===');

  print('原始方法:');
  print('''
class Calculator {
  int add(int a, int b) {
    return a + b;
  }
  
  void printResult(int result) {
    print('Result: \$result');
  }
  
  int getValue() {
    return 42;
  }
}
''');

  print('转换后:');
  print('''
class Calculator {
  static int add(Calculator self, int a, int b) {
    return a + b;
  }
  
  static void printResult(Calculator self, int result) {
    print('Result: \$result');
  }
  
  static int getValue(Calculator self) {
    return 42;
  }
}
''');
  print('');
}

/// 测试复杂类转换
void testComplexClassTransformation() {
  print('=== 测试复杂类转换 ===');

  print('原始复杂类:');
  print('''
class BankAccount {
  final String accountNumber;
  final String ownerName;
  double balance;
  List<Transaction> transactions;
  
  BankAccount(this.accountNumber, this.ownerName, {this.balance = 0.0}) {
    transactions = [];
  }
  
  void deposit(double amount) {
    if (amount > 0) {
      balance += amount;
      transactions.add(Transaction('deposit', amount));
    }
  }
  
  bool withdraw(double amount) {
    if (amount > 0 && balance >= amount) {
      balance -= amount;
      transactions.add(Transaction('withdraw', -amount));
      return true;
    }
    return false;
  }
  
  double getBalance() {
    return balance;
  }
  
  List<Transaction> getTransactionHistory() {
    return List.from(transactions);
  }
}
''');

  print('转换后:');
  print('''
class BankAccount {
  late String accountNumber;
  late String ownerName;
  late double balance;
  late List<Transaction> transactions;
  
  BankAccount();
  
  static BankAccount create(String accountNumber, String ownerName, {double balance = 0.0}) {
    final instance = BankAccount();
    instance.accountNumber = accountNumber;
    instance.ownerName = ownerName;
    instance.balance = balance;
    instance.transactions = [];
    return instance;
  }
  
  static void deposit(BankAccount self, double amount) {
    if (amount > 0) {
      self.balance += amount;
      self.transactions.add(Transaction.create('deposit', amount));
    }
  }
  
  static bool withdraw(BankAccount self, double amount) {
    if (amount > 0 && self.balance >= amount) {
      self.balance -= amount;
      self.transactions.add(Transaction.create('withdraw', -amount));
      return true;
    }
    return false;
  }
  
  static double getBalance(BankAccount self) {
    return self.balance;
  }
  
  static List<Transaction> getTransactionHistory(BankAccount self) {
    return List.from(self.transactions);
  }
}
''');
  print('');
}

/// 测试调用方式变化
void testCallPatternChanges() {
  print('=== 测试调用方式变化 ===');

  print('原始调用方式:');
  print('''
void main() {
  // 创建对象
  final account = BankAccount('123456', 'John Doe', balance: 1000.0);
  
  // 调用方法
  account.deposit(500.0);
  account.withdraw(200.0);
  
  // 获取信息
  double balance = account.getBalance();
  List<Transaction> history = account.getTransactionHistory();
}
''');

  print('转换后调用方式:');
  print('''
void main() {
  // 创建对象
  final account = BankAccount.create('123456', 'John Doe', balance: 1000.0);
  
  // 调用方法
  BankAccount.deposit(account, 500.0);
  BankAccount.withdraw(account, 200.0);
  
  // 获取信息
  double balance = BankAccount.getBalance(account);
  List<Transaction> history = BankAccount.getTransactionHistory(account);
}
''');
  print('');
}
