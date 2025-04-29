import 'dart:math';

import 'package:kernel/kernel.dart';
import 'package:kernel/src/printer.dart';
import 'package:kernel/src/text_util.dart';
import 'package:kernel/ast.dart';

import 'class_info.dart';
import 'translator.dart';

void printTranslator(Translator translator) {
  for (final classInfo in translator.classInfo.values) {
    if ('MyTest' != classInfo.cls?.name &&
        'ComplexTest' != classInfo.cls?.name) {
      continue;
    }
    // print('Class: ${classInfo.cls?.name}');
    // print('  - superInfo: ${classInfo.superInfo?.cls?.name}');

    // var printer = CppCodePrinter();
    // classInfo.cls?.toTextInternal(printer);
    // print(printer.getText());
    // classInfo.cls.toStringInternal();
    printClass(classInfo);
  }

  //printSort(translator);
}

void printClass(ClassInfo classInfo) {
  if (classInfo.cls == null) {
    return;
  }

  // First print headers and base classes
  if (classInfo.cls!.name == "MyTest") {
    print('''
#include <string>
#include <iostream>
#include <memory>
#include <vector>
#include <map>
#include <set>
#include "containers.hpp"

class Object {
public:
  virtual ~Object() = default;
  virtual std::string toString() const {
    return "Object";
  }
};
''');
    printStringClass();
    printContainerClasses();
    print("");
  }

  // Then print class declaration
  printClassDeclaration(classInfo);
  print("");
  // Then print function implementations
}

void printStringClass() {
  print('''
class String : public Object {
public:
  std::string value;
  int length;

  static String* _new_0() {
    String* obj = new String();
    obj->value = "";
    obj->length = 0;
    return obj;
  }

  static String* fromStdString(const std::string& str) {
    String* obj = new String();
    obj->value = str;
    obj->length = str.length();
    return obj;
  }

  static String* fromInt(int value) {
    return fromStdString(std::to_string(value));
  }

  String* operator+(const String* other) const {
    if (other == nullptr) return nullptr;
    return fromStdString(this->value + other->value);
  }

  String* operator+(int value) const {
    return fromStdString(this->value + std::to_string(value));
  }

  bool operator==(const String* other) const {
    if (other == nullptr) return false;
    return this->value == other->value;
  }

  bool operator!=(const String* other) const {
    return !(*this == other);
  }

  virtual std::string toString() const override {
    return value;
  }

  int get_length() const {
    return length;
  }
};
''');
}

void printContainerClasses() {
  print('''
template<typename T>
class List : public Object {
public:
  std::vector<T> items;

  static List<T>* _new_0() {
    List<T>* obj = new List<T>();
    return obj;
  }

  void add(T item) {
    items.push_back(item);
  }

  T get(int index) {
    return items[index];
  }

  void set(int index, T value) {
    items[index] = value;
  }

  int get length() {
    return items.size();
  }

  virtual std::string toString() const override {
    std::string result = "[";
    for (size_t i = 0; i < items.size(); ++i) {
      if (i > 0) result += ", ";
      if constexpr (std::is_pointer<T>::value) {
        result += items[i] ? items[i]->toString() : "null";
      } else {
        result += std::to_string(items[i]);
      }
    }
    result += "]";
    return result;
  }
};

template<typename K, typename V>
class Map : public Object {
public:
  std::map<K, V> items;

  static Map<K, V>* _new_0() {
    Map<K, V>* obj = new Map<K, V>();
    return obj;
  }

  void put(K key, V value) {
    items[key] = value;
  }

  V get(K key) {
    return items[key];
  }

  bool containsKey(K key) {
    return items.find(key) != items.end();
  }

  int get length() {
    return items.size();
  }

  virtual std::string toString() const override {
    std::string result = "{";
    bool first = true;
    for (const auto& pair : items) {
      if (!first) result += ", ";
      if constexpr (std::is_pointer<K>::value) {
        result += pair.first ? pair.first->toString() : "null";
      } else {
        result += std::to_string(pair.first);
      }
      result += ": ";
      if constexpr (std::is_pointer<V>::value) {
        result += pair.second ? pair.second->toString() : "null";
      } else {
        result += std::to_string(pair.second);
      }
      first = false;
    }
    result += "}";
    return result;
  }
};

template<typename T>
class Set : public Object {
public:
  std::set<T> items;

  static Set<T>* _new_0() {
    Set<T>* obj = new Set<T>();
    return obj;
  }

  void add(T item) {
    items.insert(item);
  }

  bool contains(T item) {
    return items.find(item) != items.end();
  }

  int get length() {
    return items.size();
  }

  virtual std::string toString() const override {
    std::string result = "{";
    bool first = true;
    for (const auto& item : items) {
      if (!first) result += ", ";
      if constexpr (std::is_pointer<T>::value) {
        result += item ? item->toString() : "null";
      } else {
        result += std::to_string(item);
      }
      first = false;
    }
    result += "}";
    return result;
  }
};
''');
}

