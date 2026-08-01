import 'package:dart2cpp/platform/dart/runtime_classes.dart';

class GreeterClassInfo extends ClassInfo {
  GreeterClassInfo() {
    greet = Greeter_greet;
    sayHello = Greeter_sayHello;
  }
  String Function(GreeterValue this_)? greet;
  void Function(GreeterValue this_)? sayHello;
}

class GreeterValue extends AnyGC {
  late String name;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<GreeterClassInfo>(runtimeType, GreeterClassInfo.new);
}

GreeterValue Greeter_new(AnyGC this__, String name) {
  final this_ = this__ as GreeterValue;
  this_.name = name;
  return this_;
}

String Greeter_greet(AnyGC this__) {
  final this_ = this__ as GreeterValue;
  return 'Hello, ${this_.name}!';
}

void Greeter_sayHello(AnyGC this__) {
  final this_ = this__ as GreeterValue;
  staticPrint((this_.classInfo as GreeterClassInfo).greet!(this_));
}


void main() {
  final GreeterValue greeter = Greeter_new(GC.allocateLocal(GreeterValue()), 'World');
  (greeter.classInfo as GreeterClassInfo).sayHello!(greeter);
  final StaticList<String> names = StaticList<String>.of(['Alice', 'Bob', 'Charlie']);
{
    StaticIterator<String> sync_for_iterator = StaticIterator(names.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final String name = sync_for_iterator.current;
{
        final GreeterValue g = Greeter_new(GC.allocateLocal(GreeterValue()), name);
        (g.classInfo as GreeterClassInfo).sayHello!(g);
      }
    }
  }
  drainScheduler();
}

