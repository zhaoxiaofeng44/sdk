import 'package:dart2cpp/platform/dart/runtime_classes.dart';

class GreeterValue extends VPtr {
  late String name;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['greet'] = Greeter_greet;
      vptrMap!['sayHello'] = Greeter_sayHello;
    }
    return vptrMap!;
  }
}

GreeterValue Greeter_new(dynamic this__, String name) {
  final this_ = this__ as GreeterValue;
  this_.name = name;
  return this_;
}

String Greeter_greet(dynamic this__) {
  final this_ = this__ as GreeterValue;
  return 'Hello, ${this_.name}!';
}

void Greeter_sayHello(dynamic this__) {
  final this_ = this__ as GreeterValue;
  staticPrint((this_.vptr['greet'] as String Function(dynamic))(this_));
}


void main() {
  final GreeterValue greeter = Greeter_new(GC.allocateLocal(GreeterValue()), 'World');
  (greeter.vptr['sayHello'] as void Function(dynamic))(greeter);
  final StaticList<String> names = StaticList<String>.of(['Alice', 'Bob', 'Charlie']);
{
    StaticIterator<String> sync_for_iterator = StaticIterator(names.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final String name = sync_for_iterator.current;
{
        final GreeterValue g = Greeter_new(GC.allocateLocal(GreeterValue()), name);
        (g.vptr['sayHello'] as void Function(dynamic))(g);
      }
    }
  }
}