void printClassDeclaration(ClassInfo classInfo) {
  var printer = CppCodePrinter();

  // Print class header with template parameters if any
  var typeParameters =
      classInfo.cls?.typeParameters.map((e) => "typename ${e.name}");
  if (typeParameters?.isNotEmpty ?? false) {
    print("template<${typeParameters!.join(",")}>");
  }

  // Print class declaration with inheritance
  var className = classInfo.cls!.name.replaceAll("&", r"$");
  var superClassName = classInfo.superInfo == null
      ? "Object"
      : classInfo.superInfo!.cls?.name.replaceAll("&", r"$") ?? "Object";
  print("class $className : public $superClassName {");
  print("public:");

  // Print fields
  for (var field in classInfo.cls!.fields) {
    var fieldString = getFieldDeclaration(field);
    print("  ${field.isStatic ? "static " : ""}$fieldString;");
  }

  // Print constructors
  for (var constructor in classInfo.cls!.constructors) {
    var parameters = [
      ...constructor.function.positionalParameters
          .map((parameter) => getVariableDeclaration(parameter)),
      ...constructor.function.namedParameters
          .map((parameter) => getVariableDeclaration(parameter))
    ];

    print(
        "  static $className* ${printer.getFunctionName(constructor.name.text)}(${parameters.join(", ")});");
  }

  // Print methods
  for (var procedure in classInfo.cls!.procedures) {
    var methodName = printer.getMethodName(procedure);

    var parameters = [
      ...procedure.function.positionalParameters
          .map((parameter) => getVariableDeclaration(parameter)),
      ...procedure.function.namedParameters
          .map((parameter) => getVariableDeclaration(parameter))
    ];

    var staticPrefix = procedure.isStatic ? "static " : "";
    var virtualPrefix = !procedure.isStatic ? "virtual " : "";

    if (procedure.function.returnType is FunctionType) {
      var functionString = getVariableType(procedure.function.returnType,
          name: "$methodName(${parameters.join(", ")})");
      print("  $staticPrefix$virtualPrefix$functionString;");
    } else {
      var returnType = getVariableType(procedure.function.returnType);
      print(
          "  $staticPrefix$virtualPrefix$returnType $methodName(${parameters.join(", ")});");
    }
    if (procedure.function.body != null) {
      print(toString(procedure.function.body!));
    }
  }

  print("};");
}

String getFieldDeclaration(Field field) {
  if (field.type is FunctionType) {
    return getVariableType(field.type, name: field.name.text);
  } else {
    return "${getVariableType(field.type)} ${field.name.text}";
  }
}

String getVariableDeclaration(VariableDeclaration variableDeclaration) {
  if (variableDeclaration.type is FunctionType) {
    return getVariableType(variableDeclaration.type,
        name: variableDeclaration.name);
  } else {
    return "${getVariableType(variableDeclaration.type)} ${variableDeclaration.name}";
  }
}

String getVariableType(DartType type, {String? name}) {
  if (type is InterfaceType) {
    var typeParameters = type.typeArguments.map((e) => getVariableType(e));
    return type.classNode.name +
        (typeParameters.isNotEmpty ? "<${typeParameters.join(",")}>" : "");
  } else if (type is FunctionType) {
    var parameters = [
      ...type.positionalParameters
          .map((parameter) => getVariableType(parameter)),
      ...type.namedParameters
          .map((parameter) => getVariableType(parameter.type))
    ];
    return "${getVariableType(type.returnType)} (*$name)(${parameters.join(", ")})";
  } else if (type is TypeParameterType) {
    return type.parameter.name ?? "";
  } else if (type is DynamicType) {
    return "void*";
  } else if (type is FutureOrType) {
    return getVariableType(type.typeArgument);
  } else if (type is NeverType) {
    return "void";
  } else if (type is InvalidType) {
    return "void*";
  } else if (type is DynamicType) {
    return "void*";
  } else if (type is VoidType) {
    return "void";
  } else if (type is TypeParameterType) {
    return "Object*";
  } else if (type is NullType) {
    return "Object*";
  } else {
    return "void*";
  }
}

String toString(TreeNode statement) {
  if (statement is Statement) {
    return (CppCodePrinter()
          ..writeStatement(statement)
          ..writeNewline())
        .getText();
  } else if (statement is Expression) {
    return (CppCodePrinter()
          ..writeExpression(statement)
          ..writeNewline())
        .getText();
  }
  return "void";
}

class CppCodePrinter {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  String getText() {
    return _buffer.toString();
  }

  void write(String text) {
    _buffer.write(text);
  }

  void writeNewline() {
    _buffer.write('\n');
    _buffer.write('  ' * _indentLevel);
  }

  void indent() {
    _indentLevel++;
  }

  void unindent() {
    _indentLevel--;
  }

  String logicalExpressionOperatorToString(LogicalExpressionOperator operator) {
    switch (operator) {
      case LogicalExpressionOperator.AND:
        return "&&";
      case LogicalExpressionOperator.OR:
        return "||";
    }
  }

  String getFunctionName(String name) {
    return name.replaceAll('.', '_');
  }

  String getMethodName(Member member) {
    return member.name.text;
  }

  void writeVariableDeclaration(VariableDeclaration variable) {
    write("${getVariableType(variable.type)} ");
    write(variable.name ?? '');
    if (variable.initializer != null) {
      write(' = ');
      writeExpression(variable.initializer!);
    }
  }

  void writeStatement(Statement statement) {
    if (statement is Block) {
      write('{');
      indent();
      for (var stmt in statement.statements) {
        writeStatement(stmt);
      }
      unindent();
      write('}');
    } else if (statement is SwitchStatement) {
      write('switch (');
      writeExpression(statement.expression);
      write(') {');
      indent();
      for (var switchCase in statement.cases) {
        if (switchCase.isDefault) {
          write('default: {');
        } else {
          write('case ');
          writeExpression(switchCase.expressions.first);
          write(': {');
        }
        indent();
        if (switchCase.body is Block) {
          Block block = switchCase.body as Block;
          for (var stmt in block.statements) {
            writeStatement(stmt);
          }
        } else {
          writeStatement(switchCase.body);
        }
        unindent();
        write('}');
      }
      unindent();
      write('}');
    } else if (statement is LabeledStatement) {
      // Skip label for now
      writeStatement(statement.body);
    } else if (statement is ExpressionStatement) {
      writeExpression(statement.expression);
      write(';');
    } else if (statement is ReturnStatement) {
      write('return');
      if (statement.expression != null) {
        write(' ');
        writeExpression(statement.expression!);
      }
      write(';');
    } else if (statement is IfStatement) {
      write('if (');
      writeExpression(statement.condition);
      write(') ');
      writeStatement(statement.then);
      if (statement.otherwise != null) {
        write(' else ');
        writeStatement(statement.otherwise!);
      }
    } else if (statement is BreakStatement) {
      write('break');
      write(';');
    } else if (statement is ContinueSwitchStatement) {
      write('continue');
      write(';');
    } else if (statement is VariableDeclaration) {
      write('${getVariableType(statement.type)} ');
      write(statement.name ?? '');
      if (statement.initializer != null) {
        write(' = ');
        writeExpression(statement.initializer!);
      }
      write(';');
    } else if (statement is WhileStatement) {
      write('while (');
      writeExpression(statement.condition);
      write(') ');
      writeStatement(statement.body);
    } else if (statement is ForStatement) {
      write('for (');
      if (statement.variables.isNotEmpty) {
        for (var variable in statement.variables) {
          writeVariableDeclaration(variable);
          if (variable != statement.variables.last) {
            write(',');
          }
        }
      }
      write('; ');
      if (statement.condition != null) {
        writeExpression(statement.condition!);
      }
      write('; ');
      if (statement.updates.isNotEmpty) {
        for (var update in statement.updates) {
          writeExpression(update);
          if (update != statement.updates.last) {
            write(',');
          }
        }
      }
      write(') ');
      writeStatement(statement.body);
    } else if (statement is DoStatement) {
      write('do ');
      writeStatement(statement.body);
      write(' while (');
      writeExpression(statement.condition);
      write(');');
    } else {
      print('Unhandled statement type: ${statement.runtimeType}');
    }
  }

  void writeExpression(Expression expression) {
    if (expression is ListLiteral) {
      write('List.from([');
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write('])');
    } else if (expression is MapLiteral) {
      write('Map.from([');
      bool first = true;
      for (var entry in expression.entries) {
        if (!first) write(', ');
        first = false;
        write('MapEntry(');
        writeExpression(entry.key);
        write(', ');
        writeExpression(entry.value);
        write(')');
      }
      write('])');
    } else if (expression is SetLiteral) {
      write('Set.from([');
      bool first = true;
      for (var item in expression.expressions) {
        if (!first) write(', ');
        first = false;
        writeExpression(item);
      }
      write('])');
    } else if (expression is LocalFunctionInvocation) {
      writeStatement(expression.variable);
      writeArgumentsList(
          expression.localFunction.function, expression.arguments);
    } else if (expression is StaticGet) {
    } else if (expression is FunctionInvocation) {
      write(expression.name.text);
      throw "eeeee FunctionInvocation " + expression.toString();
      // writeArgumentsList(
      //     expression., expression.arguments);
      //writeArgumentsList(expression.target.function, expression.arguments);
    } else if (expression is ConstantExpression) {
      write(' ');
    } else if (expression is LogicalExpression) {
      writeExpression(expression.left);
      write(' ');
      write(logicalExpressionOperatorToString(expression.operatorEnum));
      write(' ');
      writeExpression(expression.right);
    } else if (expression is IntLiteral) {
      write(expression.value.toString());
    } else if (expression is DoubleLiteral) {
      write(expression.value.toString());
    } else if (expression is StringLiteral) {
      write('"${expression.value}"');
    } else if (expression is BoolLiteral) {
      write(expression.value.toString());
    } else if (expression is NullLiteral) {
      write("nullptr");
    } else if (expression is VariableSet) {
      write(expression.variable.name ?? "");
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is VariableGet) {
      write(expression.variable.name ?? "");
    } else if (expression is ThisExpression) {
      write("this");
    } else if (expression is InstanceGet) {
      writeExpression(expression.receiver);
      write(".");
      write(expression.name.text);
    } else if (expression is InstanceSet) {
      writeExpression(expression.receiver);
      write(".");
      write(expression.name.text);
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is StaticInvocation) {
      write(expression.target.name.text);
      writeArgumentsList(expression.target.function, expression.arguments);
    } else if (expression is InstanceInvocation) {
      writeExpression(expression.receiver);
      if (expression.interfaceTarget.kind == ProcedureKind.Operator) {
        write(expression.name.text);
        writeArgumentsList(
            expression.interfaceTarget.function, expression.arguments);
      } else {
        write(".");
        write(expression.name.text);
        writeArgumentsList(
            expression.interfaceTarget.function, expression.arguments);
      }
    } else if (expression is StaticGet) {
      write(expression.target.name.text);
    } else if (expression is StaticSet) {
      write(expression.target.name.text);
      write(" = ");
      writeExpression(expression.value);
    } else if (expression is AsExpression) {
      writeExpression(expression.operand);
      write(" as ");
      write(getVariableType(expression.type));
    } else if (expression is IsExpression) {
      writeExpression(expression.operand);
      write(" is ");
      write(getVariableType(expression.type));
    } else if (expression is ConditionalExpression) {
      write('(');
      writeExpression(expression.condition);
      write(') ? ');
      writeExpression(expression.then);
      write(' : ');
      writeExpression(expression.otherwise);
    } else if (expression is Let) {
      // Handle Let expression
    } else if (expression is FunctionExpression) {
      write('[](');
      bool first = true;
      for (var parameter in expression.function.positionalParameters) {
        if (!first) write(", ");
        first = false;
        write(getVariableDeclaration(parameter));
      }
      for (var parameter in expression.function.namedParameters) {
        if (!first) write(", ");
        first = false;
        write(getVariableDeclaration(parameter));
      }
      write(')');
      if (expression.function.body != null) {
        writeStatement(expression.function.body!);
      }
    } else if (expression is StringConcatenation) {
      bool first = true;
      for (var exp in expression.expressions) {
        if (!first) write(" + ");
        first = false;
        writeExpression(exp);
      }
    } else {
      // Handle other expression types
      print('Unhandled expression type: ${expression.runtimeType}');
    }
  }

  void writeArgumentsList(FunctionNode function, Arguments arguments) {
    write('(');
    bool first = true;
    var positionalParameters = function.positionalParameters;
    for (var i = 0; i < positionalParameters.length; i++) {
      if (!first) {
        write(", ");
      }
      first = false;
      if (i < arguments.positional.length) {
        writeExpression(arguments.positional[i]);
      } else {
        if (positionalParameters[i].initializer != null) {
          writeExpression(positionalParameters[i].initializer!);
        } else {
          write("nullptr");
        }
      }
    }

    var namedArguments =
        Map.fromEntries(arguments.named.map((e) => MapEntry(e.name, e)));
    var namedParameters = function.namedParameters;
    for (var i = 0; i < namedParameters.length; i++) {
      if (!first) {
        write(", ");
      }
      first = false;
      var namedParameter = namedParameters[i];
      if (namedArguments.containsKey(namedParameter.name)) {
        writeExpression(namedArguments[namedParameter.name]!.value);
      } else {
        if (namedParameter.initializer != null) {
          writeExpression(namedParameter.initializer!);
        } else {
          write("nullptr");
        }
      }
    }
    write(')');
  }

  String getLabelName(Statement statement) {
    return '';
  }
}
