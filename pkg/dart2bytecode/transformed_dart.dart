import 'dart:core';
import 'dart:io';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 转换后的类: BitwiseTest
class BitwiseTest {
  BitwiseTest();
  
static BitwiseTest create(  ) {
    final instance = BitwiseTest();
    ;
    return instance;
  }
  
static int bitwiseAnd(BitwiseTest self, int other  ) {
    {
      return bitwiseAnd(self, other);
    }
  }
  
static dynamic test(BitwiseTest self  ) {
    {
      BitwiseTest test = BitwiseTest.create();
      self._value = 10;
      print(bitwiseAnd(self, 3));
      print(add(self, 5));
    }
  }
  
static int add(BitwiseTest self, int other  ) {
    {
      return add(self, other);
    }
  }
  
}

/// 转换后的类: AsyncError
class AsyncError implements Error {
  late Object error;
  late StackTrace stackTrace;
  
  AsyncError();
  
static AsyncError create(Object error, StackTrace stackTrace  ) {
    final instance = AsyncError();
    instance.error = error;
    instance.stackTrace = let_expression;
    ;
    return instance;
  }
  
static AsyncError create__(Object error, StackTrace stackTrace  ) {
    final instance = AsyncError();
    instance.error = error;
    instance.stackTrace = stackTrace;
    ;
    return instance;
  }
  
static String toString(AsyncError self  ) {
    return self.error;
  }
  
static StackTrace _stackTrace(AsyncError self  ) {
    return throw NoSuchMethodError.withInvocation(self, _InvocationMirror.create__withType(const SymbolConstant(#_stackTrace), 1, const ListConstant(const <Type>[]), const ListConstant(const <dynamic>[]), Map.unmodifiable(const MapConstant(const <Symbol, dynamic>{}))));
  }
  
static dynamic _stackTrace(AsyncError self, StackTrace value  ) {
    return throw NoSuchMethodError.withInvocation(self, _InvocationMirror.create__withType(const SymbolConstant(#_stackTrace=), 2, const ListConstant(const <Type>[]), List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const MapConstant(const <Symbol, dynamic>{}))));
  }
  
}

/// 转换后的类: DeferredLoadException
class DeferredLoadException implements Exception {
  late String _message;
  
  DeferredLoadException();
  
static DeferredLoadException create(String message  ) {
    final instance = DeferredLoadException();
    instance._message = message;
    ;
    return instance;
  }
  
static String toString(DeferredLoadException self  ) {
    return "DeferredLoadException: '" + self._message + "'";
  }
  
}

/// 转换后的类: FutureOr
class FutureOr {
  FutureOr();
  
static FutureOr create__(  ) {
    final instance = FutureOr();
    {
      throw UnsupportedError.create("FutureOr cannot be instantiated");
    }
    return instance;
  }
  
}

/// 转换后的类: Future
class Future {
  Future();
  
}

/// 转换后的类: TimeoutException
class TimeoutException implements Exception {
  late String message;
  late Duration duration;
  
  TimeoutException();
  
static TimeoutException create(String message, Duration duration  ) {
    final instance = TimeoutException();
    instance.message = message;
    instance.duration = duration;
    ;
    return instance;
  }
  
static String toString(TimeoutException self  ) {
    {
      String result = "TimeoutException";
if (!self.duration == null)       result = "TimeoutException after " + self.duration;
if (!self.message == null)       result = result + ": " + self.message;
      return result;
    }
  }
  
}

/// 转换后的类: Completer
class Completer {
  Completer();
  
}

/// 转换后的类: ParallelWaitError
class ParallelWaitError extends Error {
  late dynamic values;
  late dynamic errors;
  late AsyncError _defaultError;
  late int _errorCount;
  
  ParallelWaitError();
  
static ParallelWaitError create(dynamic values, dynamic errors, int errorCount, AsyncError defaultError  ) {
    final instance = ParallelWaitError();
    instance.values = values;
    instance.errors = errors;
    instance._defaultError = defaultError;
    instance._errorCount = errorCount;
    ;
    return instance;
  }
  
static String toString(ParallelWaitError self  ) {
    {
if (self._defaultError == null)       {
if (self._errorCount == null || lessThanOrEqual(self, 1))         {
          return "ParallelWaitError";
        }
        return "ParallelWaitError(" + let_expression + " errors)";
      }
      return "ParallelWaitError" + !self._errorCount == null && greaterThan(self, 1) ? "(" + let_expression + " errors)" : "" + ": " + self.error;
    }
  }
  
static StackTrace stackTrace(ParallelWaitError self  ) {
    return let_expression;
  }
  
}

/// 转换后的类: Stream
class Stream {
  Stream();
  
static Stream create(  ) {
    final instance = Stream();
    ;
    return instance;
  }
  
static bool isBroadcast(Stream self  ) {
    return false;
  }
  
static Stream asBroadcastStream(Stream self, Function onListen, Function onCancel  ) {
    {
      return _AsBroadcastStream.create(self, onListen, onCancel);
    }
  }
  
static Stream where(Stream self, Function test  ) {
    {
      return _WhereStream.create(self, test);
    }
  }
  
static Stream map(Stream self, Function convert  ) {
    {
      return _MapStream.create(self, convert);
    }
  }
  
static Stream asyncMap(Stream self, Function convert  ) {
    {
      _StreamControllerBase controller;
if (self.isBroadcast)       {
        controller = _SyncBroadcastStreamController.create(null, null);
      }
 else       {
        controller = _SyncStreamController.create(null, null, null, null);
      }
      self.onListen = () { /* TODO: 实现匿名函数 */ return null as dynamic; };
      return self.stream;
    }
  }
  
static Stream asyncExpand(Stream self, Function convert  ) {
    {
      _StreamControllerBase controller;
if (self.isBroadcast)       {
        controller = _SyncBroadcastStreamController.create(null, null);
      }
 else       {
        controller = _SyncStreamController.create(null, null, null, null);
      }
      self.onListen = () { /* TODO: 实现匿名函数 */ return null as dynamic; };
      return self.stream;
    }
  }
  
static Stream handleError(Stream self, Function onError, Function test  ) {
    {
      Function callback;
if (onError is Function)       {
        callback = onError;
      }
 else if (onError is Function)       {
        callback = (Object error, StackTrace formal_0) { /* TODO: 实现匿名函数 */ return null as dynamic; };
      }
 else       {
        throw ArgumentError.create_value(onError, "onError", const StringConstant("Error handler must accept one Object or one Object and a StackTrace as arguments."));
      }
      return _HandleErrorStream.create(self, callback, test);
    }
  }
  
static Stream expand(Stream self, Function convert  ) {
    {
      return _ExpandStream.create(self, convert);
    }
  }
  
static Future pipe(Stream self, StreamConsumer streamConsumer  ) {
    {
      return then(self, (dynamic formal_0) { /* TODO: 实现匿名函数 */ return null as Future; });
    }
  }
  
static Stream transform(Stream self, StreamTransformer streamTransformer  ) {
    {
      return bind(self, self);
    }
  }
  
static Future reduce(Stream self, Function combine  ) {
    {
      _Future result = _Future.create();
      bool seenFirst = false;
      dynamic value;
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return result;
    }
  }
  
static Future fold(Stream self, dynamic initialValue, Function combine  ) {
    {
      _Future result = _Future.create();
      dynamic value = initialValue;
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return result;
    }
  }
  
static Future join(Stream self, String separator  ) {
    {
      _Future result = _Future.create();
      StringBuffer buffer = StringBuffer.create();
      bool first = true;
      StreamSubscription subscription = listen(self, null);
      onData(self, self.isEmpty ? (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; } : (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return result;
    }
  }
  
static Future contains(Stream self, Object needle  ) {
    {
      _Future future = _Future.create();
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future forEach(Stream self, Function action  ) {
    {
      _Future future = _Future.create();
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future every(Stream self, Function test  ) {
    {
      _Future future = _Future.create();
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future any(Stream self, Function test  ) {
    {
      _Future future = _Future.create();
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future length(Stream self  ) {
    {
      _Future future = _Future.create();
      int count = 0;
      listen(self, (dynamic formal_0) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future isEmpty(Stream self  ) {
    {
      _Future future = _Future.create();
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic formal_0) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Stream cast(Stream self  ) {
    return Stream.castFrom(self);
  }
  
static Future toList(Stream self  ) {
    {
      List result = _GrowableList.(0);
      _Future future = _Future.create();
      listen(self, (dynamic data) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future toSet(Stream self  ) {
    {
      Set result = _Set.create();
      _Future future = _Future.create();
      listen(self, (dynamic data) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future drain(Stream self, dynamic futureValue  ) {
    {
if (futureValue == null)       {
        futureValue = let_expression;
      }
      return asFuture(self, futureValue);
    }
  }
  
static Stream take(Stream self, int count  ) {
    {
      return _TakeStream.create(self, count);
    }
  }
  
static Stream takeWhile(Stream self, Function test  ) {
    {
      return _TakeWhileStream.create(self, test);
    }
  }
  
static Stream skip(Stream self, int count  ) {
    {
      return _SkipStream.create(self, count);
    }
  }
  
static Stream skipWhile(Stream self, Function test  ) {
    {
      return _SkipWhileStream.create(self, test);
    }
  }
  
static Stream distinct(Stream self, Function equals  ) {
    {
      return _DistinctStream.create(self, equals);
    }
  }
  
static Future first(Stream self  ) {
    {
      _Future future = _Future.create();
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future last(Stream self  ) {
    {
      _Future future = _Future.create();
      dynamic result;
      bool foundResult = false;
      listen(self, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future single(Stream self  ) {
    {
      _Future future = _Future.create();
      dynamic result;
      bool foundResult = false;
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future firstWhere(Stream self, Function test, Function orElse  ) {
    {
      _Future future = _Future.create();
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future lastWhere(Stream self, Function test, Function orElse  ) {
    {
      _Future future = _Future.create();
      dynamic result;
      bool foundResult = false;
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future singleWhere(Stream self, Function test, Function orElse  ) {
    {
      _Future future = _Future.create();
      dynamic result;
      bool foundResult = false;
      StreamSubscription subscription = listen(self, null);
      onData(self, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return future;
    }
  }
  
static Future elementAt(Stream self, int index  ) {
    {
      RangeError.checkNotNegative(index, "index");
      _Future result = _Future.create();
      int elementIndex = 0;
      StreamSubscription subscription;
      subscription = listen(self, null);
      onData(self, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      return result;
    }
  }
  
static Stream timeout(Stream self, Duration timeLimit, Function onTimeout  ) {
    {
      _StreamControllerBase controller;
if (self.isBroadcast)       {
        controller = _SyncBroadcastStreamController.create(null, null);
      }
 else       {
        controller = _SyncStreamController.create(null, null, null, null);
      }
      Zone zone = self.current;
      Function timeoutCallback;
if (onTimeout == null)       {
        timeoutCallback = () { /* TODO: 实现匿名函数 */ return null as dynamic; };
      }
 else       {
        Function registeredOnTimeout = registerUnaryCallback(self, onTimeout);
        _ControllerEventSinkWrapper wrapper = _ControllerEventSinkWrapper.create(null);
        timeoutCallback = () { /* TODO: 实现匿名函数 */ return null as dynamic; };
      }
      self.onListen = () { /* TODO: 实现匿名函数 */ return null as dynamic; };
      return self.stream;
    }
  }
  
}

/// 转换后的类: StreamSubscription
class StreamSubscription {
  StreamSubscription();
  
static StreamSubscription create(  ) {
    final instance = StreamSubscription();
    ;
    return instance;
  }
  
}

/// 转换后的类: EventSink
class EventSink implements Sink {
  EventSink();
  
static EventSink create(  ) {
    final instance = EventSink();
    ;
    return instance;
  }
  
}

/// 转换后的类: StreamView
class StreamView extends Stream {
  late Stream _stream;
  
  StreamView();
  
static StreamView create(Stream stream  ) {
    final instance = StreamView();
    instance._stream = stream;
    ;
    return instance;
  }
  
static bool isBroadcast(StreamView self  ) {
    return self.isBroadcast;
  }
  
static Stream asBroadcastStream(StreamView self, Function onListen, Function onCancel  ) {
    return asBroadcastStream(self, );
  }
  
static StreamSubscription listen(StreamView self, Function onData, Function onError, Function onDone, bool cancelOnError  ) {
    {
      return listen(self, onData);
    }
  }
  
}

/// 转换后的类: StreamConsumer
class StreamConsumer {
  StreamConsumer();
  
static StreamConsumer create(  ) {
    final instance = StreamConsumer();
    ;
    return instance;
  }
  
}

/// 转换后的类: StreamSink
class StreamSink implements EventSink, StreamConsumer {
  StreamSink();
  
static StreamSink create(  ) {
    final instance = StreamSink();
    ;
    return instance;
  }
  
}

/// 转换后的类: StreamTransformer
class StreamTransformer {
  StreamTransformer();
  
}

/// 转换后的类: StreamTransformerBase
class StreamTransformerBase implements StreamTransformer {
  StreamTransformerBase();
  
static StreamTransformerBase create(  ) {
    final instance = StreamTransformerBase();
    ;
    return instance;
  }
  
static StreamTransformer cast(StreamTransformerBase self  ) {
    return StreamTransformer.castFrom(self);
  }
  
}

/// 转换后的类: StreamIterator
class StreamIterator {
  StreamIterator();
  
}

/// 转换后的类: MultiStreamController
class MultiStreamController implements StreamController {
  MultiStreamController();
  
static MultiStreamController create(  ) {
    final instance = MultiStreamController();
    ;
    return instance;
  }
  
}

/// 转换后的类: StreamController
class StreamController implements StreamSink {
  StreamController();
  
}

/// 转换后的类: SynchronousStreamController
class SynchronousStreamController implements StreamController {
  SynchronousStreamController();
  
static SynchronousStreamController create(  ) {
    final instance = SynchronousStreamController();
    ;
    return instance;
  }
  
}

/// 转换后的类: Timer
class Timer {
  Timer();
  
}

/// 转换后的类: ZoneSpecification
class ZoneSpecification {
  ZoneSpecification();
  
}

/// 转换后的类: ZoneDelegate
class ZoneDelegate {
  ZoneDelegate();
  
static ZoneDelegate create(  ) {
    final instance = ZoneDelegate();
    ;
    return instance;
  }
  
}

/// 转换后的类: Zone
class Zone {
  Zone();
  
static Zone create__(  ) {
    final instance = Zone();
    ;
    return instance;
  }
  
}

/// 转换后的类: UnmodifiableListView
class UnmodifiableListView extends UnmodifiableListBase {
  late Iterable _source;
  
  UnmodifiableListView();
  
static UnmodifiableListView create(Iterable source  ) {
    final instance = UnmodifiableListView();
    instance._source = source;
    ;
    return instance;
  }
  
static List cast(UnmodifiableListView self  ) {
    return UnmodifiableListView.create(cast(self, ));
  }
  
static int length(UnmodifiableListView self  ) {
    return self.length;
  }
  
static dynamic getElement(UnmodifiableListView self, int index  ) {
    return elementAt(self, index);
  }
  
}

/// 转换后的类: HashMap
class HashMap implements Map {
  HashMap();
  
}

/// 转换后的类: HashSet
class HashSet implements Set {
  HashSet();
  
}

/// 转换后的类: HasNextIterator
class HasNextIterator {
  HasNextIterator();
  
static HasNextIterator create(Iterator iterator  ) {
    final instance = HasNextIterator();
    instance._iterator = iterator;
    ;
    return instance;
  }
  
static bool hasNext(HasNextIterator self  ) {
    return self._ensureHasNext;
  }
  
static bool _ensureHasNext(HasNextIterator self  ) {
    return let_expression;
  }
  
static dynamic next(HasNextIterator self  ) {
    {
if (self._ensureHasNext)       {
        self._hasNext = null;
        return self.current;
      }
      throw StateError.create("No more elements");
    }
  }
  
}

/// 转换后的类: LinkedHashMap
class LinkedHashMap implements Map {
  LinkedHashMap();
  
}

/// 转换后的类: LinkedHashSet
class LinkedHashSet implements Set {
  LinkedHashSet();
  
}

/// 转换后的类: LinkedList
class LinkedList extends Iterable {
  LinkedList();
  
static LinkedList create(  ) {
    final instance = LinkedList();
    ;
    return instance;
  }
  
static dynamic addFirst(LinkedList self, dynamic entry  ) {
    {
      _insertBefore(self, self._first, entry);
      self._first = entry;
    }
  }
  
static dynamic add(LinkedList self, dynamic entry  ) {
    {
      _insertBefore(self, self._first, entry);
    }
  }
  
static dynamic addAll(LinkedList self, Iterable entries  ) {
    {
      forEach(self, instance_tearoff);
    }
  }
  
static bool remove(LinkedList self, dynamic entry  ) {
    {
if (!self._list == self)       return false;
      _unlink(self, entry);
      return true;
    }
  }
  
static bool contains(LinkedList self, Object entry  ) {
    return entry is LinkedListEntry && identical(self, self.list);
  }
  
static Iterator iterator(LinkedList self  ) {
    return _LinkedListIterator.create(self);
  }
  
static int length(LinkedList self  ) {
    return self._length;
  }
  
static dynamic clear(LinkedList self  ) {
    {
      self._modificationCount = add(self, 1);
if (self.isEmpty)       return Void;
      dynamic next = self._first!;
do       {
        dynamic entry = next;
        next = self._next!;
        self._next = self._previous = self._list = null;
      }
 while (!identical(next, self._first));      self._first = null;
      self._length = 0;
    }
  }
  
static dynamic first(LinkedList self  ) {
    {
if (self.isEmpty)       {
        throw StateError.create("No such element");
      }
      return self._first!;
    }
  }
  
static dynamic last(LinkedList self  ) {
    {
if (self.isEmpty)       {
        throw StateError.create("No such element");
      }
      return self._previous!;
    }
  }
  
static dynamic single(LinkedList self  ) {
    {
if (self.isEmpty)       {
        throw StateError.create("No such element");
      }
if (greaterThan(self, 1))       {
        throw StateError.create("Too many elements");
      }
      return self._first!;
    }
  }
  
static dynamic forEach(LinkedList self, Function action  ) {
    {
      int modificationCount = self._modificationCount;
if (self.isEmpty)       return Void;
      dynamic current = self._first!;
do       {
        functionInvocation(current);
if (!modificationCount == self._modificationCount)         {
          throw ConcurrentModificationError.create(self);
        }
        current = self._next!;
      }
 while (!identical(current, self._first));    }
  }
  
static bool isEmpty(LinkedList self  ) {
    return self._length == 0;
  }
  
static dynamic _insertBefore(LinkedList self, dynamic entry, dynamic newEntry, bool updateFirst  ) {
    {
if (!self.list == null)       {
        throw StateError.create("LinkedListEntry is already in a LinkedList");
      }
      self._modificationCount = add(self, 1);
      self._list = self;
if (self.isEmpty)       {
assert(entry == null        );
        self._previous = self._next = newEntry;
        self._first = newEntry;
        self._length = add(self, 1);
        return Void;
      }
      dynamic predecessor = self._previous!;
      dynamic successor = entry;
      self._previous = predecessor;
      self._next = successor;
      self._next = newEntry;
      self._previous = newEntry;
if (updateFirst && identical(entry, self._first))       {
        self._first = newEntry;
      }
      self._length = add(self, 1);
    }
  }
  
static dynamic _unlink(LinkedList self, dynamic entry  ) {
    {
      self._modificationCount = add(self, 1);
      self._previous = self._previous;
      dynamic next = self._next = self._next;
      self._length = subtract(self, 1);
      self._list = self._next = self._previous = null;
if (self.isEmpty)       {
        self._first = null;
      }
 else if (identical(entry, self._first))       {
        self._first = next;
      }
    }
  }
  
}

/// 转换后的类: LinkedListEntry
class LinkedListEntry {
  LinkedListEntry();
  
static LinkedListEntry create(  ) {
    final instance = LinkedListEntry();
    ;
    return instance;
  }
  
static LinkedList list(LinkedListEntry self  ) {
    return self._list;
  }
  
static dynamic unlink(LinkedListEntry self  ) {
    {
      _unlink(self, self as dynamic);
    }
  }
  
static dynamic next(LinkedListEntry self  ) {
    {
if (self._list == null || identical(self.first, self._next))       return null;
      return self._next;
    }
  }
  
static dynamic previous(LinkedListEntry self  ) {
    {
if (self._list == null || identical(self, self.first))       return null;
      return self._previous;
    }
  }
  
static dynamic insertAfter(LinkedListEntry self, dynamic entry  ) {
    {
      _insertBefore(self, self._next, entry);
    }
  }
  
static dynamic insertBefore(LinkedListEntry self, dynamic entry  ) {
    {
      _insertBefore(self, self as dynamic, entry);
    }
  }
  
}

/// 转换后的类: ListBase
class ListBase implements List {
  ListBase();
  
static ListBase create(  ) {
    final instance = ListBase();
    ;
    return instance;
  }
  
static Iterator iterator(ListBase self  ) {
    return ListIterator.create(self);
  }
  
static dynamic elementAt(ListBase self, int index  ) {
    return getElement(self, index);
  }
  
static Iterable followedBy(ListBase self, Iterable other  ) {
    return FollowedByIterable.firstEfficient(self, other);
  }
  
static dynamic forEach(ListBase self, Function action  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        functionInvocation(getElement(self, i));
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
    }
  }
  
static bool isEmpty(ListBase self  ) {
    return self.length == 0;
  }
  
static bool isNotEmpty(ListBase self  ) {
    return !self.isEmpty;
  }
  
static dynamic first(ListBase self  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
      return getElement(self, 0);
    }
  }
  
static dynamic first(ListBase self, dynamic value  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
      setElement(self, 0, value);
    }
  }
  
static dynamic last(ListBase self  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
      return getElement(self, subtract(self, 1));
    }
  }
  
static dynamic last(ListBase self, dynamic value  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
      setElement(self, subtract(self, 1), value);
    }
  }
  
static dynamic single(ListBase self  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
if (greaterThan(self, 1))       throw IterableElementError.tooMany();
      return getElement(self, 0);
    }
  }
  
static bool contains(ListBase self, Object element  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
if (getElement(self, i) == element)         return true;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return false;
    }
  }
  
static bool every(ListBase self, Function test  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
if (!functionInvocation(getElement(self, i)))         return false;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return true;
    }
  }
  
static bool any(ListBase self, Function test  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
if (functionInvocation(getElement(self, i)))         return true;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return false;
    }
  }
  
static dynamic firstWhere(ListBase self, Function test, Function orElse  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        dynamic element = getElement(self, i);
if (functionInvocation(element))         return element;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic lastWhere(ListBase self, Function test, Function orElse  ) {
    {
      int length = self.length;
for (int i = subtract(self, 1); greaterThanOrEqual(self, 0); i = subtract(self, 1))       {
        dynamic element = getElement(self, i);
if (functionInvocation(element))         return element;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic singleWhere(ListBase self, Function test, Function orElse  ) {
    {
      int length = self.length;
      dynamic match;
      bool matchFound = false;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        dynamic element = getElement(self, i);
if (functionInvocation(element))         {
if (matchFound)           {
            throw IterableElementError.tooMany();
          }
          matchFound = true;
          match = element;
        }
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
if (matchFound)       return match;
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static String join(ListBase self, String separator  ) {
    {
if (self.length == 0)       return "";
      StringBuffer buffer = let_expression;
      return toString(self, );
    }
  }
  
static Iterable where(ListBase self, Function test  ) {
    return WhereIterable.create(self, test);
  }
  
static Iterable whereType(ListBase self  ) {
    return WhereTypeIterable.create(self);
  }
  
static Iterable map(ListBase self, Function f  ) {
    return MappedListIterable.create(self, f);
  }
  
static Iterable expand(ListBase self, Function f  ) {
    return ExpandIterable.create(self, f);
  }
  
static dynamic reduce(ListBase self, Function combine  ) {
    {
      int length = self.length;
if (length == 0)       throw IterableElementError.noElement();
      dynamic value = getElement(self, 0);
for (int i = 1; lessThan(self, length); i = add(self, 1))       {
        value = functionInvocation(value, getElement(self, i));
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return value;
    }
  }
  
static dynamic fold(ListBase self, dynamic initialValue, Function combine  ) {
    {
      dynamic value = initialValue;
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        value = functionInvocation(value, getElement(self, i));
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return value;
    }
  }
  
static Iterable skip(ListBase self, int count  ) {
    return SubListIterable.create(self, count, null);
  }
  
static Iterable skipWhile(ListBase self, Function test  ) {
    {
      return SkipWhileIterable.create(self, test);
    }
  }
  
static Iterable take(ListBase self, int count  ) {
    return SubListIterable.create(self, 0, checkNotNullable(count, "count"));
  }
  
static Iterable takeWhile(ListBase self, Function test  ) {
    {
      return TakeWhileIterable.create(self, test);
    }
  }
  
static List toList(ListBase self, bool growable  ) {
    {
if (self.isEmpty)       return List.empty();
      dynamic first = getElement(self, 0);
      List result = List.filled(self.length, first);
for (int i = 1; lessThan(self, self.length); i = add(self, 1))       {
        setElement(self, i, getElement(self, i));
      }
      return result;
    }
  }
  
static Set toSet(ListBase self  ) {
    {
      Set result = _Set.create();
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        add(self, getElement(self, i));
      }
      return result;
    }
  }
  
static dynamic add(ListBase self, dynamic element  ) {
    {
      setElement(self, let_expression, element);
    }
  }
  
static dynamic addAll(ListBase self, Iterable iterable  ) {
    {
      int i = self.length;
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
assert(self.length == i || throw ConcurrentModificationError.create(self)            );
            add(self, element);
            i = add(self, 1);
          }
        }
      }
    }
  }
  
static bool remove(ListBase self, Object element  ) {
    {
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
if (getElement(self, i) == element)         {
          _closeGap(self, i, add(self, 1));
          return true;
        }
      }
      return false;
    }
  }
  
static dynamic _closeGap(ListBase self, int start, int end  ) {
    {
      int length = self.length;
assert(lessThanOrEqual(self, start)      );
assert(lessThan(self, end)      );
assert(lessThanOrEqual(self, length)      );
      int size = subtract(self, start);
for (int i = end; lessThan(self, length); i = add(self, 1))       {
        setElement(self, subtract(self, size), getElement(self, i));
      }
      self.length = subtract(self, size);
    }
  }
  
static dynamic removeWhere(ListBase self, Function test  ) {
    {
      _filter(self, test, false);
    }
  }
  
static dynamic retainWhere(ListBase self, Function test  ) {
    {
      _filter(self, test, true);
    }
  }
  
static dynamic _filter(ListBase self, Function test, bool retainMatching  ) {
    {
      List retained = _GrowableList.(0);
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        dynamic element = getElement(self, i);
if (functionInvocation(element) == retainMatching)         {
          add(self, element);
        }
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
if (!self.length == self.length)       {
        setRange(self, 0, self.length, retained);
        self.length = self.length;
      }
    }
  }
  
static dynamic clear(ListBase self  ) {
    {
      self.length = 0;
    }
  }
  
static List cast(ListBase self  ) {
    return List.castFrom(self);
  }
  
static dynamic removeLast(ListBase self  ) {
    {
if (self.length == 0)       {
        throw IterableElementError.noElement();
      }
      dynamic result = getElement(self, subtract(self, 1));
      self.length = subtract(self, 1);
      return result;
    }
  }
  
static dynamic sort(ListBase self, Function compare  ) {
    {
      Sort.sort(self, let_expression);
    }
  }
  
static dynamic shuffle(ListBase self, Random random  ) {
    {
      random == null ? random = Random.() : null;
      int length = self.length;
while (greaterThan(self, 1))       {
        int pos = nextInt(self, length);
        length = subtract(self, 1);
        dynamic tmp = getElement(self, length);
        setElement(self, length, getElement(self, pos));
        setElement(self, pos, tmp);
      }
    }
  }
  
static Map asMap(ListBase self  ) {
    {
      return ListMapView.create(self);
    }
  }
  
static List sublist(ListBase self, int start, int end  ) {
    {
      int listLength = self.length;
      end == null ? end = listLength : null;
      RangeError.checkValidRange(start, end, listLength);
      return List.of(getRange(self, start, end));
    }
  }
  
static Iterable getRange(ListBase self, int start, int end  ) {
    {
      RangeError.checkValidRange(start, end, self.length);
      return SubListIterable.create(self, start, end);
    }
  }
  
static dynamic removeRange(ListBase self, int start, int end  ) {
    {
      RangeError.checkValidRange(start, end, self.length);
if (greaterThan(self, start))       {
        _closeGap(self, start, end);
      }
    }
  }
  
static dynamic fillRange(ListBase self, int start, int end, dynamic fill  ) {
    {
      dynamic value = let_expression;
      RangeError.checkValidRange(start, end, self.length);
for (int i = start; lessThan(self, end); i = add(self, 1))       {
        setElement(self, i, value);
      }
    }
  }
  
static dynamic setRange(ListBase self, int start, int end, Iterable iterable, int skipCount  ) {
    {
      RangeError.checkValidRange(start, end, self.length);
      int length = subtract(self, start);
if (length == 0)       return Void;
      RangeError.checkNotNegative(skipCount, "skipCount");
      List otherList;
      int otherStart;
if (iterable is List)       {
        otherList = iterable;
        otherStart = skipCount;
      }
 else       {
        otherList = toList(self, );
        otherStart = 0;
      }
if (greaterThan(self, self.length))       {
        throw IterableElementError.tooFew();
      }
if (lessThan(self, start))       {
for (int i = subtract(self, 1); greaterThanOrEqual(self, 0); i = subtract(self, 1))         {
          setElement(self, add(self, i), getElement(self, add(self, i)));
        }
      }
 else       {
for (int i = 0; lessThan(self, length); i = add(self, 1))         {
          setElement(self, add(self, i), getElement(self, add(self, i)));
        }
      }
    }
  }
  
static dynamic replaceRange(ListBase self, int start, int end, Iterable newContents  ) {
    {
      RangeError.checkValidRange(start, end, self.length);
if (start == self.length)       {
        addAll(self, newContents);
        return Void;
      }
if (!newContents is EfficientLengthIterable)       {
        newContents = toList(self, );
      }
      int removeLength = subtract(self, start);
      int insertLength = self.length;
if (greaterThanOrEqual(self, insertLength))       {
        int insertEnd = add(self, insertLength);
        setRange(self, start, insertEnd, newContents);
if (greaterThan(self, insertLength))         {
          _closeGap(self, insertEnd, end);
        }
      }
 else if (end == self.length)       {
        int i = start;
        {
          Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )           {
            dynamic element = self.current;
            {
if (lessThan(self, end))               {
                setElement(self, i, element);
              }
 else               {
                add(self, element);
              }
              i = add(self, 1);
            }
          }
        }
      }
 else       {
        int delta = subtract(self, removeLength);
        int oldLength = self.length;
        int insertEnd = add(self, insertLength);
for (int i = subtract(self, delta); lessThan(self, oldLength); i = add(self, 1))         {
          add(self, getElement(self, greaterThan(self, 0) ? i : 0));
        }
if (lessThan(self, oldLength))         {
          setRange(self, insertEnd, oldLength, self, end);
        }
        setRange(self, start, insertEnd, newContents);
      }
    }
  }
  
static int indexOf(ListBase self, Object element, int start  ) {
    {
if (lessThan(self, 0))       start = 0;
for (int i = start; lessThan(self, self.length); i = add(self, 1))       {
if (getElement(self, i) == element)         return i;
      }
      return negate(self);
    }
  }
  
static int indexWhere(ListBase self, Function test, int start  ) {
    {
if (lessThan(self, 0))       start = 0;
for (int i = start; lessThan(self, self.length); i = add(self, 1))       {
if (functionInvocation(getElement(self, i)))         return i;
      }
      return negate(self);
    }
  }
  
static int lastIndexOf(ListBase self, Object element, int start  ) {
    {
if (start == null || greaterThanOrEqual(self, self.length))       start = subtract(self, 1);
for (int i = start; greaterThanOrEqual(self, 0); i = subtract(self, 1))       {
if (getElement(self, i) == element)         return i;
      }
      return negate(self);
    }
  }
  
static int lastIndexWhere(ListBase self, Function test, int start  ) {
    {
if (start == null || greaterThanOrEqual(self, self.length))       start = subtract(self, 1);
for (int i = start; greaterThanOrEqual(self, 0); i = subtract(self, 1))       {
if (functionInvocation(getElement(self, i)))         return i;
      }
      return negate(self);
    }
  }
  
static dynamic insert(ListBase self, int index, dynamic element  ) {
    {
      checkNotNullable(index, "index");
      int length = self.length;
      RangeError.checkValueInInterval(index, 0, length, "index");
      add(self, element);
if (!index == length)       {
        setRange(self, add(self, 1), add(self, 1), self, index);
        setElement(self, index, element);
      }
    }
  }
  
static dynamic removeAt(ListBase self, int index  ) {
    {
      dynamic result = getElement(self, index);
      _closeGap(self, index, add(self, 1));
      return result;
    }
  }
  
static dynamic insertAll(ListBase self, int index, Iterable iterable  ) {
    {
      RangeError.checkValueInInterval(index, 0, self.length, "index");
if (index == self.length)       {
        addAll(self, iterable);
        return Void;
      }
if (!iterable is EfficientLengthIterable || identical(iterable, self))       {
        iterable = toList(self, );
      }
      int insertionLength = self.length;
if (insertionLength == 0)       {
        return Void;
      }
      int oldLength = self.length;
for (int i = subtract(self, insertionLength); lessThan(self, oldLength); i = add(self, 1))       {
        add(self, getElement(self, greaterThan(self, 0) ? i : 0));
      }
if (!self.length == insertionLength)       {
        self.length = subtract(self, insertionLength);
        throw ConcurrentModificationError.create(iterable);
      }
      int oldCopyStart = add(self, insertionLength);
if (lessThan(self, oldLength))       {
        setRange(self, oldCopyStart, oldLength, self, index);
      }
      setAll(self, index, iterable);
    }
  }
  
static dynamic setAll(ListBase self, int index, Iterable iterable  ) {
    {
if (iterable is List)       {
        setRange(self, index, add(self, self.length), iterable);
      }
 else       {
        {
          Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )           {
            dynamic element = self.current;
            {
              setElement(self, let_expression, element);
            }
          }
        }
      }
    }
  }
  
static Iterable reversed(ListBase self  ) {
    return ReversedListIterable.create(self);
  }
  
static String toString(ListBase self  ) {
    return ListBase.listToString(self);
  }
  
static List add(ListBase self, List other  ) {
    return (() {
    List var = List.of(self);
    addAll(self, other);
    return null;
  })();
  }
  
}

/// 转换后的类: MapBase
class MapBase implements Map {
  MapBase();
  
static MapBase create(  ) {
    final instance = MapBase();
    ;
    return instance;
  }
  
static Map cast(MapBase self  ) {
    return Map.castFrom(self);
  }
  
static dynamic forEach(MapBase self, Function action  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic key = self.current;
          {
            functionInvocation(key, let_expression);
          }
        }
      }
    }
  }
  
static dynamic addAll(MapBase self, Map other  ) {
    {
      forEach(self, (dynamic key, dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
    }
  }
  
static bool containsValue(MapBase self, Object value  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic key = self.current;
          {
if (getElement(self, key) == value)             return true;
          }
        }
      }
      return false;
    }
  }
  
static dynamic putIfAbsent(MapBase self, dynamic key, Function ifAbsent  ) {
    {
if (containsKey(self, key))       {
        return let_expression;
      }
      return let_expression;
    }
  }
  
static dynamic update(MapBase self, dynamic key, Function update, Function ifAbsent  ) {
    {
if (containsKey(self, key))       {
        return let_expression;
      }
if (!ifAbsent == null)       {
        return let_expression;
      }
      throw ArgumentError.create_value(key, "key", "Key not in map.");
    }
  }
  
static dynamic updateAll(MapBase self, Function update  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic key = self.current;
          {
            setElement(self, key, functionInvocation(key, let_expression));
          }
        }
      }
    }
  }
  
static Iterable entries(MapBase self  ) {
    {
      return map(self, (dynamic key) { /* TODO: 实现匿名函数 */ return null as MapEntry; });
    }
  }
  
static Map map(MapBase self, Function transform  ) {
    {
      Map result = {};
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic key = self.current;
          {
            MapEntry entry = functionInvocation(key, let_expression);
            setElement(self, self.key, self.value);
          }
        }
      }
      return result;
    }
  }
  
static dynamic addEntries(MapBase self, Iterable newEntries  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          MapEntry entry = self.current;
          {
            setElement(self, self.key, self.value);
          }
        }
      }
    }
  }
  
static dynamic removeWhere(MapBase self, Function test  ) {
    {
      List keysToRemove = _GrowableList.(0);
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic key = self.current;
          {
if (functionInvocation(key, let_expression))             add(self, key);
          }
        }
      }
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic key = self.current;
          {
            remove(self, key);
          }
        }
      }
    }
  }
  
static bool containsKey(MapBase self, Object key  ) {
    return contains(self, key);
  }
  
static int length(MapBase self  ) {
    return self.length;
  }
  
static bool isEmpty(MapBase self  ) {
    return self.isEmpty;
  }
  
static bool isNotEmpty(MapBase self  ) {
    return self.isNotEmpty;
  }
  
static Iterable values(MapBase self  ) {
    return _MapBaseValueIterable.create(self);
  }
  
static String toString(MapBase self  ) {
    return MapBase.mapToString(self);
  }
  
}

/// 转换后的类: UnmodifiableMapBase
class UnmodifiableMapBase extends MapBase implements _UnmodifiableMapMixin {
  UnmodifiableMapBase();
  
static UnmodifiableMapBase create(  ) {
    final instance = UnmodifiableMapBase();
    ;
    return instance;
  }
  
static dynamic addAll(UnmodifiableMapBase self, Map other  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic addEntries(UnmodifiableMapBase self, Iterable entries  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic clear(UnmodifiableMapBase self  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic remove(UnmodifiableMapBase self, Object key  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic removeWhere(UnmodifiableMapBase self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic putIfAbsent(UnmodifiableMapBase self, dynamic key, Function ifAbsent  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic update(UnmodifiableMapBase self, dynamic key, Function update, Function ifAbsent  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic updateAll(UnmodifiableMapBase self, Function update  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
static dynamic setElement(UnmodifiableMapBase self, dynamic keydynamic value  ) {
    {
      throw UnsupportedError.create("Cannot modify unmodifiable map");
    }
  }
  
}

/// 转换后的类: MapView
class MapView implements Map {
  late Map _map;
  
  MapView();
  
static MapView create(Map map  ) {
    final instance = MapView();
    instance._map = map;
    ;
    return instance;
  }
  
static Map cast(MapView self  ) {
    return cast(self, );
  }
  
static dynamic addAll(MapView self, Map other  ) {
    {
      addAll(self, other);
    }
  }
  
static dynamic clear(MapView self  ) {
    {
      clear(self, );
    }
  }
  
static dynamic putIfAbsent(MapView self, dynamic key, Function ifAbsent  ) {
    return putIfAbsent(self, key, ifAbsent);
  }
  
static bool containsKey(MapView self, Object key  ) {
    return containsKey(self, key);
  }
  
static bool containsValue(MapView self, Object value  ) {
    return containsValue(self, value);
  }
  
static dynamic forEach(MapView self, Function action  ) {
    {
      forEach(self, action);
    }
  }
  
static bool isEmpty(MapView self  ) {
    return self.isEmpty;
  }
  
static bool isNotEmpty(MapView self  ) {
    return self.isNotEmpty;
  }
  
static int length(MapView self  ) {
    return self.length;
  }
  
static Iterable keys(MapView self  ) {
    return self.keys;
  }
  
static dynamic remove(MapView self, Object key  ) {
    return remove(self, key);
  }
  
static String toString(MapView self  ) {
    return toString(self, );
  }
  
static Iterable values(MapView self  ) {
    return self.values;
  }
  
static Iterable entries(MapView self  ) {
    return self.entries;
  }
  
static dynamic addEntries(MapView self, Iterable entries  ) {
    {
      addEntries(self, entries);
    }
  }
  
static Map map(MapView self, Function transform  ) {
    return map(self, transform);
  }
  
static dynamic update(MapView self, dynamic key, Function update, Function ifAbsent  ) {
    return update(self, key, update);
  }
  
static dynamic updateAll(MapView self, Function update  ) {
    {
      updateAll(self, update);
    }
  }
  
static dynamic removeWhere(MapView self, Function test  ) {
    {
      removeWhere(self, test);
    }
  }
  
static dynamic getElement(MapView self, Object key  ) {
    return getElement(self, key);
  }
  
static dynamic setElement(MapView self, dynamic keydynamic value  ) {
    {
      setElement(self, key, value);
    }
  }
  
}

/// 转换后的类: UnmodifiableMapView
class UnmodifiableMapView extends _UnmodifiableMapView_MapView__UnmodifiableMapMixin {
  UnmodifiableMapView();
  
static UnmodifiableMapView create(Map map  ) {
    final instance = UnmodifiableMapView();
    ;
    return instance;
  }
  
static Map cast(UnmodifiableMapView self  ) {
    return UnmodifiableMapView.create(cast(self, ));
  }
  
}

/// 转换后的类: Queue
class Queue implements Iterable, _QueueIterable {
  Queue();
  
}

/// 转换后的类: DoubleLinkedQueue
class DoubleLinkedQueue extends Iterable implements Queue {
  late _DoubleLinkedQueueSentinel _sentinel;
  
  DoubleLinkedQueue();
  
static DoubleLinkedQueue create(  ) {
    final instance = DoubleLinkedQueue();
    ;
    return instance;
  }
  
static Queue cast(DoubleLinkedQueue self  ) {
    return Queue.castFrom(self);
  }
  
static int length(DoubleLinkedQueue self  ) {
    return self._elementCount;
  }
  
static dynamic addLast(DoubleLinkedQueue self, dynamic value  ) {
    {
      _prepend(self, value, self);
      self._elementCount = add(self, 1);
    }
  }
  
static dynamic addFirst(DoubleLinkedQueue self, dynamic value  ) {
    {
      _append(self, value, self);
      self._elementCount = add(self, 1);
    }
  }
  
static dynamic add(DoubleLinkedQueue self, dynamic value  ) {
    {
      _prepend(self, value, self);
      self._elementCount = add(self, 1);
    }
  }
  
static dynamic addAll(DoubleLinkedQueue self, Iterable iterable  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic value = self.current;
          {
            _prepend(self, value, self);
            self._elementCount = add(self, 1);
          }
        }
      }
    }
  }
  
static dynamic removeLast(DoubleLinkedQueue self  ) {
    {
      dynamic result = _remove(self, );
      self._elementCount = subtract(self, 1);
      return result;
    }
  }
  
static dynamic removeFirst(DoubleLinkedQueue self  ) {
    {
      dynamic result = _remove(self, );
      self._elementCount = subtract(self, 1);
      return result;
    }
  }
  
static bool remove(DoubleLinkedQueue self, Object o  ) {
    {
      _DoubleLinkedQueueEntry entry = self._nextLink!;
while (true)       {
        _DoubleLinkedQueueElement elementEntry = _asNonSentinelEntry(self, );
if (elementEntry == null)         return false;
        bool equals = self.element == o;
if (!identical(self, self._queue))         {
          throw ConcurrentModificationError.create(self);
        }
if (equals)         {
          _remove(self, );
          self._elementCount = subtract(self, 1);
          return true;
        }
        entry = self._nextLink!;
      }
    }
  }
  
static dynamic _filter(DoubleLinkedQueue self, Function test, bool removeMatching  ) {
    {
      _DoubleLinkedQueueEntry entry = self._nextLink!;
while (true)       {
        _DoubleLinkedQueueElement elementEntry = _asNonSentinelEntry(self, );
if (elementEntry == null)         return Void;
        bool matches = functionInvocation(self.element);
if (!identical(self, self._queue))         {
          throw ConcurrentModificationError.create(self);
        }
        _DoubleLinkedQueueEntry next = self._nextLink!;
if (identical(removeMatching, matches))         {
          _remove(self, );
          self._elementCount = subtract(self, 1);
        }
        entry = next;
      }
    }
  }
  
static dynamic removeWhere(DoubleLinkedQueue self, Function test  ) {
    {
      _filter(self, test, true);
    }
  }
  
static dynamic retainWhere(DoubleLinkedQueue self, Function test  ) {
    {
      _filter(self, test, false);
    }
  }
  
static dynamic first(DoubleLinkedQueue self  ) {
    return self.element;
  }
  
static dynamic last(DoubleLinkedQueue self  ) {
    return self.element;
  }
  
static dynamic single(DoubleLinkedQueue self  ) {
    {
if (identical(self._nextLink, self._previousLink))       {
        return self.element;
      }
      throw IterableElementError.tooMany();
    }
  }
  
static DoubleLinkedQueueEntry firstEntry(DoubleLinkedQueue self  ) {
    return _asNonSentinelEntry(self, );
  }
  
static DoubleLinkedQueueEntry lastEntry(DoubleLinkedQueue self  ) {
    return _asNonSentinelEntry(self, );
  }
  
static bool isEmpty(DoubleLinkedQueue self  ) {
    return identical(self._nextLink, self._sentinel);
  }
  
static dynamic clear(DoubleLinkedQueue self  ) {
    {
      _DoubleLinkedQueueEntry cursor = self._nextLink!;
      // TODO: 实现标签语句
while (true)       {
        _DoubleLinkedQueueElement entry = _asNonSentinelEntry(self, );
if (entry == null)         break;
        cursor = self._nextLink!;
        let_expression;
      }
      self._nextLink = self._sentinel;
      self._previousLink = self._sentinel;
      self._elementCount = 0;
    }
  }
  
static dynamic forEachEntry(DoubleLinkedQueue self, Function action  ) {
    {
      _DoubleLinkedQueueEntry cursor = self._nextLink!;
      // TODO: 实现标签语句
while (true)       {
        _DoubleLinkedQueueElement element = _asNonSentinelEntry(self, );
if (element == null)         break;
if (!identical(self._queue, self))         {
          throw ConcurrentModificationError.create(self);
        }
        cursor = self._nextLink!;
        functionInvocation(element);
if (identical(self, self._queue))         {
          cursor = self._nextLink!;
        }
      }
    }
  }
  
static _DoubleLinkedQueueIterator iterator(DoubleLinkedQueue self  ) {
    {
      return _DoubleLinkedQueueIterator.create(self);
    }
  }
  
static String toString(DoubleLinkedQueue self  ) {
    return Iterable.iterableToFullString(self, "{", "}");
  }
  
}

/// 转换后的类: ListQueue
class ListQueue extends ListIterable implements Queue {
  ListQueue();
  
static ListQueue create(int initialCapacity  ) {
    final instance = ListQueue();
    instance._head = 0;
    instance._tail = 0;
    instance._table = _List.(ListQueue._calculateCapacity(initialCapacity));
    ;
    return instance;
  }
  
static Queue cast(ListQueue self  ) {
    return Queue.castFrom(self);
  }
  
static Iterator iterator(ListQueue self  ) {
    return _ListQueueIterator.create(self);
  }
  
static dynamic forEach(ListQueue self, Function f  ) {
    {
      int modificationCount = self._modificationCount;
for (int i = self._head; !i == self._tail; i = bitwiseAnd(self, subtract(self, 1)))       {
        functionInvocation(let_expression);
        _checkModification(self, modificationCount);
      }
    }
  }
  
static bool isEmpty(ListQueue self  ) {
    return self._head == self._tail;
  }
  
static int length(ListQueue self  ) {
    return bitwiseAnd(self, subtract(self, 1));
  }
  
static dynamic first(ListQueue self  ) {
    {
if (self._head == self._tail)       throw IterableElementError.noElement();
      return let_expression;
    }
  }
  
static dynamic last(ListQueue self  ) {
    {
if (self._head == self._tail)       throw IterableElementError.noElement();
      return let_expression;
    }
  }
  
static dynamic single(ListQueue self  ) {
    {
if (self._head == self._tail)       throw IterableElementError.noElement();
if (greaterThan(self, 1))       throw IterableElementError.tooMany();
      return let_expression;
    }
  }
  
static dynamic elementAt(ListQueue self, int index  ) {
    {
      IndexError.check(index, self.length);
      return let_expression;
    }
  }
  
static List toList(ListQueue self, bool growable  ) {
    {
      int mask = subtract(self, 1);
      int length = bitwiseAnd(self, mask);
if (length == 0)       return List.empty();
      List list = List.filled(length, self.first);
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        setElement(self, i, let_expression);
      }
      return list;
    }
  }
  
static dynamic add(ListQueue self, dynamic value  ) {
    {
      _add(self, value);
    }
  }
  
static dynamic addAll(ListQueue self, Iterable elements  ) {
    {
if (elements is List)       {
        List list = elements;
        int addCount = self.length;
        int length = self.length;
if (greaterThanOrEqual(self, self.length))         {
          _preGrow(self, add(self, addCount));
          setRange(self, length, add(self, addCount), list, 0);
          self._tail = add(self, addCount);
        }
 else         {
          int endSpace = subtract(self, self._tail);
if (lessThan(self, endSpace))           {
            setRange(self, self._tail, add(self, addCount), list, 0);
            self._tail = add(self, addCount);
          }
 else           {
            int preSpace = subtract(self, endSpace);
            setRange(self, self._tail, add(self, endSpace), list, 0);
            setRange(self, 0, preSpace, list, endSpace);
            self._tail = preSpace;
          }
        }
        self._modificationCount = add(self, 1);
      }
 else       {
        {
          Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )           {
            dynamic element = self.current;
            _add(self, element);
          }
        }
      }
    }
  }
  
static bool remove(ListQueue self, Object value  ) {
    {
for (int i = self._head; !i == self._tail; i = bitwiseAnd(self, subtract(self, 1)))       {
        dynamic element = getElement(self, i);
if (element == value)         {
          _remove(self, i);
          self._modificationCount = add(self, 1);
          return true;
        }
      }
      return false;
    }
  }
  
static dynamic _filterWhere(ListQueue self, Function test, bool removeMatching  ) {
    {
      int modificationCount = self._modificationCount;
      int i = self._head;
while (!i == self._tail)       {
        dynamic element = let_expression;
        bool remove = identical(removeMatching, functionInvocation(element));
        _checkModification(self, modificationCount);
if (remove)         {
          i = _remove(self, i);
          modificationCount = self._modificationCount = add(self, 1);
        }
 else         {
          i = bitwiseAnd(self, subtract(self, 1));
        }
      }
    }
  }
  
static dynamic removeWhere(ListQueue self, Function test  ) {
    {
      _filterWhere(self, test, true);
    }
  }
  
static dynamic retainWhere(ListQueue self, Function test  ) {
    {
      _filterWhere(self, test, false);
    }
  }
  
static dynamic clear(ListQueue self  ) {
    {
if (!self._head == self._tail)       {
for (int i = self._head; !i == self._tail; i = bitwiseAnd(self, subtract(self, 1)))         {
          setElement(self, i, null);
        }
        self._head = self._tail = 0;
        self._modificationCount = add(self, 1);
      }
    }
  }
  
static String toString(ListQueue self  ) {
    return Iterable.iterableToFullString(self, "{", "}");
  }
  
static dynamic addLast(ListQueue self, dynamic value  ) {
    {
      _add(self, value);
    }
  }
  
static dynamic addFirst(ListQueue self, dynamic value  ) {
    {
      self._head = bitwiseAnd(self, subtract(self, 1));
      setElement(self, self._head, value);
if (self._head == self._tail)       _grow(self, );
      self._modificationCount = add(self, 1);
    }
  }
  
static dynamic removeFirst(ListQueue self  ) {
    {
if (self._head == self._tail)       throw IterableElementError.noElement();
      self._modificationCount = add(self, 1);
      dynamic result = let_expression;
      setElement(self, self._head, null);
      self._head = bitwiseAnd(self, subtract(self, 1));
      return result;
    }
  }
  
static dynamic removeLast(ListQueue self  ) {
    {
if (self._head == self._tail)       throw IterableElementError.noElement();
      self._modificationCount = add(self, 1);
      self._tail = bitwiseAnd(self, subtract(self, 1));
      dynamic result = let_expression;
      setElement(self, self._tail, null);
      return result;
    }
  }
  
static dynamic _checkModification(ListQueue self, int expectedModificationCount  ) {
    {
if (!expectedModificationCount == self._modificationCount)       {
        throw ConcurrentModificationError.create(self);
      }
    }
  }
  
static dynamic _add(ListQueue self, dynamic element  ) {
    {
      setElement(self, self._tail, element);
      self._tail = bitwiseAnd(self, subtract(self, 1));
if (self._head == self._tail)       _grow(self, );
      self._modificationCount = add(self, 1);
    }
  }
  
static int _remove(ListQueue self, int offset  ) {
    {
      int mask = subtract(self, 1);
      int startDistance = bitwiseAnd(self, mask);
      int endDistance = bitwiseAnd(self, mask);
if (lessThan(self, endDistance))       {
        int i = offset;
while (!i == self._head)         {
          int prevOffset = bitwiseAnd(self, mask);
          setElement(self, i, getElement(self, prevOffset));
          i = prevOffset;
        }
        setElement(self, self._head, null);
        self._head = bitwiseAnd(self, mask);
        return bitwiseAnd(self, mask);
      }
 else       {
        self._tail = bitwiseAnd(self, mask);
        int i = offset;
while (!i == self._tail)         {
          int nextOffset = bitwiseAnd(self, mask);
          setElement(self, i, getElement(self, nextOffset));
          i = nextOffset;
        }
        setElement(self, self._tail, null);
        return offset;
      }
    }
  }
  
static dynamic _grow(ListQueue self  ) {
    {
      List newTable = _List.(multiply(self, 2));
      int split = subtract(self, self._head);
      setRange(self, 0, split, self._table, self._head);
      setRange(self, split, add(self, self._head), self._table, 0);
      self._head = 0;
      self._tail = self.length;
      self._table = newTable;
    }
  }
  
static int _writeToList(ListQueue self, List target  ) {
    {
assert(greaterThanOrEqual(self, self.length)      );
if (lessThanOrEqual(self, self._tail))       {
        int length = subtract(self, self._head);
        setRange(self, 0, length, self._table, self._head);
        return length;
      }
 else       {
        int firstPartSize = subtract(self, self._head);
        setRange(self, 0, firstPartSize, self._table, self._head);
        setRange(self, firstPartSize, add(self, self._tail), self._table, 0);
        return add(self, firstPartSize);
      }
    }
  }
  
static dynamic _preGrow(ListQueue self, int newElementCount  ) {
    {
assert(greaterThanOrEqual(self, self.length)      );
      newElementCount = +(self, rightShift(self, 1));
      int newCapacity = ListQueue._nextPowerOf2(newElementCount);
      List newTable = _List.(newCapacity);
      self._tail = _writeToList(self, newTable);
      self._table = newTable;
      self._head = 0;
    }
  }
  
}

/// 转换后的类: SetBase
class SetBase implements Set {
  SetBase();
  
static SetBase create(  ) {
    final instance = SetBase();
    ;
    return instance;
  }
  
static bool isEmpty(SetBase self  ) {
    return self.length == 0;
  }
  
static bool isNotEmpty(SetBase self  ) {
    return !self.length == 0;
  }
  
static Set cast(SetBase self  ) {
    return Set.castFrom(self);
  }
  
static Iterable followedBy(SetBase self, Iterable other  ) {
    return FollowedByIterable.firstEfficient(self, other);
  }
  
static Iterable whereType(SetBase self  ) {
    return WhereTypeIterable.create(self);
  }
  
static dynamic clear(SetBase self  ) {
    {
      removeAll(self, toList(self, ));
    }
  }
  
static dynamic addAll(SetBase self, Iterable elements  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          add(self, element);
        }
      }
    }
  }
  
static dynamic removeAll(SetBase self, Iterable elements  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Object element = self.current;
          remove(self, element);
        }
      }
    }
  }
  
static dynamic retainAll(SetBase self, Iterable elements  ) {
    {
      Set toRemove = toSet(self, );
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Object o = self.current;
          {
            remove(self, o);
          }
        }
      }
      removeAll(self, toRemove);
    }
  }
  
static dynamic removeWhere(SetBase self, Function test  ) {
    {
      List toRemove = _GrowableList.(0);
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (functionInvocation(element))             add(self, element);
          }
        }
      }
      removeAll(self, toRemove);
    }
  }
  
static dynamic retainWhere(SetBase self, Function test  ) {
    {
      List toRemove = _GrowableList.(0);
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (!functionInvocation(element))             add(self, element);
          }
        }
      }
      removeAll(self, toRemove);
    }
  }
  
static bool containsAll(SetBase self, Iterable other  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Object o = self.current;
          {
if (!contains(self, o))             return false;
          }
        }
      }
      return true;
    }
  }
  
static Set union(SetBase self, Set other  ) {
    {
      return let_expression;
    }
  }
  
static Set intersection(SetBase self, Set other  ) {
    {
      Set result = toSet(self, );
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (!contains(self, element))             remove(self, element);
          }
        }
      }
      return result;
    }
  }
  
static Set difference(SetBase self, Set other  ) {
    {
      Set result = toSet(self, );
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (contains(self, element))             remove(self, element);
          }
        }
      }
      return result;
    }
  }
  
static List toList(SetBase self, bool growable  ) {
    return List.of(self);
  }
  
static Iterable map(SetBase self, Function f  ) {
    return EfficientLengthMappedIterable.create(self, f);
  }
  
static dynamic single(SetBase self  ) {
    {
if (greaterThan(self, 1))       throw IterableElementError.tooMany();
      Iterator it = self.iterator;
if (!moveNext(self))       throw IterableElementError.noElement();
      dynamic result = self.current;
      return result;
    }
  }
  
static String toString(SetBase self  ) {
    return SetBase.setToString(self);
  }
  
static Iterable where(SetBase self, Function f  ) {
    return WhereIterable.create(self, f);
  }
  
static Iterable expand(SetBase self, Function f  ) {
    return ExpandIterable.create(self, f);
  }
  
static dynamic forEach(SetBase self, Function f  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          functionInvocation(element);
        }
      }
    }
  }
  
static dynamic reduce(SetBase self, Function combine  ) {
    {
      Iterator iterator = self.iterator;
if (!moveNext(self))       {
        throw IterableElementError.noElement();
      }
      dynamic value = self.current;
while (moveNext(self))       {
        value = functionInvocation(value, self.current);
      }
      return value;
    }
  }
  
static dynamic fold(SetBase self, dynamic initialValue, Function combine  ) {
    {
      dynamic value = initialValue;
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          value = functionInvocation(value, element);
        }
      }
      return value;
    }
  }
  
static bool every(SetBase self, Function f  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (!functionInvocation(element))             return false;
          }
        }
      }
      return true;
    }
  }
  
static String join(SetBase self, String separator  ) {
    {
      Iterator iterator = self.iterator;
if (!moveNext(self))       return "";
      String first = toString(self, );
if (!moveNext(self))       return first;
      StringBuffer buffer = StringBuffer.create(first);
if (separator == null || self.isEmpty)       {
do         {
          write(self, self.current);
        }
 while (moveNext(self));      }
 else       {
do         {
          let_expression;
        }
 while (moveNext(self));      }
      return toString(self, );
    }
  }
  
static bool any(SetBase self, Function test  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (functionInvocation(element))             return true;
          }
        }
      }
      return false;
    }
  }
  
static Iterable take(SetBase self, int n  ) {
    {
      return TakeIterable.(self, n);
    }
  }
  
static Iterable takeWhile(SetBase self, Function test  ) {
    {
      return TakeWhileIterable.create(self, test);
    }
  }
  
static Iterable skip(SetBase self, int n  ) {
    {
      return SkipIterable.(self, n);
    }
  }
  
static Iterable skipWhile(SetBase self, Function test  ) {
    {
      return SkipWhileIterable.create(self, test);
    }
  }
  
static dynamic first(SetBase self  ) {
    {
      Iterator it = self.iterator;
if (!moveNext(self))       {
        throw IterableElementError.noElement();
      }
      return self.current;
    }
  }
  
static dynamic last(SetBase self  ) {
    {
      Iterator it = self.iterator;
if (!moveNext(self))       {
        throw IterableElementError.noElement();
      }
      dynamic result;
do       {
        result = self.current;
      }
 while (moveNext(self));      return result;
    }
  }
  
static dynamic firstWhere(SetBase self, Function test, Function orElse  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (functionInvocation(element))             return element;
          }
        }
      }
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic lastWhere(SetBase self, Function test, Function orElse  ) {
    {
      Iterator iterator = self.iterator;
      dynamic result;
do       {
if (!moveNext(self))         {
if (!orElse == null)           return functionInvocation();
          throw IterableElementError.noElement();
        }
        result = self.current;
      }
 while (!functionInvocation(result));while (moveNext(self))       {
        dynamic current = self.current;
if (functionInvocation(current))         result = current;
      }
      return result;
    }
  }
  
static dynamic singleWhere(SetBase self, Function test, Function orElse  ) {
    {
      Iterator iterator = self.iterator;
      dynamic result;
do       {
if (!moveNext(self))         {
if (!orElse == null)           return functionInvocation();
          throw IterableElementError.noElement();
        }
        result = self.current;
      }
 while (!functionInvocation(result));while (moveNext(self))       {
if (functionInvocation(self.current))         throw IterableElementError.tooMany();
      }
      return result;
    }
  }
  
static dynamic elementAt(SetBase self, int index  ) {
    {
      RangeError.checkNotNegative(index, "index");
      Iterator iterator = self.iterator;
      int skipCount = index;
while (moveNext(self))       {
if (skipCount == 0)         return self.current;
        skipCount = subtract(self, 1);
      }
      throw IndexError.create_withLength(index, subtract(self, skipCount));
    }
  }
  
}

/// 转换后的类: UnmodifiableSetView
class UnmodifiableSetView extends _UnmodifiableSetView_SetBase__UnmodifiableSetMixin {
  late Set _source;
  
  UnmodifiableSetView();
  
static UnmodifiableSetView create(Set source  ) {
    final instance = UnmodifiableSetView();
    instance._source = source;
    ;
    return instance;
  }
  
static bool contains(UnmodifiableSetView self, Object element  ) {
    return contains(self, element);
  }
  
static dynamic lookup(UnmodifiableSetView self, Object element  ) {
    return lookup(self, element);
  }
  
static int length(UnmodifiableSetView self  ) {
    return self.length;
  }
  
static Iterator iterator(UnmodifiableSetView self  ) {
    return self.iterator;
  }
  
static Set toSet(UnmodifiableSetView self  ) {
    return toSet(self, );
  }
  
}

/// 转换后的类: SplayTreeMap
class SplayTreeMap extends _SplayTreeMap__SplayTree_MapMixin {
  SplayTreeMap();
  
static SplayTreeMap create(Function compare, Function isValidKey  ) {
    final instance = SplayTreeMap();
    instance._compare = let_expression;
    instance._validKey = isValidKey;
    ;
    return instance;
  }
  
static dynamic remove(SplayTreeMap self, Object key  ) {
    {
      _SplayTreeMapNode root = _untypedLookup(self, key);
if (root == null)       return null;
      _removeRoot(self, );
      return self.value;
    }
  }
  
static dynamic putIfAbsent(SplayTreeMap self, dynamic key, Function ifAbsent  ) {
    {
      int comparison = _splay(self, key);
if (comparison == 0)       {
        return self.value;
      }
      int originalModificationCount = self._modificationCount;
      int originalSplayCount = self._splayCount;
      dynamic value = functionInvocation();
if (!originalModificationCount == self._modificationCount || !originalSplayCount == self._splayCount)       {
        comparison = _splay(self, key);
if (comparison == 0)         {
          self.value = value;
          return value;
        }
      }
      _addNewRoot(self, _SplayTreeMapNode.create(key, value), comparison);
      return value;
    }
  }
  
static dynamic update(SplayTreeMap self, dynamic key, Function update, Function ifAbsent  ) {
    {
      int comparison = _splay(self, key);
if (comparison == 0)       {
        int originalModificationCount = self._modificationCount;
        int originalSplayCount = self._splayCount;
        dynamic newValue = functionInvocation(self.value);
if (!originalModificationCount == self._modificationCount)         {
          throw ConcurrentModificationError.create(self);
        }
if (!originalSplayCount == self._splayCount)         {
          comparison = _splay(self, key);
if (!comparison == 0)           throw ConcurrentModificationError.create(self);
        }
        self.value = newValue;
        return newValue;
      }
if (!ifAbsent == null)       {
        int originalModificationCount = self._modificationCount;
        int originalSplayCount = self._splayCount;
        dynamic newValue = functionInvocation();
if (!originalModificationCount == self._modificationCount)         {
          throw ConcurrentModificationError.create(self);
        }
if (!originalSplayCount == self._splayCount)         {
          comparison = _splay(self, key);
if (comparison == 0)           throw ConcurrentModificationError.create(self);
        }
        _addNewRoot(self, _SplayTreeMapNode.create(key, newValue), comparison);
        return newValue;
      }
      throw ArgumentError.create_value(key, "key", "Key not in map.");
    }
  }
  
static dynamic updateAll(SplayTreeMap self, Function update  ) {
    {
      _SplayTreeMapNode root = self._root;
if (root == null)       return Void;
      _SplayTreeMapEntryIterator iterator = _SplayTreeMapEntryIterator.create(self);
while (moveNext(self))       {
        MapEntry node = self.current;
        dynamic newValue = functionInvocation(self.key, self.value);
        _replaceValue(self, newValue);
      }
    }
  }
  
static dynamic addAll(SplayTreeMap self, Map other  ) {
    {
      forEach(self, (dynamic key, dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
    }
  }
  
static bool isEmpty(SplayTreeMap self  ) {
    {
      return self._root == null;
    }
  }
  
static bool isNotEmpty(SplayTreeMap self  ) {
    return !self.isEmpty;
  }
  
static dynamic forEach(SplayTreeMap self, Function f  ) {
    {
      Iterator nodes = _SplayTreeMapEntryIterator.create(self);
while (moveNext(self))       {
        MapEntry node = self.current;
        functionInvocation(self.key, self.value);
      }
    }
  }
  
static int length(SplayTreeMap self  ) {
    {
      return self._count;
    }
  }
  
static dynamic clear(SplayTreeMap self  ) {
    {
      _clear(self, );
    }
  }
  
static bool containsKey(SplayTreeMap self, Object key  ) {
    return !_untypedLookup(self, key) == null;
  }
  
static bool containsValue(SplayTreeMap self, Object value  ) {
    {
      int initialSplayCount = self._splayCount;
      // TODO: 处理语句类型 FunctionDeclaration
      return call(self._root);
    }
  }
  
static Iterable keys(SplayTreeMap self  ) {
    return _SplayTreeKeyIterable.create(self);
  }
  
static Iterable values(SplayTreeMap self  ) {
    return _SplayTreeValueIterable.create(self);
  }
  
static Iterable entries(SplayTreeMap self  ) {
    return _SplayTreeMapEntryIterable.create(self);
  }
  
static dynamic firstKey(SplayTreeMap self  ) {
    {
      _SplayTreeMapNode root = self._root;
if (root == null)       return null;
      return self.key;
    }
  }
  
static dynamic lastKey(SplayTreeMap self  ) {
    {
      _SplayTreeMapNode root = self._root;
if (root == null)       return null;
      return self.key;
    }
  }
  
static dynamic lastKeyBefore(SplayTreeMap self, dynamic key  ) {
    {
if (key == null)       throw ArgumentError.create(key);
if (self._root == null)       return null;
      int comparison = _splay(self, key);
if (lessThan(self, 0))       return self.key;
      _SplayTreeMapNode node = self._left;
if (node == null)       return null;
      _SplayTreeMapNode nodeRight = self._right;
while (!nodeRight == null)       {
        node = nodeRight;
        nodeRight = self._right;
      }
      return self.key;
    }
  }
  
static dynamic firstKeyAfter(SplayTreeMap self, dynamic key  ) {
    {
if (key == null)       throw ArgumentError.create(key);
if (self._root == null)       return null;
      int comparison = _splay(self, key);
if (greaterThan(self, 0))       return self.key;
      _SplayTreeMapNode node = self._right;
if (node == null)       return null;
      _SplayTreeMapNode nodeLeft = self._left;
while (!nodeLeft == null)       {
        node = nodeLeft;
        nodeLeft = self._left;
      }
      return self.key;
    }
  }
  
static dynamic getElement(SplayTreeMap self, Object key  ) {
    return let_expression;
  }
  
static dynamic setElement(SplayTreeMap self, dynamic keydynamic value  ) {
    {
      int comparison = _splay(self, key);
if (comparison == 0)       {
        self.value = value;
        return Void;
      }
      _addNewRoot(self, _SplayTreeMapNode.create(key, value), comparison);
    }
  }
  
}

/// 转换后的类: SplayTreeSet
class SplayTreeSet extends _SplayTreeSet__SplayTree_Iterable_SetMixin {
  SplayTreeSet();
  
static SplayTreeSet create(Function compare, Function isValidKey  ) {
    final instance = SplayTreeSet();
    instance._compare = let_expression;
    instance._validKey = isValidKey;
    ;
    return instance;
  }
  
static Set _newSet(SplayTreeSet self  ) {
    return SplayTreeSet.create((dynamic a, dynamic b) { /* TODO: 实现匿名函数 */ return null as int; }, self._validKey);
  }
  
static Set cast(SplayTreeSet self  ) {
    return Set.castFrom(self);
  }
  
static Iterator iterator(SplayTreeSet self  ) {
    return _SplayTreeKeyIterator.create(self);
  }
  
static int length(SplayTreeSet self  ) {
    return self._count;
  }
  
static bool isEmpty(SplayTreeSet self  ) {
    return self._root == null;
  }
  
static bool isNotEmpty(SplayTreeSet self  ) {
    return !self._root == null;
  }
  
static dynamic first(SplayTreeSet self  ) {
    {
      _SplayTreeSetNode root = self._root;
if (root == null)       throw IterableElementError.noElement();
      return self.key;
    }
  }
  
static dynamic last(SplayTreeSet self  ) {
    {
      _SplayTreeSetNode root = self._root;
if (root == null)       throw IterableElementError.noElement();
      return self.key;
    }
  }
  
static dynamic single(SplayTreeSet self  ) {
    {
if (self._count == 1)       return self.key;
      throw self._count == 0 ? IterableElementError.noElement() : IterableElementError.tooMany();
    }
  }
  
static bool contains(SplayTreeSet self, Object element  ) {
    return !_untypedLookup(self, element) == null;
  }
  
static bool add(SplayTreeSet self, dynamic element  ) {
    return _add(self, element);
  }
  
static bool _add(SplayTreeSet self, dynamic element  ) {
    {
      int compare = _splay(self, element);
if (compare == 0)       return false;
      _addNewRoot(self, _SplayTreeSetNode.create(element), compare);
      return true;
    }
  }
  
static bool remove(SplayTreeSet self, Object object  ) {
    {
if (_untypedLookup(self, object) == null)       return false;
      _removeRoot(self, );
      return true;
    }
  }
  
static dynamic addAll(SplayTreeSet self, Iterable elements  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
            _add(self, element);
          }
        }
      }
    }
  }
  
static dynamic removeAll(SplayTreeSet self, Iterable elements  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Object element = self.current;
          {
if (!_untypedLookup(self, element) == null)             {
              _removeRoot(self, );
            }
          }
        }
      }
    }
  }
  
static dynamic retainAll(SplayTreeSet self, Iterable elements  ) {
    {
      SplayTreeSet retainSet = SplayTreeSet.create(self._compare, self._validKey);
      int originalModificationCount = self._modificationCount;
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Object object = self.current;
          {
if (!originalModificationCount == self._modificationCount)             {
              throw ConcurrentModificationError.create(self);
            }
            _SplayTreeSetNode root = _untypedLookup(self, object);
if (!root == null)             add(self, self.key);
          }
        }
      }
if (!self._count == self._count)       {
        self._root = self._root;
        self._count = self._count;
        self._modificationCount = add(self, 1);
      }
    }
  }
  
static dynamic lookup(SplayTreeSet self, Object object  ) {
    return let_expression;
  }
  
static Set intersection(SplayTreeSet self, Set other  ) {
    return _filter(self, other, true);
  }
  
static Set difference(SplayTreeSet self, Set other  ) {
    return _filter(self, other, false);
  }
  
static SplayTreeSet _filter(SplayTreeSet self, Set other, bool include  ) {
    {
      _SplayTreeSetNode root = null;
      int count = 0;
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (contains(self, element) == include)             {
assert(root == null || lessThanOrEqual(self, 0)              );
              root = let_expression;
              count = add(self, 1);
            }
          }
        }
      }
      return let_expression;
    }
  }
  
static Set union(SplayTreeSet self, Set other  ) {
    {
      return let_expression;
    }
  }
  
static SplayTreeSet _clone(SplayTreeSet self  ) {
    {
      SplayTreeSet set = SplayTreeSet.create(self._compare, self._validKey);
      _SplayTreeSetNode root = self._root;
if (!root == null)       {
        self._root = _copyNode(self, root);
        self._count = self._count;
      }
      return set;
    }
  }
  
static _SplayTreeSetNode _copyNode(SplayTreeSet self, dynamic source  ) {
    {
      _SplayTreeSetNode result = _SplayTreeSetNode.create(self.key);
      _SplayTreeSetNode target = result;
      // TODO: 实现标签语句
while (true)       // TODO: 实现标签语句
      {
        dynamic sourceLeft = self._left;
        dynamic sourceRight = self._right;
if (!sourceLeft == null)         {
if (!sourceRight == null)           {
            self._left = _copyNode(self, sourceLeft);
          }
 else           {
            source = sourceLeft;
            target = self._left = _SplayTreeSetNode.create(self.key);
            break;
          }
        }
 else if (sourceRight == null)         {
          break;
        }
        source = sourceRight;
        target = self._right = _SplayTreeSetNode.create(self.key);
      }
      return result;
    }
  }
  
static dynamic clear(SplayTreeSet self  ) {
    {
      _clear(self, );
    }
  }
  
static Set toSet(SplayTreeSet self  ) {
    return _clone(self, );
  }
  
static String toString(SplayTreeSet self  ) {
    return Iterable.iterableToFullString(self, "{", "}");
  }
  
}

/// 转换后的类: CompactLinkedIdentityHashMap
class CompactLinkedIdentityHashMap extends _CompactLinkedIdentityHashMap__HashFieldBase_MapMixin__HashBase__IdenticalAndIdentityHashCode__LinkedHashMapMixin implements LinkedHashMap {
  CompactLinkedIdentityHashMap();
  
static CompactLinkedIdentityHashMap create(  ) {
    final instance = CompactLinkedIdentityHashMap();
    ;
    return instance;
  }
  
static dynamic addAll(CompactLinkedIdentityHashMap self, Map other  ) {
    {
      {
        Map _0_0 = other;
        {
          CompactLinkedIdentityHashMap otherBase;
if (_0_0 is CompactLinkedIdentityHashMap)           {
            otherBase = _0_0;
            {
if (self.isEmpty && _quickCopy(self, otherBase))               return Void;
            }
          }
        }
      }
      super.addAll(other);
    }
  }
  
}

/// 转换后的类: CompactLinkedCustomHashMap
class CompactLinkedCustomHashMap extends _CompactLinkedCustomHashMap__HashFieldBase_MapMixin__HashBase__CustomEqualsAndHashCode__LinkedHashMapMixin implements LinkedHashMap {
  late Function _equality;
  late Function _hasher;
  late Function _validKey;
  
  CompactLinkedCustomHashMap();
  
static CompactLinkedCustomHashMap create(Function _equality, Function _hasher, Function validKey  ) {
    final instance = CompactLinkedCustomHashMap();
    instance._equality = _equality;
    instance._hasher = _hasher;
    instance._validKey = let_expression;
    ;
    return instance;
  }
  
static bool containsKey(CompactLinkedCustomHashMap self, Object o  ) {
    return let_expression ? super.containsKey(o) : false;
  }
  
static dynamic remove(CompactLinkedCustomHashMap self, Object o  ) {
    return let_expression ? super.remove(o) : null;
  }
  
static dynamic getElement(CompactLinkedCustomHashMap self, Object o  ) {
    return let_expression ? super.[](o) : null;
  }
  
}

/// 转换后的类: CompactLinkedIdentityHashSet
class CompactLinkedIdentityHashSet extends _CompactLinkedIdentityHashSet__HashFieldBase_SetMixin__HashBase__IdenticalAndIdentityHashCode__LinkedHashSetMixin implements LinkedHashSet {
  CompactLinkedIdentityHashSet();
  
static CompactLinkedIdentityHashSet create(  ) {
    final instance = CompactLinkedIdentityHashSet();
    ;
    return instance;
  }
  
static dynamic addAll(CompactLinkedIdentityHashSet self, Iterable other  ) {
    {
if (other is CompactLinkedIdentityHashSet)       {
if (self.isEmpty && _quickCopy(self, other))         return Void;
      }
      super.addAll(other);
    }
  }
  
static Set toSet(CompactLinkedIdentityHashSet self  ) {
    return let_expression;
  }
  
static Set cast(CompactLinkedIdentityHashSet self  ) {
    return Set.castFrom(self);
  }
  
}

/// 转换后的类: CompactLinkedCustomHashSet
class CompactLinkedCustomHashSet extends _CompactLinkedCustomHashSet__HashFieldBase_SetMixin__HashBase__CustomEqualsAndHashCode__LinkedHashSetMixin implements LinkedHashSet {
  late Function _equality;
  late Function _hasher;
  late Function _validKey;
  
  CompactLinkedCustomHashSet();
  
static CompactLinkedCustomHashSet create(Function _equality, Function _hasher, Function validKey  ) {
    final instance = CompactLinkedCustomHashSet();
    instance._equality = _equality;
    instance._hasher = _hasher;
    instance._validKey = let_expression;
    ;
    return instance;
  }
  
static bool contains(CompactLinkedCustomHashSet self, Object o  ) {
    return let_expression ? super.contains(o) : false;
  }
  
static dynamic lookup(CompactLinkedCustomHashSet self, Object o  ) {
    return let_expression ? super.lookup(o) : null;
  }
  
static bool remove(CompactLinkedCustomHashSet self, Object o  ) {
    return let_expression ? super.remove(o) : false;
  }
  
static Set cast(CompactLinkedCustomHashSet self  ) {
    return Set.castFrom(self);
  }
  
static Set toSet(CompactLinkedCustomHashSet self  ) {
    return let_expression;
  }
  
}

/// 转换后的类: Mutex
class Mutex {
  Mutex();
  
static dynamic _lock(Mutex self  ) {
    // TODO: 实现方法体
  }
  
static dynamic _unlock(Mutex self  ) {
    // TODO: 实现方法体
  }
  
}

/// 转换后的类: ConditionVariable
class ConditionVariable {
  ConditionVariable();
  
static dynamic wait(ConditionVariable self, Mutex mutex  ) {
    // TODO: 实现方法体
  }
  
static dynamic notify(ConditionVariable self  ) {
    // TODO: 实现方法体
  }
  
}

/// 转换后的类: AsciiCodec
class AsciiCodec extends Encoding {
  late bool _allowInvalid;
  
  AsciiCodec();
  
static AsciiCodec create(bool allowInvalid  ) {
    final instance = AsciiCodec();
    instance._allowInvalid = allowInvalid;
    ;
    return instance;
  }
  
static String name(AsciiCodec self  ) {
    return "us-ascii";
  }
  
static Uint8List encode(AsciiCodec self, String source  ) {
    return convert(self, source);
  }
  
static String decode(AsciiCodec self, List bytes, bool allowInvalid  ) {
    {
if (let_expression)       {
        return convert(self, bytes);
      }
 else       {
        return convert(self, bytes);
      }
    }
  }
  
static AsciiEncoder encoder(AsciiCodec self  ) {
    return const InstanceConstant(const AsciiEncoder{_UnicodeSubsetEncoder._subsetMask: 127});
  }
  
static AsciiDecoder decoder(AsciiCodec self  ) {
    return self._allowInvalid ? const InstanceConstant(const AsciiDecoder{_UnicodeSubsetDecoder._allowInvalid: true, _UnicodeSubsetDecoder._subsetMask: 127}) : const InstanceConstant(const AsciiDecoder{_UnicodeSubsetDecoder._allowInvalid: false, _UnicodeSubsetDecoder._subsetMask: 127});
  }
  
}

/// 转换后的类: AsciiEncoder
class AsciiEncoder extends _UnicodeSubsetEncoder {
  AsciiEncoder();
  
static AsciiEncoder create(  ) {
    final instance = AsciiEncoder();
    ;
    return instance;
  }
  
}

/// 转换后的类: AsciiDecoder
class AsciiDecoder extends _UnicodeSubsetDecoder {
  AsciiDecoder();
  
static AsciiDecoder create(bool allowInvalid  ) {
    final instance = AsciiDecoder();
    ;
    return instance;
  }
  
static ByteConversionSink startChunkedConversion(AsciiDecoder self, Sink sink  ) {
    {
      StringConversionSink stringSink;
if (sink is StringConversionSink)       {
        stringSink = sink;
      }
 else       {
        stringSink = _StringAdapterSink.create(sink);
      }
if (self._allowInvalid)       {
        return _ErrorHandlingAsciiDecoderSink.create(asUtf8Sink(self, false));
      }
 else       {
        return _SimpleAsciiDecoderSink.create(stringSink);
      }
    }
  }
  
}

/// 转换后的类: Base64Codec
class Base64Codec extends Codec {
  late Base64Encoder _encoder;
  
  Base64Codec();
  
static Base64Codec create(  ) {
    final instance = Base64Codec();
    instance._encoder = const InstanceConstant(const Base64Encoder{Base64Encoder._urlSafe: false});
    ;
    return instance;
  }
  
static Base64Codec create_urlSafe(  ) {
    final instance = Base64Codec();
    instance._encoder = const InstanceConstant(const Base64Encoder{Base64Encoder._urlSafe: true});
    ;
    return instance;
  }
  
static Base64Encoder encoder(Base64Codec self  ) {
    return self._encoder;
  }
  
static Base64Decoder decoder(Base64Codec self  ) {
    return const InstanceConstant(const Base64Decoder{});
  }
  
static Uint8List decode(Base64Codec self, String encoded  ) {
    return convert(self, encoded);
  }
  
static String normalize(Base64Codec self, String source, int start, int end  ) {
    {
      end = RangeError.checkValidRange(start, end, self.length);
      StringBuffer buffer;
      int sliceStart = start;
      String alphabet = const StringConstant("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");
      List inverseAlphabet = self._inverseAlphabet;
      int firstPadding = negate(self);
      int firstPaddingSourceIndex = negate(self);
      int paddingCount = 0;
for (int i = start; lessThan(self, end); )       // TODO: 实现标签语句
      {
        int sliceEnd = i;
        int char = codeUnitAt(self, let_expression);
        int originalChar = char;
if (char == const IntConstant(37))         {
if (lessThanOrEqual(self, end))           {
            char = parseHexByte(source, i);
            i = add(self, 2);
if (char == const IntConstant(37))             char = negate(self);
          }
 else           {
            char = negate(self);
          }
        }
if (lessThanOrEqual(self, char) && lessThanOrEqual(self, 127))         {
          int value = getElement(self, char);
if (greaterThanOrEqual(self, 0))           {
            char = codeUnitAt(self, value);
if (char == originalChar)             break;
          }
 else if (value == const IntConstant(-1))           {
if (lessThan(self, 0))             {
              firstPadding = +(self, subtract(self, sliceStart));
              firstPaddingSourceIndex = sliceEnd;
            }
            paddingCount = add(self, 1);
if (originalChar == const IntConstant(61))             break;
          }
if (!value == const IntConstant(-2))           {
            let_expression;
            sliceStart = i;
            break;
          }
        }
        throw FormatException.create("Invalid base64 data", source, sliceEnd);
      }
if (!buffer == null)       {
        write(self, substring(self, sliceStart, end));
if (greaterThanOrEqual(self, 0))         {
          Base64Codec._checkPadding(source, firstPaddingSourceIndex, end, firstPadding, paddingCount, self.length);
        }
 else         {
          int endLength = add(self, 1);
if (endLength == 1)           {
            throw FormatException.create("Invalid base64 encoding length ", source, end);
          }
while (lessThan(self, 4))           {
            write(self, "=");
            endLength = add(self, 1);
          }
        }
        return replaceRange(self, start, end, toString(self, ));
      }
      int length = subtract(self, start);
if (greaterThanOrEqual(self, 0))       {
        Base64Codec._checkPadding(source, firstPaddingSourceIndex, end, firstPadding, paddingCount, length);
      }
 else       {
        int endLength = modulo(self, 4);
if (endLength == 1)         {
          throw FormatException.create("Invalid base64 encoding length ", source, end);
        }
if (greaterThan(self, 1))         {
          source = replaceRange(self, end, end, endLength == 2 ? "==" : "=");
        }
      }
      return source;
    }
  }
  
}

/// 转换后的类: Base64Encoder
class Base64Encoder extends Converter {
  late bool _urlSafe;
  
  Base64Encoder();
  
static Base64Encoder create(  ) {
    final instance = Base64Encoder();
    instance._urlSafe = false;
    ;
    return instance;
  }
  
static Base64Encoder create_urlSafe(  ) {
    final instance = Base64Encoder();
    instance._urlSafe = true;
    ;
    return instance;
  }
  
static String convert(Base64Encoder self, List input  ) {
    {
if (self.isEmpty)       return "";
      _Base64Encoder encoder = _Base64Encoder.create(self._urlSafe);
      Uint8List buffer = encode(self, input, 0, self.length, true)!;
      return String.fromCharCodes(buffer);
    }
  }
  
static ByteConversionSink startChunkedConversion(Base64Encoder self, Sink sink  ) {
    {
if (sink is StringConversionSink)       {
        return _Utf8Base64EncoderSink.create(asUtf8Sink(self, false), self._urlSafe);
      }
      return _AsciiBase64EncoderSink.create(sink, self._urlSafe);
    }
  }
  
}

/// 转换后的类: Base64Decoder
class Base64Decoder extends Converter {
  Base64Decoder();
  
static Base64Decoder create(  ) {
    final instance = Base64Decoder();
    ;
    return instance;
  }
  
static Uint8List convert(Base64Decoder self, String input, int start, int end  ) {
    {
      end = RangeError.checkValidRange(start, end, self.length);
if (start == end)       return Uint8List.(0);
      _Base64Decoder decoder = _Base64Decoder.create();
      Uint8List buffer = decode(self, input, start, end)!;
      close(self, input, end);
      return buffer;
    }
  }
  
static StringConversionSink startChunkedConversion(Base64Decoder self, Sink sink  ) {
    {
      return _Base64DecoderSink.create(sink);
    }
  }
  
}

/// 转换后的类: ByteConversionSink
class ByteConversionSink implements ChunkedConversionSink {
  ByteConversionSink();
  
static ByteConversionSink create(  ) {
    final instance = ByteConversionSink();
    ;
    return instance;
  }
  
static dynamic addSlice(ByteConversionSink self, List chunk, int start, int end, bool isLast  ) {
    {
      add(self, sublist(self, start, end));
if (isLast)       close(self, );
    }
  }
  
}

/// 转换后的类: ChunkedConversionSink
class ChunkedConversionSink implements Sink {
  ChunkedConversionSink();
  
static ChunkedConversionSink create(  ) {
    final instance = ChunkedConversionSink();
    ;
    return instance;
  }
  
}

/// 转换后的类: Codec
class Codec {
  Codec();
  
static Codec create(  ) {
    final instance = Codec();
    ;
    return instance;
  }
  
static dynamic encode(Codec self, dynamic input  ) {
    return convert(self, input);
  }
  
static dynamic decode(Codec self, dynamic encoded  ) {
    return convert(self, encoded);
  }
  
static Codec fuse(Codec self, Codec other  ) {
    {
      return _FusedCodec.create(self, other);
    }
  }
  
static Codec inverted(Codec self  ) {
    return _InvertedCodec.create(self);
  }
  
}

/// 转换后的类: Converter
class Converter implements StreamTransformerBase {
  Converter();
  
static Converter create(  ) {
    final instance = Converter();
    ;
    return instance;
  }
  
static Converter fuse(Converter self, Converter other  ) {
    {
      return _FusedConverter.create(self, other);
    }
  }
  
static Sink startChunkedConversion(Converter self, Sink sink  ) {
    {
      throw UnsupportedError.create("This converter does not support chunked conversions: " + self);
    }
  }
  
static Stream bind(Converter self, Stream stream  ) {
    {
      return Stream.eventTransformed(stream, (EventSink sink) { /* TODO: 实现匿名函数 */ return null as _ConverterStreamEventSink; });
    }
  }
  
static Converter cast(Converter self  ) {
    return Converter.castFrom(self);
  }
  
}

/// 转换后的类: Encoding
class Encoding extends Codec {
  Encoding();
  
static Encoding create(  ) {
    final instance = Encoding();
    ;
    return instance;
  }
  
static Future decodeStream(Encoding self, Stream byteStream  ) {
    {
      return then(self, (StringBuffer buffer) { /* TODO: 实现匿名函数 */ return null as String; });
    }
  }
  
}

/// 转换后的类: HtmlEscapeMode
class HtmlEscapeMode {
  late String _name;
  late bool escapeLtGt;
  late bool escapeQuot;
  late bool escapeApos;
  late bool escapeSlash;
  
  HtmlEscapeMode();
  
static HtmlEscapeMode create__(String _name, bool escapeLtGt, bool escapeQuot, bool escapeApos, bool escapeSlash  ) {
    final instance = HtmlEscapeMode();
    instance._name = _name;
    instance.escapeLtGt = escapeLtGt;
    instance.escapeQuot = escapeQuot;
    instance.escapeApos = escapeApos;
    instance.escapeSlash = escapeSlash;
    ;
    return instance;
  }
  
static HtmlEscapeMode create(String name, bool escapeLtGt, bool escapeQuot, bool escapeApos, bool escapeSlash  ) {
    final instance = HtmlEscapeMode();
    instance.escapeLtGt = escapeLtGt;
    instance.escapeQuot = escapeQuot;
    instance.escapeApos = escapeApos;
    instance.escapeSlash = escapeSlash;
    instance._name = name;
    ;
    return instance;
  }
  
static String toString(HtmlEscapeMode self  ) {
    return self._name;
  }
  
}

/// 转换后的类: HtmlEscape
class HtmlEscape extends Converter {
  late HtmlEscapeMode mode;
  
  HtmlEscape();
  
static HtmlEscape create(HtmlEscapeMode mode  ) {
    final instance = HtmlEscape();
    instance.mode = mode;
    ;
    return instance;
  }
  
static String convert(HtmlEscape self, String text  ) {
    {
      String val = _convert(self, text, 0, self.length);
      return val == null ? text : val;
    }
  }
  
static String _convert(HtmlEscape self, String text, int start, int end  ) {
    {
      StringBuffer result;
for (int i = start; lessThan(self, end); i = add(self, 1))       {
        String ch = getElement(self, i);
        String replacement;
        // TODO: 实现标签语句
switch (ch) {        // TODO: 实现switch语句
        }
if (!replacement == null)         {
          result == null ? result = StringBuffer.create() : null;
if (greaterThan(self, start))           write(self, substring(self, start, i));
          write(self, replacement);
          start = add(self, 1);
        }
      }
if (result == null)       return null;
if (greaterThan(self, start))       write(self, substring(self, start, end));
      return toString(self, );
    }
  }
  
static StringConversionSink startChunkedConversion(HtmlEscape self, Sink sink  ) {
    {
      return _HtmlEscapeSink.create(self, sink is StringConversionSink ? sink : _StringAdapterSink.create(sink));
    }
  }
  
}

/// 转换后的类: JsonUnsupportedObjectError
class JsonUnsupportedObjectError extends Error {
  late Object unsupportedObject;
  late Object cause;
  late String partialResult;
  
  JsonUnsupportedObjectError();
  
static JsonUnsupportedObjectError create(Object unsupportedObject, Object cause, String partialResult  ) {
    final instance = JsonUnsupportedObjectError();
    instance.unsupportedObject = unsupportedObject;
    instance.cause = cause;
    instance.partialResult = partialResult;
    ;
    return instance;
  }
  
static String toString(JsonUnsupportedObjectError self  ) {
    {
      String safeString = Error.safeToString(self.unsupportedObject);
      String prefix;
if (!self.cause == null)       {
        prefix = "Converting object to an encodable object failed:";
      }
 else       {
        prefix = "Converting object did not return an encodable object:";
      }
      return prefix + " " + safeString;
    }
  }
  
}

/// 转换后的类: JsonCyclicError
class JsonCyclicError extends JsonUnsupportedObjectError {
  JsonCyclicError();
  
static JsonCyclicError create(Object object  ) {
    final instance = JsonCyclicError();
    ;
    return instance;
  }
  
static String toString(JsonCyclicError self  ) {
    return "Cyclic error in JSON stringify";
  }
  
}

/// 转换后的类: JsonCodec
class JsonCodec extends Codec {
  late Function _reviver;
  late Function _toEncodable;
  
  JsonCodec();
  
static JsonCodec create(Function reviver, Function toEncodable  ) {
    final instance = JsonCodec();
    instance._reviver = reviver;
    instance._toEncodable = toEncodable;
    ;
    return instance;
  }
  
static JsonCodec create_withReviver(Function reviver  ) {
    final instance = JsonCodec();
    ;
    return instance;
  }
  
static dynamic decode(JsonCodec self, String source, Function reviver  ) {
    {
      reviver == null ? reviver = self._reviver : null;
if (reviver == null)       return convert(self, source);
      return convert(self, source);
    }
  }
  
static String encode(JsonCodec self, Object value, Function toEncodable  ) {
    {
      toEncodable == null ? toEncodable = self._toEncodable : null;
if (toEncodable == null)       return convert(self, value);
      return convert(self, value);
    }
  }
  
static JsonEncoder encoder(JsonCodec self  ) {
    {
if (self._toEncodable == null)       return const InstanceConstant(const JsonEncoder{JsonEncoder.indent: null, JsonEncoder._toEncodable: null});
      return JsonEncoder.create(let_expression);
    }
  }
  
static JsonDecoder decoder(JsonCodec self  ) {
    {
if (self._reviver == null)       return const InstanceConstant(const JsonDecoder{JsonDecoder._reviver: null});
      return JsonDecoder.create(let_expression);
    }
  }
  
}

/// 转换后的类: JsonEncoder
class JsonEncoder extends Converter {
  late String indent;
  late Function _toEncodable;
  
  JsonEncoder();
  
static JsonEncoder create(Function toEncodable  ) {
    final instance = JsonEncoder();
    instance.indent = null;
    instance._toEncodable = toEncodable;
    ;
    return instance;
  }
  
static JsonEncoder create_withIndent(String indent, Function toEncodable  ) {
    final instance = JsonEncoder();
    instance.indent = indent;
    instance._toEncodable = toEncodable;
    ;
    return instance;
  }
  
static String convert(JsonEncoder self, Object object  ) {
    return _JsonStringStringifier.stringify(object, self._toEncodable, self.indent);
  }
  
static ChunkedConversionSink startChunkedConversion(JsonEncoder self, Sink sink  ) {
    {
if (sink is _Utf8EncoderSink)       {
        return _JsonUtf8EncoderSink.create(self._sink, self._toEncodable, JsonUtf8Encoder._utf8Encode(self.indent), const IntConstant(256));
      }
      return _JsonEncoderSink.create(sink is StringConversionSink ? sink : _StringAdapterSink.create(sink), self._toEncodable, self.indent);
    }
  }
  
static Stream bind(JsonEncoder self, Stream stream  ) {
    return super.bind(stream);
  }
  
static Converter fuse(JsonEncoder self, Converter other  ) {
    {
if (other is Utf8Encoder)       {
        return JsonUtf8Encoder.create(self.indent, self._toEncodable) as Converter;
      }
      return super.fuse(other);
    }
  }
  
}

/// 转换后的类: JsonUtf8Encoder
class JsonUtf8Encoder extends Converter {
  late List _indent;
  late Function _toEncodable;
  late int _bufferSize;
  
  JsonUtf8Encoder();
  
static JsonUtf8Encoder create(String indent, Function toEncodable, int bufferSize  ) {
    final instance = JsonUtf8Encoder();
    instance._indent = JsonUtf8Encoder._utf8Encode(indent);
    instance._toEncodable = toEncodable;
    instance._bufferSize = let_expression;
    ;
    return instance;
  }
  
static List convert(JsonUtf8Encoder self, Object object  ) {
    {
      List bytes = _GrowableList.(0);
      // TODO: 处理语句类型 FunctionDeclaration
      _JsonUtf8Stringifier.stringify(object, self._indent, self._toEncodable, self._bufferSize, addChunk);
if (self.length == 1)       return getElement(self, 0);
      int length = 0;
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        length = add(self, self.length);
      }
      Uint8List result = Uint8List.(length);
for (int i = 0, int offset = 0; lessThan(self, self.length); i = add(self, 1))       {
        List byteList = getElement(self, i);
        int end = add(self, self.length);
        setRange(self, offset, end, byteList);
        offset = end;
      }
      return result;
    }
  }
  
static ChunkedConversionSink startChunkedConversion(JsonUtf8Encoder self, Sink sink  ) {
    {
      ByteConversionSink byteSink;
if (sink is ByteConversionSink)       {
        byteSink = sink;
      }
 else       {
        byteSink = _ByteAdapterSink.create(sink);
      }
      return _JsonUtf8EncoderSink.create(byteSink, self._toEncodable, self._indent, self._bufferSize);
    }
  }
  
static Stream bind(JsonUtf8Encoder self, Stream stream  ) {
    {
      return super.bind(stream);
    }
  }
  
}

/// 转换后的类: JsonDecoder
class JsonDecoder extends Converter {
  late Function _reviver;
  
  JsonDecoder();
  
static JsonDecoder create(Function reviver  ) {
    final instance = JsonDecoder();
    instance._reviver = reviver;
    ;
    return instance;
  }
  
static dynamic convert(JsonDecoder self, String input  ) {
    return _parseJson(input, self._reviver);
  }
  
static StringConversionSink startChunkedConversion(JsonDecoder self, Sink sink  ) {
    {
      return _JsonStringDecoderSink.create(self._reviver, sink);
    }
  }
  
static Stream bind(JsonDecoder self, Stream stream  ) {
    return super.bind(stream);
  }
  
}

/// 转换后的类: Latin1Codec
class Latin1Codec extends Encoding {
  late bool _allowInvalid;
  
  Latin1Codec();
  
static Latin1Codec create(bool allowInvalid  ) {
    final instance = Latin1Codec();
    instance._allowInvalid = allowInvalid;
    ;
    return instance;
  }
  
static String name(Latin1Codec self  ) {
    return "iso-8859-1";
  }
  
static Uint8List encode(Latin1Codec self, String source  ) {
    return convert(self, source);
  }
  
static String decode(Latin1Codec self, List bytes, bool allowInvalid  ) {
    {
if (let_expression)       {
        return convert(self, bytes);
      }
 else       {
        return convert(self, bytes);
      }
    }
  }
  
static Latin1Encoder encoder(Latin1Codec self  ) {
    return const InstanceConstant(const Latin1Encoder{_UnicodeSubsetEncoder._subsetMask: 255});
  }
  
static Latin1Decoder decoder(Latin1Codec self  ) {
    return self._allowInvalid ? const InstanceConstant(const Latin1Decoder{_UnicodeSubsetDecoder._allowInvalid: true, _UnicodeSubsetDecoder._subsetMask: 255}) : const InstanceConstant(const Latin1Decoder{_UnicodeSubsetDecoder._allowInvalid: false, _UnicodeSubsetDecoder._subsetMask: 255});
  }
  
}

/// 转换后的类: Latin1Encoder
class Latin1Encoder extends _UnicodeSubsetEncoder {
  Latin1Encoder();
  
static Latin1Encoder create(  ) {
    final instance = Latin1Encoder();
    ;
    return instance;
  }
  
}

/// 转换后的类: Latin1Decoder
class Latin1Decoder extends _UnicodeSubsetDecoder {
  Latin1Decoder();
  
static Latin1Decoder create(bool allowInvalid  ) {
    final instance = Latin1Decoder();
    ;
    return instance;
  }
  
static ByteConversionSink startChunkedConversion(Latin1Decoder self, Sink sink  ) {
    {
      StringConversionSink stringSink;
if (sink is StringConversionSink)       {
        stringSink = sink;
      }
 else       {
        stringSink = _StringAdapterSink.create(sink);
      }
if (!self._allowInvalid)       return _Latin1DecoderSink.create(stringSink);
      return _Latin1AllowInvalidDecoderSink.create(stringSink);
    }
  }
  
}

/// 转换后的类: LineSplitter
class LineSplitter extends StreamTransformerBase {
  LineSplitter();
  
static LineSplitter create(  ) {
    final instance = LineSplitter();
    ;
    return instance;
  }
  
static List convert(LineSplitter self, String data  ) {
    {
      List lines = _GrowableList.(0);
      int end = self.length;
      int sliceStart = 0;
      int char = 0;
for (int i = 0; lessThan(self, end); i = add(self, 1))       // TODO: 实现标签语句
      {
        int previousChar = char;
        char = codeUnitAt(self, i);
if (!char == const IntConstant(13))         {
if (!char == const IntConstant(10))           break;
if (previousChar == const IntConstant(13))           {
            sliceStart = add(self, 1);
            break;
          }
        }
        add(self, substring(self, sliceStart, i));
        sliceStart = add(self, 1);
      }
if (lessThan(self, end))       {
        add(self, substring(self, sliceStart, end));
      }
      return lines;
    }
  }
  
static StringConversionSink startChunkedConversion(LineSplitter self, Sink sink  ) {
    {
      return _LineSplitterSink.create(sink is StringConversionSink ? sink : _StringAdapterSink.create(sink));
    }
  }
  
static Stream bind(LineSplitter self, Stream stream  ) {
    {
      return Stream.eventTransformed(stream, (EventSink sink) { /* TODO: 实现匿名函数 */ return null as _LineSplitterEventSink; });
    }
  }
  
}

/// 转换后的类: StringConversionSink
class StringConversionSink implements ChunkedConversionSink {
  StringConversionSink();
  
static StringConversionSink create(  ) {
    final instance = StringConversionSink();
    ;
    return instance;
  }
  
static dynamic add(StringConversionSink self, String str  ) {
    {
      addSlice(self, str, 0, self.length, false);
    }
  }
  
static ByteConversionSink asUtf8Sink(StringConversionSink self, bool allowMalformed  ) {
    {
      return _Utf8ConversionSink.create(self, allowMalformed);
    }
  }
  
static ClosableStringSink asStringSink(StringConversionSink self  ) {
    {
      return _StringConversionSinkAsStringSinkAdapter.create(self);
    }
  }
  
}

/// 转换后的类: ClosableStringSink
class ClosableStringSink implements StringSink {
  ClosableStringSink();
  
}

/// 转换后的类: Utf8Codec
class Utf8Codec extends Encoding {
  late bool _allowMalformed;
  
  Utf8Codec();
  
static Utf8Codec create(bool allowMalformed  ) {
    final instance = Utf8Codec();
    instance._allowMalformed = allowMalformed;
    ;
    return instance;
  }
  
static String name(Utf8Codec self  ) {
    return "utf-8";
  }
  
static String decode(Utf8Codec self, List codeUnits, bool allowMalformed  ) {
    {
      Utf8Decoder decoder = let_expression ? const InstanceConstant(const Utf8Decoder{Utf8Decoder._allowMalformed: true}) : const InstanceConstant(const Utf8Decoder{Utf8Decoder._allowMalformed: false});
      return convert(self, codeUnits);
    }
  }
  
static Uint8List encode(Utf8Codec self, String string  ) {
    {
      return convert(self, string);
    }
  }
  
static Utf8Encoder encoder(Utf8Codec self  ) {
    return const InstanceConstant(const Utf8Encoder{});
  }
  
static Utf8Decoder decoder(Utf8Codec self  ) {
    {
      return self._allowMalformed ? const InstanceConstant(const Utf8Decoder{Utf8Decoder._allowMalformed: true}) : const InstanceConstant(const Utf8Decoder{Utf8Decoder._allowMalformed: false});
    }
  }
  
}

/// 转换后的类: Utf8Encoder
class Utf8Encoder extends Converter {
  Utf8Encoder();
  
static Utf8Encoder create(  ) {
    final instance = Utf8Encoder();
    ;
    return instance;
  }
  
static Uint8List convert(Utf8Encoder self, String string, int start, int end  ) {
    {
      int stringLength = self.length;
      end = RangeError.checkValidRange(start, end, stringLength);
      int length = subtract(self, start);
if (length == 0)       return Uint8List.(0);
      _Utf8Encoder encoder = _Utf8Encoder.create_withBufferSize(multiply(self, 3));
      int endPosition = _fillBuffer(self, string, start, end);
assert(greaterThanOrEqual(self, subtract(self, 1))      );
if (!endPosition == end)       {
        int lastCodeUnit = codeUnitAt(self, subtract(self, 1));
assert(_isLeadSurrogate(lastCodeUnit)        );
        _writeReplacementCharacter(self, );
      }
      return sublist(self, 0, self._bufferIndex);
    }
  }
  
static StringConversionSink startChunkedConversion(Utf8Encoder self, Sink sink  ) {
    {
      return _Utf8EncoderSink.create(sink is ByteConversionSink ? sink : _ByteAdapterSink.create(sink));
    }
  }
  
static Stream bind(Utf8Encoder self, Stream stream  ) {
    return super.bind(stream);
  }
  
}

/// 转换后的类: Utf8Decoder
class Utf8Decoder extends Converter {
  late bool _allowMalformed;
  
  Utf8Decoder();
  
static Utf8Decoder create(bool allowMalformed  ) {
    final instance = Utf8Decoder();
    instance._allowMalformed = allowMalformed;
    ;
    return instance;
  }
  
static String convert(Utf8Decoder self, List codeUnits, int start, int end  ) {
    return convertSingle(self, codeUnits, start, end);
  }
  
static ByteConversionSink startChunkedConversion(Utf8Decoder self, Sink sink  ) {
    {
      StringConversionSink stringSink;
if (sink is StringConversionSink)       {
        stringSink = sink;
      }
 else       {
        stringSink = _StringAdapterSink.create(sink);
      }
      return asUtf8Sink(self, self._allowMalformed);
    }
  }
  
static Stream bind(Utf8Decoder self, Stream stream  ) {
    return super.bind(stream);
  }
  
static Converter fuse(Utf8Decoder self, Converter next  ) {
    {
if (next is JsonDecoder)       {
        return _JsonUtf8Decoder.create(self._reviver, self._allowMalformed) as dynamic as Converter;
      }
      return super.fuse(next);
    }
  }
  
}

/// 转换后的类: NativeRuntime
class NativeRuntime {
  NativeRuntime();
  
static NativeRuntime create(  ) {
    final instance = NativeRuntime();
    ;
    return instance;
  }
  
}

/// 转换后的类: ServiceExtensionResponse
class ServiceExtensionResponse {
  late String result;
  late int errorCode;
  late String errorDetail;
  
  ServiceExtensionResponse();
  
static ServiceExtensionResponse create_result(String result  ) {
    final instance = ServiceExtensionResponse();
    instance.result = result;
    instance.errorCode = null;
    instance.errorDetail = null;
    {
      checkNotNullable(result, "result");
    }
    return instance;
  }
  
static ServiceExtensionResponse create_error(int errorCode, String errorDetail  ) {
    final instance = ServiceExtensionResponse();
    instance.result = null;
    instance.errorCode = errorCode;
    instance.errorDetail = errorDetail;
    {
      ServiceExtensionResponse._validateErrorCode(errorCode);
      checkNotNullable(errorDetail, "errorDetail");
    }
    return instance;
  }
  
static bool isError(ServiceExtensionResponse self  ) {
    return !self.errorCode == null && !self.errorDetail == null;
  }
  
static String _toString(ServiceExtensionResponse self  ) {
    {
      return let_expression;
    }
  }
  
}

/// 转换后的类: UserTag
class UserTag {
  UserTag();
  
}

/// 转换后的类: ServiceProtocolInfo
class ServiceProtocolInfo {
  late int majorVersion;
  late int minorVersion;
  late Uri serverUri;
  
  ServiceProtocolInfo();
  
static ServiceProtocolInfo create(Uri serverUri  ) {
    final instance = ServiceProtocolInfo();
    instance.serverUri = serverUri;
    ;
    return instance;
  }
  
static Uri serverWebSocketUri(ServiceProtocolInfo self  ) {
    {
      Uri uri = self.serverUri;
if (!uri == null)       {
        List pathSegments = _GrowableList.(0);
if (self.isNotEmpty)         {
          addAll(self, where(self, (String s) { /* TODO: 实现匿名函数 */ return null as bool; }));
        }
        add(self, "ws");
        uri = replace(self, );
      }
      return uri;
    }
  }
  
static String toString(ServiceProtocolInfo self  ) {
    {
if (!self.serverUri == null)       {
        return "Dart VM Service Protocol v" + self.majorVersion + "." + self.minorVersion + " " + "listening on " + self.serverUri;
      }
 else       {
        return "Dart VM Service Protocol v" + self.majorVersion + "." + self.minorVersion;
      }
    }
  }
  
}

/// 转换后的类: Service
class Service {
  Service();
  
static Service create(  ) {
    final instance = Service();
    ;
    return instance;
  }
  
}

/// 转换后的类: Flow
class Flow {
  late int _type;
  late int id;
  
  Flow();
  
static Flow create__(int _type, int id  ) {
    final instance = Flow();
    instance._type = _type;
    instance.id = id;
    ;
    return instance;
  }
  
}

/// 转换后的类: Timeline
class Timeline {
  Timeline();
  
static Timeline create(  ) {
    final instance = Timeline();
    ;
    return instance;
  }
  
}

/// 转换后的类: TimelineTask
class TimelineTask {
  late TimelineTask _parent;
  late String _filterKey;
  late int _taskId;
  late List _stack;
  
  TimelineTask();
  
static TimelineTask create(TimelineTask parent, String filterKey  ) {
    final instance = TimelineTask();
    instance._parent = parent;
    instance._filterKey = filterKey;
    instance._taskId = _getNextTaskId();
    {
    }
    return instance;
  }
  
static TimelineTask create_withTaskId(int taskId, String filterKey  ) {
    final instance = TimelineTask();
    instance._parent = null;
    instance._filterKey = filterKey;
    instance._taskId = taskId;
    {
      ArgumentError.checkNotNull(taskId, "taskId");
    }
    return instance;
  }
  
static dynamic start(TimelineTask self, String name, Map arguments  ) {
    {
if (!const BoolConstant(true))       return Void;
      ArgumentError.checkNotNull(name, "name");
if (!_isDartStreamEnabled())       {
        add(self, null);
        return Void;
      }
      _AsyncBlock block = _AsyncBlock.create__(name, self._taskId);
      add(self, block);
      _start(self, (() {
    Map var = {};
    Map var = arguments;
    if (!unknown == null) addAll(self, unknown);
    if (!self._parent == null) setElement(self, "parentId", toRadixString(self, 16));
    if (!self._filterKey == null) setElement(self, const StringConstant("filterKey"), let_expression);
    return null;
  })());
    }
  }
  
static dynamic instant(TimelineTask self, String name, Map arguments  ) {
    {
if (!const BoolConstant(true))       return Void;
      ArgumentError.checkNotNull(name, "name");
if (!_isDartStreamEnabled())       {
        return Void;
      }
      Map instantArguments = (() {
    Map var = {};
    Map var = arguments;
    if (!unknown == null) addAll(self, unknown);
    if (!self._filterKey == null) setElement(self, const StringConstant("filterKey"), let_expression);
    return null;
  })();
      _reportTaskEvent(self._taskId, const IntConstant(-1), const IntConstant(6), name, _argumentsAsJson(instantArguments));
    }
  }
  
static dynamic finish(TimelineTask self, Map arguments  ) {
    {
if (!const BoolConstant(true))       {
        return Void;
      }
if (self.length == 0)       {
        throw StateError.create("Uneven calls to start and finish");
      }
if (!self._filterKey == null)       {
        arguments == null ? arguments = {} : null;
        setElement(self, const StringConstant("filterKey"), let_expression);
      }
      _AsyncBlock block = removeLast(self, );
if (block == null)       {
        return Void;
      }
      _finish(self, arguments);
    }
  }
  
static int pass(TimelineTask self  ) {
    {
if (greaterThan(self, 0))       {
        throw StateError.create(const StringConstant("You cannot pass a TimelineTask without finishing all started operations"));
      }
      int r = self._taskId;
      return r;
    }
  }
  
}

/// 转换后的类: Pointer
class Pointer implements SizedNativeType {
  Pointer();
  
static Pointer _offsetBy(Pointer self, int offsetInBytes  ) {
    return Pointer.fromAddress(add(self, offsetInBytes));
  }
  
static int address(Pointer self  ) {
    // TODO: 实现方法体
  }
  
static Pointer cast(Pointer self  ) {
    return Pointer.fromAddress(self.address);
  }
  
static int hashCode(Pointer self  ) {
    {
      return self.hashCode;
    }
  }
  
static bool equals(Pointer self, Object other  ) {
    {
if (!other is Pointer)       return false;
      Pointer otherPointer = other;
      return self.address == self.address;
    }
  }
  
}

/// 转换后的类: Array
class Array extends _Compound {
  late int _size;
  late bool _variableLength;
  late List _nestedDimensions;
  
  Array();
  
static Array create__(Object _typedDataBase, int _offsetInBytes, int _size, bool _variableLength, List _nestedDimensions  ) {
    final instance = Array();
    instance._size = _size;
    instance._variableLength = _variableLength;
    instance._nestedDimensions = _nestedDimensions;
    ;
    return instance;
  }
  
static int _nestedDimensionsFlattened(Array self  ) {
    return let_expression;
  }
  
static int _nestedDimensionsFirst(Array self  ) {
    return let_expression;
  }
  
static List _nestedDimensionsRest(Array self  ) {
    return let_expression;
  }
  
static dynamic _checkIndex(Array self, int index  ) {
    {
if (self._variableLength)       return Void;
if (lessThan(self, 0) || greaterThanOrEqual(self, self._size))       {
        throw RangeError.create_range(index, 0, subtract(self, 1));
      }
    }
  }
  
}

/// 转换后的类: NativeCallable
class NativeCallable {
  NativeCallable();
  
static bool keepIsolateAlive(NativeCallable self  ) {
    // TODO: 实现方法体
  }
  
static dynamic keepIsolateAlive(NativeCallable self, bool _externalFieldValue  ) {
    // TODO: 实现方法体
  }
  
}

/// 转换后的类: Dart_CObject
class Dart_CObject extends Opaque {
  Dart_CObject();
  
static Dart_CObject create(  ) {
    final instance = Dart_CObject();
    ;
    return instance;
  }
  
}

/// 转换后的类: NativeApi
class NativeApi {
  NativeApi();
  
static NativeApi create(  ) {
    final instance = NativeApi();
    ;
    return instance;
  }
  
}

/// 转换后的类: Native
class Native {
  late String symbol;
  late String assetId;
  late bool isLeaf;
  
  Native();
  
static Native create(String assetId, bool isLeaf, String symbol  ) {
    final instance = Native();
    instance.assetId = assetId;
    instance.isLeaf = isLeaf;
    instance.symbol = symbol;
    ;
    return instance;
  }
  
}

/// 转换后的类: DefaultAsset
class DefaultAsset {
  late String id;
  
  DefaultAsset();
  
static DefaultAsset create(String id  ) {
    final instance = DefaultAsset();
    instance.id = id;
    ;
    return instance;
  }
  
}

/// 转换后的类: Abi
class Abi {
  late _OS _os;
  late _Architecture _architecture;
  
  Abi();
  
static Abi create__(_Architecture _architecture, _OS _os  ) {
    final instance = Abi();
    instance._architecture = _architecture;
    instance._os = _os;
    ;
    return instance;
  }
  
static String toString(Abi self  ) {
    return EnumName|get#name(self._os) + "_" + EnumName|get#name(self._architecture);
  }
  
}

/// 转换后的类: AbiSpecificInteger
class AbiSpecificInteger implements SizedNativeType {
  AbiSpecificInteger();
  
static AbiSpecificInteger create(  ) {
    final instance = AbiSpecificInteger();
    ;
    return instance;
  }
  
}

/// 转换后的类: AbiSpecificIntegerMapping
class AbiSpecificIntegerMapping {
  late Map mapping;
  
  AbiSpecificIntegerMapping();
  
static AbiSpecificIntegerMapping create(Map mapping  ) {
    final instance = AbiSpecificIntegerMapping();
    instance.mapping = mapping;
    ;
    return instance;
  }
  
}

/// 转换后的类: NativeType
class NativeType {
  NativeType();
  
static NativeType create(  ) {
    final instance = NativeType();
    ;
    return instance;
  }
  
}

/// 转换后的类: SizedNativeType
class SizedNativeType implements NativeType {
  SizedNativeType();
  
static SizedNativeType create(  ) {
    final instance = SizedNativeType();
    ;
    return instance;
  }
  
}

/// 转换后的类: Opaque
class Opaque implements NativeType {
  Opaque();
  
static Opaque create(  ) {
    final instance = Opaque();
    ;
    return instance;
  }
  
}

/// 转换后的类: Int8
class Int8 implements _NativeInteger {
  Int8();
  
static Int8 create(  ) {
    final instance = Int8();
    ;
    return instance;
  }
  
}

/// 转换后的类: Int16
class Int16 implements _NativeInteger {
  Int16();
  
static Int16 create(  ) {
    final instance = Int16();
    ;
    return instance;
  }
  
}

/// 转换后的类: Int32
class Int32 implements _NativeInteger {
  Int32();
  
static Int32 create(  ) {
    final instance = Int32();
    ;
    return instance;
  }
  
}

/// 转换后的类: Int64
class Int64 implements _NativeInteger {
  Int64();
  
static Int64 create(  ) {
    final instance = Int64();
    ;
    return instance;
  }
  
}

/// 转换后的类: Uint8
class Uint8 implements _NativeInteger {
  Uint8();
  
static Uint8 create(  ) {
    final instance = Uint8();
    ;
    return instance;
  }
  
}

/// 转换后的类: Uint16
class Uint16 implements _NativeInteger {
  Uint16();
  
static Uint16 create(  ) {
    final instance = Uint16();
    ;
    return instance;
  }
  
}

/// 转换后的类: Uint32
class Uint32 implements _NativeInteger {
  Uint32();
  
static Uint32 create(  ) {
    final instance = Uint32();
    ;
    return instance;
  }
  
}

/// 转换后的类: Uint64
class Uint64 implements _NativeInteger {
  Uint64();
  
static Uint64 create(  ) {
    final instance = Uint64();
    ;
    return instance;
  }
  
}

/// 转换后的类: Float
class Float implements _NativeDouble {
  Float();
  
static Float create(  ) {
    final instance = Float();
    ;
    return instance;
  }
  
}

/// 转换后的类: Double
class Double implements _NativeDouble {
  Double();
  
static Double create(  ) {
    final instance = Double();
    ;
    return instance;
  }
  
}

/// 转换后的类: Bool
class Bool implements SizedNativeType {
  Bool();
  
static Bool create(  ) {
    final instance = Bool();
    ;
    return instance;
  }
  
}

/// 转换后的类: Void
class Void implements NativeType {
  Void();
  
static Void create(  ) {
    final instance = Void();
    ;
    return instance;
  }
  
}

/// 转换后的类: Handle
class Handle implements NativeType {
  Handle();
  
static Handle create(  ) {
    final instance = Handle();
    ;
    return instance;
  }
  
}

/// 转换后的类: NativeFunction
class NativeFunction implements NativeType {
  NativeFunction();
  
static NativeFunction create(  ) {
    final instance = NativeFunction();
    ;
    return instance;
  }
  
}

/// 转换后的类: VarArgs
class VarArgs implements NativeType {
  VarArgs();
  
static VarArgs create(  ) {
    final instance = VarArgs();
    ;
    return instance;
  }
  
}

/// 转换后的类: Finalizable
class Finalizable {
  Finalizable();
  
}

/// 转换后的类: NativeFinalizer
class NativeFinalizer {
  NativeFinalizer();
  
}

/// 转换后的类: Allocator
class Allocator {
  Allocator();
  
static Allocator create__(  ) {
    final instance = Allocator();
    {
      throw UnsupportedError.create("Cannot be instantiated");
    }
    return instance;
  }
  
}

/// 转换后的类: DartRepresentationOf
class DartRepresentationOf {
  DartRepresentationOf();
  
static DartRepresentationOf create(String nativeType  ) {
    final instance = DartRepresentationOf();
    ;
    return instance;
  }
  
}

/// 转换后的类: Char
class Char extends AbiSpecificInteger {
  Char();
  
static Char create(  ) {
    final instance = Char();
    ;
    return instance;
  }
  
}

/// 转换后的类: SignedChar
class SignedChar extends AbiSpecificInteger {
  SignedChar();
  
static SignedChar create(  ) {
    final instance = SignedChar();
    ;
    return instance;
  }
  
}

/// 转换后的类: UnsignedChar
class UnsignedChar extends AbiSpecificInteger {
  UnsignedChar();
  
static UnsignedChar create(  ) {
    final instance = UnsignedChar();
    ;
    return instance;
  }
  
}

/// 转换后的类: Short
class Short extends AbiSpecificInteger {
  Short();
  
static Short create(  ) {
    final instance = Short();
    ;
    return instance;
  }
  
}

/// 转换后的类: UnsignedShort
class UnsignedShort extends AbiSpecificInteger {
  UnsignedShort();
  
static UnsignedShort create(  ) {
    final instance = UnsignedShort();
    ;
    return instance;
  }
  
}

/// 转换后的类: Int
class Int extends AbiSpecificInteger {
  Int();
  
static Int create(  ) {
    final instance = Int();
    ;
    return instance;
  }
  
}

/// 转换后的类: UnsignedInt
class UnsignedInt extends AbiSpecificInteger {
  UnsignedInt();
  
static UnsignedInt create(  ) {
    final instance = UnsignedInt();
    ;
    return instance;
  }
  
}

/// 转换后的类: Long
class Long extends AbiSpecificInteger {
  Long();
  
static Long create(  ) {
    final instance = Long();
    ;
    return instance;
  }
  
}

/// 转换后的类: UnsignedLong
class UnsignedLong extends AbiSpecificInteger {
  UnsignedLong();
  
static UnsignedLong create(  ) {
    final instance = UnsignedLong();
    ;
    return instance;
  }
  
}

/// 转换后的类: LongLong
class LongLong extends AbiSpecificInteger {
  LongLong();
  
static LongLong create(  ) {
    final instance = LongLong();
    ;
    return instance;
  }
  
}

/// 转换后的类: UnsignedLongLong
class UnsignedLongLong extends AbiSpecificInteger {
  UnsignedLongLong();
  
static UnsignedLongLong create(  ) {
    final instance = UnsignedLongLong();
    ;
    return instance;
  }
  
}

/// 转换后的类: IntPtr
class IntPtr extends AbiSpecificInteger {
  IntPtr();
  
static IntPtr create(  ) {
    final instance = IntPtr();
    ;
    return instance;
  }
  
}

/// 转换后的类: UintPtr
class UintPtr extends AbiSpecificInteger {
  UintPtr();
  
static UintPtr create(  ) {
    final instance = UintPtr();
    ;
    return instance;
  }
  
}

/// 转换后的类: Size
class Size extends AbiSpecificInteger {
  Size();
  
static Size create(  ) {
    final instance = Size();
    ;
    return instance;
  }
  
}

/// 转换后的类: WChar
class WChar extends AbiSpecificInteger {
  WChar();
  
static WChar create(  ) {
    final instance = WChar();
    ;
    return instance;
  }
  
}

/// 转换后的类: DynamicLibrary
class DynamicLibrary {
  DynamicLibrary();
  
static int getHandle(DynamicLibrary self  ) {
    // TODO: 实现方法体
  }
  
static Pointer lookup(DynamicLibrary self, String symbolName  ) {
    // TODO: 实现方法体
  }
  
static bool providesSymbol(DynamicLibrary self, String symbolName  ) {
    // TODO: 实现方法体
  }
  
static dynamic close(DynamicLibrary self  ) {
    // TODO: 实现方法体
  }
  
static int hashCode(DynamicLibrary self  ) {
    {
      return self.hashCode;
    }
  }
  
static Pointer handle(DynamicLibrary self  ) {
    return Pointer.fromAddress(getHandle(self, ));
  }
  
static bool equals(DynamicLibrary self, Object other  ) {
    {
if (!other is DynamicLibrary)       return false;
      DynamicLibrary otherLib = other;
      return getHandle(self, ) == getHandle(self, );
    }
  }
  
}

/// 转换后的类: Struct
class Struct extends _Compound implements SizedNativeType {
  Struct();
  
static Struct create(  ) {
    final instance = Struct();
    ;
    return instance;
  }
  
static Struct create__fromTypedDataBase(Object _typedDataBase, int _offsetInBytes  ) {
    final instance = Struct();
    ;
    return instance;
  }
  
static Struct create__fromTypedData(TypedData typedData, int offset, int sizeInBytes  ) {
    final instance = Struct();
    ;
    return instance;
  }
  
}

/// 转换后的类: Packed
class Packed {
  late int memberAlignment;
  
  Packed();
  
static Packed create(int memberAlignment  ) {
    final instance = Packed();
    instance.memberAlignment = memberAlignment;
    ;
    return instance;
  }
  
}

/// 转换后的类: Union
class Union extends _Compound implements SizedNativeType {
  Union();
  
static Union create(  ) {
    final instance = Union();
    ;
    return instance;
  }
  
static Union create__fromTypedDataBase(Object _typedDataBase, int _offsetInBytes  ) {
    final instance = Union();
    ;
    return instance;
  }
  
static Union create__fromTypedData(TypedData typedData, int offset, int sizeInBytes  ) {
    final instance = Union();
    ;
    return instance;
  }
  
}

/// 转换后的类: VMLibraryHooks
class VMLibraryHooks {
  VMLibraryHooks();
  
static VMLibraryHooks create(  ) {
    final instance = VMLibraryHooks();
    ;
    return instance;
  }
  
}

/// 转换后的类: Lists
class Lists {
  Lists();
  
static Lists create(  ) {
    final instance = Lists();
    ;
    return instance;
  }
  
}

/// 转换后的类: VMInternalsForTesting
class VMInternalsForTesting {
  VMInternalsForTesting();
  
static VMInternalsForTesting create(  ) {
    final instance = VMInternalsForTesting();
    ;
    return instance;
  }
  
}

/// 转换后的类: FinalizerBase
class FinalizerBase {
  FinalizerBase();
  
static FinalizerBase create(  ) {
    final instance = FinalizerBase();
    ;
    return instance;
  }
  
static dynamic _isolateRegisterFinalizer(FinalizerBase self  ) {
    {
      FinalizerBase._isolateFinalizersEnsureCapacity();
      add(self, _WeakReference.create(self));
    }
  }
  
static dynamic _setIsolate(FinalizerBase self  ) {
    // TODO: 实现方法体
  }
  
static Set _allEntries(FinalizerBase self  ) {
    // TODO: 实现方法体
  }
  
static dynamic _allEntries(FinalizerBase self, Set entries  ) {
    // TODO: 实现方法体
  }
  
static FinalizerEntry _exchangeEntriesCollectedWithNull(FinalizerBase self  ) {
    // TODO: 实现方法体
  }
  
static Expando _detachments(FinalizerBase self  ) {
    // TODO: 实现方法体
  }
  
static dynamic _detachments(FinalizerBase self, Expando value  ) {
    // TODO: 实现方法体
  }
  
static dynamic detach(FinalizerBase self, Object detach  ) {
    {
      Set entries = getElement(self, detach);
if (!entries == null)       {
        {
          Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )           {
            FinalizerEntry entry = self.current;
            {
              self.token = entry;
              remove(self, entry);
            }
          }
        }
        setElement(self, detach, null);
      }
    }
  }
  
}

/// 转换后的类: FinalizerEntry
class FinalizerEntry {
  FinalizerEntry();
  
static FinalizerEntry create(  ) {
    final instance = FinalizerEntry();
    ;
    return instance;
  }
  
static Object value(FinalizerEntry self  ) {
    // TODO: 实现方法体
  }
  
static Object detach(FinalizerEntry self  ) {
    // TODO: 实现方法体
  }
  
static Object token(FinalizerEntry self  ) {
    // TODO: 实现方法体
  }
  
static dynamic token(FinalizerEntry self, Object value  ) {
    // TODO: 实现方法体
  }
  
static FinalizerEntry next(FinalizerEntry self  ) {
    // TODO: 实现方法体
  }
  
static int externalSize(FinalizerEntry self  ) {
    // TODO: 实现方法体
  }
  
static dynamic setExternalSize(FinalizerEntry self, int externalSize  ) {
    return FinalizerEntry._setExternalSize$Method$FfiNative(self, externalSize);
  }
  
}

/// 转换后的类: ClassID
class ClassID {
  ClassID();
  
static ClassID create(  ) {
    final instance = ClassID();
    ;
    return instance;
  }
  
}

/// 转换后的类: CodeUnits
class CodeUnits extends UnmodifiableListBase {
  late String _string;
  
  CodeUnits();
  
static CodeUnits create(String _string  ) {
    final instance = CodeUnits();
    instance._string = _string;
    ;
    return instance;
  }
  
static int length(CodeUnits self  ) {
    return self.length;
  }
  
static int getElement(CodeUnits self, int i  ) {
    return codeUnitAt(self, i);
  }
  
}

/// 转换后的类: ExternalName
class ExternalName {
  late String name;
  
  ExternalName();
  
static ExternalName create(String name  ) {
    final instance = ExternalName();
    instance.name = name;
    ;
    return instance;
  }
  
}

/// 转换后的类: SystemHash
class SystemHash {
  SystemHash();
  
static SystemHash create(  ) {
    final instance = SystemHash();
    ;
    return instance;
  }
  
}

/// 转换后的类: SentinelValue
class SentinelValue {
  late int id;
  
  SentinelValue();
  
static SentinelValue create(int id  ) {
    final instance = SentinelValue();
    instance.id = id;
    ;
    return instance;
  }
  
}

/// 转换后的类: Since
class Since {
  late String version;
  
  Since();
  
static Since create(String version  ) {
    final instance = Since();
    instance.version = version;
    ;
    return instance;
  }
  
}

/// 转换后的类: NotNullableError
class NotNullableError extends Error implements TypeError {
  late String _name;
  
  NotNullableError();
  
static NotNullableError create(String _name  ) {
    final instance = NotNullableError();
    instance._name = _name;
    ;
    return instance;
  }
  
static String toString(NotNullableError self  ) {
    return "Null is not a valid value for '" + self._name + "' of type '" + dynamic + "'";
  }
  
}

/// 转换后的类: HttpStatus
class HttpStatus {
  HttpStatus();
  
static HttpStatus create(  ) {
    final instance = HttpStatus();
    ;
    return instance;
  }
  
}

/// 转换后的类: DoubleLinkedQueueEntry
class DoubleLinkedQueueEntry {
  DoubleLinkedQueueEntry();
  
static DoubleLinkedQueueEntry create(dynamic element  ) {
    final instance = DoubleLinkedQueueEntry();
    instance.element = element;
    ;
    return instance;
  }
  
static dynamic _link(DoubleLinkedQueueEntry self, DoubleLinkedQueueEntry previous, DoubleLinkedQueueEntry next  ) {
    {
      self._nextLink = next;
      self._previousLink = previous;
      let_expression;
      let_expression;
    }
  }
  
static dynamic append(DoubleLinkedQueueEntry self, dynamic e  ) {
    {
      _link(self, self, self._nextLink);
    }
  }
  
static dynamic prepend(DoubleLinkedQueueEntry self, dynamic e  ) {
    {
      _link(self, self._previousLink, self);
    }
  }
  
static dynamic remove(DoubleLinkedQueueEntry self  ) {
    {
      let_expression;
      let_expression;
      self._nextLink = null;
      self._previousLink = null;
      return self.element;
    }
  }
  
static DoubleLinkedQueueEntry previousEntry(DoubleLinkedQueueEntry self  ) {
    return self._previousLink;
  }
  
static DoubleLinkedQueueEntry nextEntry(DoubleLinkedQueueEntry self  ) {
    return self._nextLink;
  }
  
}

/// 转换后的类: TypeTest
class TypeTest {
  TypeTest();
  
static TypeTest create(  ) {
    final instance = TypeTest();
    ;
    return instance;
  }
  
static bool test(TypeTest self, Object v  ) {
    return v is dynamic;
  }
  
}

/// 转换后的类: CastStream
class CastStream extends Stream {
  late Stream _source;
  
  CastStream();
  
static CastStream create(Stream _source  ) {
    final instance = CastStream();
    instance._source = _source;
    ;
    return instance;
  }
  
static bool isBroadcast(CastStream self  ) {
    return self.isBroadcast;
  }
  
static StreamSubscription listen(CastStream self, Function onData, Function onError, Function onDone, bool cancelOnError  ) {
    {
      return let_expression;
    }
  }
  
static Stream cast(CastStream self  ) {
    return CastStream.create(self._source);
  }
  
}

/// 转换后的类: CastStreamSubscription
class CastStreamSubscription implements StreamSubscription {
  late StreamSubscription _source;
  late Zone _zone;
  
  CastStreamSubscription();
  
static CastStreamSubscription create(StreamSubscription _source  ) {
    final instance = CastStreamSubscription();
    instance._source = _source;
    {
      onData(self, instance_tearoff);
    }
    return instance;
  }
  
static Future cancel(CastStreamSubscription self  ) {
    return cancel(self, );
  }
  
static dynamic onData(CastStreamSubscription self, Function handleData  ) {
    {
      self._handleData = handleData == null ? null : registerUnaryCallback(self, handleData);
    }
  }
  
static dynamic onError(CastStreamSubscription self, Function handleError  ) {
    {
      onError(self, handleError);
if (handleError == null)       {
        self._handleError = null;
      }
 else if (handleError is Function)       {
        self._handleError = registerBinaryCallback(self, handleError);
      }
 else if (handleError is Function)       {
        self._handleError = registerUnaryCallback(self, handleError);
      }
 else       {
        throw ArgumentError.create(const StringConstant("handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace."));
      }
    }
  }
  
static dynamic onDone(CastStreamSubscription self, Function handleDone  ) {
    {
      onDone(self, handleDone);
    }
  }
  
static dynamic _onData(CastStreamSubscription self, dynamic data  ) {
    {
if (self._handleData == null)       return Void;
      dynamic targetData;
try       {
        targetData = data as dynamic;
      }
      // TODO: 实现try-catch语句
      runUnaryGuarded(self, self._handleData!, targetData);
    }
  }
  
static dynamic pause(CastStreamSubscription self, Future resumeSignal  ) {
    {
      pause(self, resumeSignal);
    }
  }
  
static dynamic resume(CastStreamSubscription self  ) {
    {
      resume(self, );
    }
  }
  
static bool isPaused(CastStreamSubscription self  ) {
    return self.isPaused;
  }
  
static Future asFuture(CastStreamSubscription self, dynamic futureValue  ) {
    return asFuture(self, futureValue);
  }
  
}

/// 转换后的类: CastStreamTransformer
class CastStreamTransformer extends StreamTransformerBase {
  late StreamTransformer _source;
  
  CastStreamTransformer();
  
static CastStreamTransformer create(StreamTransformer _source  ) {
    final instance = CastStreamTransformer();
    instance._source = _source;
    ;
    return instance;
  }
  
static StreamTransformer cast(CastStreamTransformer self  ) {
    return CastStreamTransformer.create(self._source);
  }
  
static Stream bind(CastStreamTransformer self, Stream stream  ) {
    return cast(self, );
  }
  
}

/// 转换后的类: CastConverter
class CastConverter extends Converter {
  late Converter _source;
  
  CastConverter();
  
static CastConverter create(Converter _source  ) {
    final instance = CastConverter();
    instance._source = _source;
    ;
    return instance;
  }
  
static dynamic convert(CastConverter self, dynamic input  ) {
    return convert(self, input as dynamic) as dynamic;
  }
  
static Stream bind(CastConverter self, Stream stream  ) {
    return cast(self, );
  }
  
static Converter cast(CastConverter self  ) {
    return CastConverter.create(self._source);
  }
  
}

/// 转换后的类: BytesBuilder
class BytesBuilder {
  BytesBuilder();
  
}

/// 转换后的类: CastIterator
class CastIterator implements Iterator {
  CastIterator();
  
static CastIterator create(Iterator _source  ) {
    final instance = CastIterator();
    instance._source = _source;
    ;
    return instance;
  }
  
static bool moveNext(CastIterator self  ) {
    return moveNext(self);
  }
  
static dynamic current(CastIterator self  ) {
    return self.current as dynamic;
  }
  
}

/// 转换后的类: CastIterable
class CastIterable extends _CastIterableBase {
  late Iterable _source;
  
  CastIterable();
  
static CastIterable create__(Iterable _source  ) {
    final instance = CastIterable();
    instance._source = _source;
    ;
    return instance;
  }
  
static Iterable cast(CastIterable self  ) {
    return CastIterable.(self._source);
  }
  
}

/// 转换后的类: CastList
class CastList extends _CastListBase {
  late List _source;
  
  CastList();
  
static CastList create(List _source  ) {
    final instance = CastList();
    instance._source = _source;
    ;
    return instance;
  }
  
static List cast(CastList self  ) {
    return CastList.create(self._source);
  }
  
}

/// 转换后的类: CastSet
class CastSet extends _CastIterableBase implements Set {
  late Set _source;
  late Function _emptySet;
  
  CastSet();
  
static CastSet create(Set _source, Function _emptySet  ) {
    final instance = CastSet();
    instance._source = _source;
    instance._emptySet = _emptySet;
    ;
    return instance;
  }
  
static Set cast(CastSet self  ) {
    return CastSet.create(self._source, self._emptySet);
  }
  
static bool add(CastSet self, dynamic value  ) {
    return add(self, value as dynamic);
  }
  
static dynamic addAll(CastSet self, Iterable elements  ) {
    {
      addAll(self, CastIterable.(elements));
    }
  }
  
static bool remove(CastSet self, Object object  ) {
    return remove(self, object);
  }
  
static dynamic removeAll(CastSet self, Iterable objects  ) {
    {
      removeAll(self, objects);
    }
  }
  
static dynamic retainAll(CastSet self, Iterable objects  ) {
    {
      retainAll(self, objects);
    }
  }
  
static dynamic removeWhere(CastSet self, Function test  ) {
    {
      removeWhere(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as bool; });
    }
  }
  
static dynamic retainWhere(CastSet self, Function test  ) {
    {
      retainWhere(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as bool; });
    }
  }
  
static bool containsAll(CastSet self, Iterable objects  ) {
    return containsAll(self, objects);
  }
  
static Set intersection(CastSet self, Set other  ) {
    {
if (!self._emptySet == null)       return _conditionalAdd(self, other, true);
      return CastSet.create(intersection(self, other), null);
    }
  }
  
static Set difference(CastSet self, Set other  ) {
    {
if (!self._emptySet == null)       return _conditionalAdd(self, other, false);
      return CastSet.create(difference(self, other), null);
    }
  }
  
static Set _conditionalAdd(CastSet self, Set other, bool otherContains  ) {
    {
      Function emptySet = self._emptySet;
      Set result = emptySet == null ? _Set.create() : functionInvocation();
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
            dynamic castElement = element as dynamic;
if (otherContains == contains(self, castElement))             add(self, castElement);
          }
        }
      }
      return result;
    }
  }
  
static Set union(CastSet self, Set other  ) {
    return let_expression;
  }
  
static dynamic clear(CastSet self  ) {
    {
      clear(self, );
    }
  }
  
static Set _clone(CastSet self  ) {
    {
      Function emptySet = self._emptySet;
      Set result = emptySet == null ? _Set.create() : functionInvocation();
      addAll(self, self);
      return result;
    }
  }
  
static Set toSet(CastSet self  ) {
    return _clone(self, );
  }
  
static dynamic lookup(CastSet self, Object key  ) {
    return lookup(self, key) as dynamic;
  }
  
}

/// 转换后的类: CastMap
class CastMap extends MapBase {
  late Map _source;
  
  CastMap();
  
static CastMap create(Map _source  ) {
    final instance = CastMap();
    instance._source = _source;
    ;
    return instance;
  }
  
static Map cast(CastMap self  ) {
    return CastMap.create(self._source);
  }
  
static bool containsValue(CastMap self, Object value  ) {
    return containsValue(self, value);
  }
  
static bool containsKey(CastMap self, Object key  ) {
    return containsKey(self, key);
  }
  
static dynamic putIfAbsent(CastMap self, dynamic key, Function ifAbsent  ) {
    return putIfAbsent(self, key as dynamic, () { /* TODO: 实现匿名函数 */ return null as dynamic; }) as dynamic;
  }
  
static dynamic addAll(CastMap self, Map other  ) {
    {
      addAll(self, CastMap.create(other));
    }
  }
  
static dynamic remove(CastMap self, Object key  ) {
    return remove(self, key) as dynamic;
  }
  
static dynamic clear(CastMap self  ) {
    {
      clear(self, );
    }
  }
  
static dynamic forEach(CastMap self, Function f  ) {
    {
      forEach(self, (dynamic key, dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
    }
  }
  
static Iterable keys(CastMap self  ) {
    return CastIterable.(self.keys);
  }
  
static Iterable values(CastMap self  ) {
    return CastIterable.(self.values);
  }
  
static int length(CastMap self  ) {
    return self.length;
  }
  
static bool isEmpty(CastMap self  ) {
    return self.isEmpty;
  }
  
static bool isNotEmpty(CastMap self  ) {
    return self.isNotEmpty;
  }
  
static dynamic update(CastMap self, dynamic key, Function update, Function ifAbsent  ) {
    {
      return update(self, key as dynamic, (dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; }) as dynamic;
    }
  }
  
static dynamic updateAll(CastMap self, Function update  ) {
    {
      updateAll(self, (dynamic key, dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
    }
  }
  
static Iterable entries(CastMap self  ) {
    {
      return map(self, (MapEntry e) { /* TODO: 实现匿名函数 */ return null as MapEntry; });
    }
  }
  
static dynamic addEntries(CastMap self, Iterable entries  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          MapEntry entry = self.current;
          {
            setElement(self, self.key as dynamic, self.value as dynamic);
          }
        }
      }
    }
  }
  
static dynamic removeWhere(CastMap self, Function test  ) {
    {
      removeWhere(self, (dynamic key, dynamic value) { /* TODO: 实现匿名函数 */ return null as bool; });
    }
  }
  
static dynamic getElement(CastMap self, Object key  ) {
    return getElement(self, key) as dynamic;
  }
  
static dynamic setElement(CastMap self, dynamic keydynamic value  ) {
    {
      setElement(self, key as dynamic, value as dynamic);
    }
  }
  
}

/// 转换后的类: CastQueue
class CastQueue extends _CastIterableBase implements Queue {
  late Queue _source;
  
  CastQueue();
  
static CastQueue create(Queue _source  ) {
    final instance = CastQueue();
    instance._source = _source;
    ;
    return instance;
  }
  
static Queue cast(CastQueue self  ) {
    return CastQueue.create(self._source);
  }
  
static dynamic removeFirst(CastQueue self  ) {
    return removeFirst(self, ) as dynamic;
  }
  
static dynamic removeLast(CastQueue self  ) {
    return removeLast(self, ) as dynamic;
  }
  
static dynamic add(CastQueue self, dynamic value  ) {
    {
      add(self, value as dynamic);
    }
  }
  
static dynamic addFirst(CastQueue self, dynamic value  ) {
    {
      addFirst(self, value as dynamic);
    }
  }
  
static dynamic addLast(CastQueue self, dynamic value  ) {
    {
      addLast(self, value as dynamic);
    }
  }
  
static bool remove(CastQueue self, Object other  ) {
    return remove(self, other);
  }
  
static dynamic addAll(CastQueue self, Iterable elements  ) {
    {
      addAll(self, CastIterable.(elements));
    }
  }
  
static dynamic removeWhere(CastQueue self, Function test  ) {
    {
      removeWhere(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as bool; });
    }
  }
  
static dynamic retainWhere(CastQueue self, Function test  ) {
    {
      retainWhere(self, (dynamic element) { /* TODO: 实现匿名函数 */ return null as bool; });
    }
  }
  
static dynamic clear(CastQueue self  ) {
    {
      clear(self, );
    }
  }
  
}

/// 转换后的类: LateError
class LateError extends Error {
  late String _message;
  
  LateError();
  
static LateError create(String _message  ) {
    final instance = LateError();
    instance._message = _message;
    ;
    return instance;
  }
  
static LateError create_fieldADI(String fieldName  ) {
    final instance = LateError();
    instance._message = "Field '" + fieldName + "' has been assigned during initialization.";
    ;
    return instance;
  }
  
static LateError create_localADI(String localName  ) {
    final instance = LateError();
    instance._message = "Local '" + localName + "' has been assigned during initialization.";
    ;
    return instance;
  }
  
static LateError create_fieldNI(String fieldName  ) {
    final instance = LateError();
    instance._message = "Field '" + fieldName + "' has not been initialized.";
    ;
    return instance;
  }
  
static LateError create_localNI(String localName  ) {
    final instance = LateError();
    instance._message = "Local '" + localName + "' has not been initialized.";
    ;
    return instance;
  }
  
static LateError create_fieldAI(String fieldName  ) {
    final instance = LateError();
    instance._message = "Field '" + fieldName + "' has already been initialized.";
    ;
    return instance;
  }
  
static LateError create_localAI(String localName  ) {
    final instance = LateError();
    instance._message = "Local '" + localName + "' has already been initialized.";
    ;
    return instance;
  }
  
static String toString(LateError self  ) {
    {
      String message = self._message;
      return !message == null ? "LateInitializationError: " + message : "LateInitializationError";
    }
  }
  
}

/// 转换后的类: ReachabilityError
class ReachabilityError extends Error {
  late String _message;
  
  ReachabilityError();
  
static ReachabilityError create(String _message  ) {
    final instance = ReachabilityError();
    instance._message = _message;
    ;
    return instance;
  }
  
static String toString(ReachabilityError self  ) {
    {
      String message = self._message;
      return !message == null ? "ReachabilityError: " + message : "ReachabilityError";
    }
  }
  
}

/// 转换后的类: EfficientLengthIterable
class EfficientLengthIterable extends Iterable {
  EfficientLengthIterable();
  
static EfficientLengthIterable create(  ) {
    final instance = EfficientLengthIterable();
    ;
    return instance;
  }
  
}

/// 转换后的类: HideEfficientLengthIterable
class HideEfficientLengthIterable implements Iterable {
  HideEfficientLengthIterable();
  
static HideEfficientLengthIterable create(  ) {
    final instance = HideEfficientLengthIterable();
    ;
    return instance;
  }
  
}

/// 转换后的类: ListIterable
class ListIterable extends EfficientLengthIterable implements HideEfficientLengthIterable {
  ListIterable();
  
static ListIterable create(  ) {
    final instance = ListIterable();
    ;
    return instance;
  }
  
static Iterator iterator(ListIterable self  ) {
    return ListIterator.create(self);
  }
  
static dynamic forEach(ListIterable self, Function action  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        functionInvocation(elementAt(self, i));
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
    }
  }
  
static bool isEmpty(ListIterable self  ) {
    return self.length == 0;
  }
  
static dynamic first(ListIterable self  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
      return elementAt(self, 0);
    }
  }
  
static dynamic last(ListIterable self  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
      return elementAt(self, subtract(self, 1));
    }
  }
  
static dynamic single(ListIterable self  ) {
    {
if (self.length == 0)       throw IterableElementError.noElement();
if (greaterThan(self, 1))       throw IterableElementError.tooMany();
      return elementAt(self, 0);
    }
  }
  
static bool contains(ListIterable self, Object element  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
if (elementAt(self, i) == element)         return true;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return false;
    }
  }
  
static bool every(ListIterable self, Function test  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
if (!functionInvocation(elementAt(self, i)))         return false;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return true;
    }
  }
  
static bool any(ListIterable self, Function test  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
if (functionInvocation(elementAt(self, i)))         return true;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return false;
    }
  }
  
static dynamic firstWhere(ListIterable self, Function test, Function orElse  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        dynamic element = elementAt(self, i);
if (functionInvocation(element))         return element;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic lastWhere(ListIterable self, Function test, Function orElse  ) {
    {
      int length = self.length;
for (int i = subtract(self, 1); greaterThanOrEqual(self, 0); i = subtract(self, 1))       {
        dynamic element = elementAt(self, i);
if (functionInvocation(element))         return element;
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic singleWhere(ListIterable self, Function test, Function orElse  ) {
    {
      int length = self.length;
      dynamic match;
      bool matchFound = false;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        dynamic element = elementAt(self, i);
if (functionInvocation(element))         {
if (matchFound)           {
            throw IterableElementError.tooMany();
          }
          matchFound = true;
          match = element;
        }
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
if (matchFound)       return match;
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static String join(ListIterable self, String separator  ) {
    {
      int length = self.length;
if (!self.isEmpty)       {
if (length == 0)         return "";
        String first = elementAt(self, 0);
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
        StringBuffer buffer = StringBuffer.create(first);
for (int i = 1; lessThan(self, length); i = add(self, 1))         {
          write(self, separator);
          write(self, elementAt(self, i));
if (!length == self.length)           {
            throw ConcurrentModificationError.create(self);
          }
        }
        return toString(self, );
      }
 else       {
        StringBuffer buffer = StringBuffer.create();
for (int i = 0; lessThan(self, length); i = add(self, 1))         {
          write(self, elementAt(self, i));
if (!length == self.length)           {
            throw ConcurrentModificationError.create(self);
          }
        }
        return toString(self, );
      }
    }
  }
  
static Iterable where(ListIterable self, Function test  ) {
    return super.where(test);
  }
  
static Iterable map(ListIterable self, Function toElement  ) {
    return MappedListIterable.create(self, toElement);
  }
  
static dynamic reduce(ListIterable self, Function combine  ) {
    {
      int length = self.length;
if (length == 0)       throw IterableElementError.noElement();
      dynamic value = elementAt(self, 0);
for (int i = 1; lessThan(self, length); i = add(self, 1))       {
        value = functionInvocation(value, elementAt(self, i));
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return value;
    }
  }
  
static dynamic fold(ListIterable self, dynamic initialValue, Function combine  ) {
    {
      dynamic value = initialValue;
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        value = functionInvocation(value, elementAt(self, i));
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self);
        }
      }
      return value;
    }
  }
  
static Iterable skip(ListIterable self, int count  ) {
    return SubListIterable.create(self, count, null);
  }
  
static Iterable skipWhile(ListIterable self, Function test  ) {
    return super.skipWhile(test);
  }
  
static Iterable take(ListIterable self, int count  ) {
    return SubListIterable.create(self, 0, checkNotNullable(count, "count"));
  }
  
static Iterable takeWhile(ListIterable self, Function test  ) {
    return super.takeWhile(test);
  }
  
static List toList(ListIterable self, bool growable  ) {
    return List.of(self);
  }
  
static Set toSet(ListIterable self  ) {
    {
      Set result = _Set.create();
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        add(self, elementAt(self, i));
      }
      return result;
    }
  }
  
}

/// 转换后的类: SubListIterable
class SubListIterable extends ListIterable {
  late Iterable _iterable;
  late int _start;
  late int _endOrLength;
  
  SubListIterable();
  
static SubListIterable create(Iterable _iterable, int _start, int _endOrLength  ) {
    final instance = SubListIterable();
    instance._iterable = _iterable;
    instance._start = _start;
    instance._endOrLength = _endOrLength;
    {
      RangeError.checkNotNegative(self._start, "start");
      int endOrLength = self._endOrLength;
if (!endOrLength == null)       {
        RangeError.checkNotNegative(endOrLength, "end");
if (greaterThan(self, endOrLength))         {
          throw RangeError.create_range(self._start, 0, endOrLength, "start");
        }
      }
    }
    return instance;
  }
  
static int _endIndex(SubListIterable self  ) {
    {
      int length = self.length;
      int endOrLength = self._endOrLength;
if (endOrLength == null || greaterThan(self, length))       return length;
      return endOrLength;
    }
  }
  
static int _startIndex(SubListIterable self  ) {
    {
      int length = self.length;
if (greaterThan(self, length))       return length;
      return self._start;
    }
  }
  
static int length(SubListIterable self  ) {
    {
      int length = self.length;
if (greaterThanOrEqual(self, length))       return 0;
      int endOrLength = self._endOrLength;
if (endOrLength == null || greaterThanOrEqual(self, length))       {
        return subtract(self, self._start);
      }
      return subtract(self, self._start);
    }
  }
  
static dynamic elementAt(SubListIterable self, int index  ) {
    {
      int realIndex = add(self, index);
if (lessThan(self, 0) || greaterThanOrEqual(self, self._endIndex))       {
        throw IndexError.create_withLength(index, self.length);
      }
      return elementAt(self, realIndex);
    }
  }
  
static Iterable skip(SubListIterable self, int count  ) {
    {
      RangeError.checkNotNegative(count, "count");
      int newStart = add(self, count);
      int endOrLength = self._endOrLength;
if (!endOrLength == null && greaterThanOrEqual(self, endOrLength))       {
        return EmptyIterable.create();
      }
      return SubListIterable.create(self._iterable, newStart, self._endOrLength);
    }
  }
  
static Iterable take(SubListIterable self, int count  ) {
    {
      RangeError.checkNotNegative(count, "count");
      int endOrLength = self._endOrLength;
if (endOrLength == null)       {
        return SubListIterable.create(self._iterable, self._start, add(self, count));
      }
 else       {
        int newEnd = add(self, count);
if (lessThan(self, newEnd))         return self;
        return SubListIterable.create(self._iterable, self._start, newEnd);
      }
    }
  }
  
static List toList(SubListIterable self, bool growable  ) {
    {
      int start = self._start;
      int end = self.length;
      int endOrLength = self._endOrLength;
if (!endOrLength == null && lessThan(self, end))       end = endOrLength;
      int length = subtract(self, start);
if (lessThanOrEqual(self, 0))       return List.empty();
      List result = List.filled(length, elementAt(self, start));
for (int i = 1; lessThan(self, length); i = add(self, 1))       {
        setElement(self, i, elementAt(self, add(self, i)));
if (lessThan(self, end))         throw ConcurrentModificationError.create(self);
      }
      return result;
    }
  }
  
}

/// 转换后的类: ListIterator
class ListIterator implements Iterator {
  late Iterable _iterable;
  late int _length;
  
  ListIterator();
  
static ListIterator create(Iterable iterable  ) {
    final instance = ListIterator();
    instance._iterable = iterable;
    instance._length = self.length;
    instance._index = 0;
    ;
    return instance;
  }
  
static dynamic current(ListIterator self  ) {
    return let_expression;
  }
  
static bool moveNext(ListIterator self  ) {
    {
      int length = self.length;
if (!self._length == length)       {
        throw ConcurrentModificationError.create(self._iterable);
      }
if (greaterThanOrEqual(self, length))       {
        self._current = null;
        return false;
      }
      self._current = elementAt(self, self._index);
      self._index = add(self, 1);
      return true;
    }
  }
  
}

/// 转换后的类: MappedIterable
class MappedIterable extends Iterable {
  late Iterable _iterable;
  late Function _f;
  
  MappedIterable();
  
static MappedIterable create__(Iterable _iterable, Function _f  ) {
    final instance = MappedIterable();
    instance._iterable = _iterable;
    instance._f = _f;
    ;
    return instance;
  }
  
static Iterator iterator(MappedIterable self  ) {
    return MappedIterator.create(self.iterator, self._f);
  }
  
static int length(MappedIterable self  ) {
    return self.length;
  }
  
static bool isEmpty(MappedIterable self  ) {
    return self.isEmpty;
  }
  
static dynamic first(MappedIterable self  ) {
    return let_expression;
  }
  
static dynamic last(MappedIterable self  ) {
    return let_expression;
  }
  
static dynamic single(MappedIterable self  ) {
    return let_expression;
  }
  
static dynamic elementAt(MappedIterable self, int index  ) {
    return let_expression;
  }
  
}

/// 转换后的类: EfficientLengthMappedIterable
class EfficientLengthMappedIterable extends MappedIterable implements EfficientLengthIterable, HideEfficientLengthIterable {
  EfficientLengthMappedIterable();
  
static EfficientLengthMappedIterable create(Iterable iterable, Function function  ) {
    final instance = EfficientLengthMappedIterable();
    ;
    return instance;
  }
  
}

/// 转换后的类: MappedIterator
class MappedIterator implements Iterator {
  late Iterator _iterator;
  late Function _f;
  
  MappedIterator();
  
static MappedIterator create(Iterator _iterator, Function _f  ) {
    final instance = MappedIterator();
    instance._iterator = _iterator;
    instance._f = _f;
    ;
    return instance;
  }
  
static bool moveNext(MappedIterator self  ) {
    {
if (moveNext(self))       {
        self._current = let_expression;
        return true;
      }
      self._current = null;
      return false;
    }
  }
  
static dynamic current(MappedIterator self  ) {
    return let_expression;
  }
  
}

/// 转换后的类: MappedListIterable
class MappedListIterable extends ListIterable {
  late Iterable _source;
  late Function _f;
  
  MappedListIterable();
  
static MappedListIterable create(Iterable _source, Function _f  ) {
    final instance = MappedListIterable();
    instance._source = _source;
    instance._f = _f;
    ;
    return instance;
  }
  
static int length(MappedListIterable self  ) {
    return self.length;
  }
  
static dynamic elementAt(MappedListIterable self, int index  ) {
    return let_expression;
  }
  
}

/// 转换后的类: WhereIterable
class WhereIterable extends Iterable {
  late Iterable _iterable;
  late Function _f;
  
  WhereIterable();
  
static WhereIterable create(Iterable _iterable, Function _f  ) {
    final instance = WhereIterable();
    instance._iterable = _iterable;
    instance._f = _f;
    ;
    return instance;
  }
  
static Iterator iterator(WhereIterable self  ) {
    return WhereIterator.create(self.iterator, self._f);
  }
  
static Iterable map(WhereIterable self, Function toElement  ) {
    return MappedIterable.create__(self, toElement);
  }
  
}

/// 转换后的类: WhereIterator
class WhereIterator implements Iterator {
  late Iterator _iterator;
  late Function _f;
  
  WhereIterator();
  
static WhereIterator create(Iterator _iterator, Function _f  ) {
    final instance = WhereIterator();
    instance._iterator = _iterator;
    instance._f = _f;
    ;
    return instance;
  }
  
static bool moveNext(WhereIterator self  ) {
    {
while (moveNext(self))       {
if (let_expression)         {
          return true;
        }
      }
      return false;
    }
  }
  
static dynamic current(WhereIterator self  ) {
    return self.current;
  }
  
}

/// 转换后的类: ExpandIterable
class ExpandIterable extends Iterable {
  late Iterable _iterable;
  late Function _f;
  
  ExpandIterable();
  
static ExpandIterable create(Iterable _iterable, Function _f  ) {
    final instance = ExpandIterable();
    instance._iterable = _iterable;
    instance._f = _f;
    ;
    return instance;
  }
  
static Iterator iterator(ExpandIterable self  ) {
    return ExpandIterator.create(self.iterator, self._f);
  }
  
}

/// 转换后的类: ExpandIterator
class ExpandIterator implements Iterator {
  late Iterator _iterator;
  late Function _f;
  
  ExpandIterator();
  
static ExpandIterator create(Iterator _iterator, Function _f  ) {
    final instance = ExpandIterator();
    instance._iterator = _iterator;
    instance._f = _f;
    ;
    return instance;
  }
  
static dynamic current(ExpandIterator self  ) {
    return let_expression;
  }
  
static bool moveNext(ExpandIterator self  ) {
    {
if (self._currentExpansion == null)       return false;
while (!moveNext(self))       {
        self._current = null;
if (moveNext(self))         {
          self._currentExpansion = null;
          self._currentExpansion = self.iterator;
        }
 else         {
          return false;
        }
      }
      self._current = self.current;
      return true;
    }
  }
  
}

/// 转换后的类: TakeIterable
class TakeIterable extends Iterable {
  late Iterable _iterable;
  late int _takeCount;
  
  TakeIterable();
  
static TakeIterable create__(Iterable _iterable, int _takeCount  ) {
    final instance = TakeIterable();
    instance._iterable = _iterable;
    instance._takeCount = _takeCount;
    ;
    return instance;
  }
  
static Iterator iterator(TakeIterable self  ) {
    {
      return TakeIterator.create(self.iterator, self._takeCount);
    }
  }
  
}

/// 转换后的类: EfficientLengthTakeIterable
class EfficientLengthTakeIterable extends TakeIterable implements EfficientLengthIterable, HideEfficientLengthIterable {
  EfficientLengthTakeIterable();
  
static EfficientLengthTakeIterable create(Iterable iterable, int takeCount  ) {
    final instance = EfficientLengthTakeIterable();
    ;
    return instance;
  }
  
static int length(EfficientLengthTakeIterable self  ) {
    {
      int iterableLength = self.length;
if (greaterThan(self, self._takeCount))       return self._takeCount;
      return iterableLength;
    }
  }
  
}

/// 转换后的类: TakeIterator
class TakeIterator implements Iterator {
  late Iterator _iterator;
  
  TakeIterator();
  
static TakeIterator create(Iterator _iterator, int _remaining  ) {
    final instance = TakeIterator();
    instance._iterator = _iterator;
    instance._remaining = _remaining;
    {
assert(greaterThanOrEqual(self, 0)      );
    }
    return instance;
  }
  
static bool moveNext(TakeIterator self  ) {
    {
      self._remaining = subtract(self, 1);
if (greaterThanOrEqual(self, 0))       {
        return moveNext(self);
      }
      self._remaining = negate(self);
      return false;
    }
  }
  
static dynamic current(TakeIterator self  ) {
    {
if (lessThan(self, 0))       return let_expression;
      return self.current;
    }
  }
  
}

/// 转换后的类: TakeWhileIterable
class TakeWhileIterable extends Iterable {
  late Iterable _iterable;
  late Function _f;
  
  TakeWhileIterable();
  
static TakeWhileIterable create(Iterable _iterable, Function _f  ) {
    final instance = TakeWhileIterable();
    instance._iterable = _iterable;
    instance._f = _f;
    ;
    return instance;
  }
  
static Iterator iterator(TakeWhileIterable self  ) {
    {
      return TakeWhileIterator.create(self.iterator, self._f);
    }
  }
  
}

/// 转换后的类: TakeWhileIterator
class TakeWhileIterator implements Iterator {
  late Iterator _iterator;
  late Function _f;
  
  TakeWhileIterator();
  
static TakeWhileIterator create(Iterator _iterator, Function _f  ) {
    final instance = TakeWhileIterator();
    instance._iterator = _iterator;
    instance._f = _f;
    ;
    return instance;
  }
  
static bool moveNext(TakeWhileIterator self  ) {
    {
if (self._isFinished)       return false;
if (!moveNext(self) || !let_expression)       {
        self._isFinished = true;
        return false;
      }
      return true;
    }
  }
  
static dynamic current(TakeWhileIterator self  ) {
    {
if (self._isFinished)       return let_expression;
      return self.current;
    }
  }
  
}

/// 转换后的类: SkipIterable
class SkipIterable extends Iterable {
  late Iterable _iterable;
  late int _skipCount;
  
  SkipIterable();
  
static SkipIterable create__(Iterable _iterable, int _skipCount  ) {
    final instance = SkipIterable();
    instance._iterable = _iterable;
    instance._skipCount = _skipCount;
    ;
    return instance;
  }
  
static Iterable skip(SkipIterable self, int count  ) {
    {
      return SkipIterable.create__(self._iterable, add(self, _checkCount(count)));
    }
  }
  
static Iterator iterator(SkipIterable self  ) {
    {
      return SkipIterator.create(self.iterator, self._skipCount);
    }
  }
  
}

/// 转换后的类: EfficientLengthSkipIterable
class EfficientLengthSkipIterable extends SkipIterable implements EfficientLengthIterable, HideEfficientLengthIterable {
  EfficientLengthSkipIterable();
  
static EfficientLengthSkipIterable create__(Iterable iterable, int count  ) {
    final instance = EfficientLengthSkipIterable();
    ;
    return instance;
  }
  
static int length(EfficientLengthSkipIterable self  ) {
    {
      int length = subtract(self, self._skipCount);
if (greaterThanOrEqual(self, 0))       return length;
      return 0;
    }
  }
  
static Iterable skip(EfficientLengthSkipIterable self, int count  ) {
    {
      return EfficientLengthSkipIterable.create__(self._iterable, add(self, _checkCount(count)));
    }
  }
  
}

/// 转换后的类: SkipIterator
class SkipIterator implements Iterator {
  late Iterator _iterator;
  
  SkipIterator();
  
static SkipIterator create(Iterator _iterator, int _skipCount  ) {
    final instance = SkipIterator();
    instance._iterator = _iterator;
    instance._skipCount = _skipCount;
    {
assert(greaterThanOrEqual(self, 0)      );
    }
    return instance;
  }
  
static bool moveNext(SkipIterator self  ) {
    {
for (int i = 0; lessThan(self, self._skipCount); i = add(self, 1))       moveNext(self);
      self._skipCount = 0;
      return moveNext(self);
    }
  }
  
static dynamic current(SkipIterator self  ) {
    return self.current;
  }
  
}

/// 转换后的类: SkipWhileIterable
class SkipWhileIterable extends Iterable {
  late Iterable _iterable;
  late Function _f;
  
  SkipWhileIterable();
  
static SkipWhileIterable create(Iterable _iterable, Function _f  ) {
    final instance = SkipWhileIterable();
    instance._iterable = _iterable;
    instance._f = _f;
    ;
    return instance;
  }
  
static Iterator iterator(SkipWhileIterable self  ) {
    {
      return SkipWhileIterator.create(self.iterator, self._f);
    }
  }
  
}

/// 转换后的类: SkipWhileIterator
class SkipWhileIterator implements Iterator {
  late Iterator _iterator;
  late Function _f;
  
  SkipWhileIterator();
  
static SkipWhileIterator create(Iterator _iterator, Function _f  ) {
    final instance = SkipWhileIterator();
    instance._iterator = _iterator;
    instance._f = _f;
    ;
    return instance;
  }
  
static bool moveNext(SkipWhileIterator self  ) {
    {
if (!self._hasSkipped)       {
        self._hasSkipped = true;
while (moveNext(self))         {
if (!let_expression)           return true;
        }
      }
      return moveNext(self);
    }
  }
  
static dynamic current(SkipWhileIterator self  ) {
    return self.current;
  }
  
}

/// 转换后的类: EmptyIterable
class EmptyIterable extends EfficientLengthIterable implements HideEfficientLengthIterable {
  EmptyIterable();
  
static EmptyIterable create(  ) {
    final instance = EmptyIterable();
    ;
    return instance;
  }
  
static Iterator iterator(EmptyIterable self  ) {
    return const InstanceConstant(const EmptyIterator<Never>{});
  }
  
static dynamic forEach(EmptyIterable self, Function action  ) {
    {
    }
  }
  
static bool isEmpty(EmptyIterable self  ) {
    return true;
  }
  
static int length(EmptyIterable self  ) {
    return 0;
  }
  
static dynamic first(EmptyIterable self  ) {
    {
      throw IterableElementError.noElement();
    }
  }
  
static dynamic last(EmptyIterable self  ) {
    {
      throw IterableElementError.noElement();
    }
  }
  
static dynamic single(EmptyIterable self  ) {
    {
      throw IterableElementError.noElement();
    }
  }
  
static dynamic elementAt(EmptyIterable self, int index  ) {
    {
      throw RangeError.create_range(index, 0, 0, "index");
    }
  }
  
static bool contains(EmptyIterable self, Object element  ) {
    return false;
  }
  
static bool every(EmptyIterable self, Function test  ) {
    return true;
  }
  
static bool any(EmptyIterable self, Function test  ) {
    return false;
  }
  
static dynamic firstWhere(EmptyIterable self, Function test, Function orElse  ) {
    {
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic lastWhere(EmptyIterable self, Function test, Function orElse  ) {
    {
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic singleWhere(EmptyIterable self, Function test, Function orElse  ) {
    {
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static String join(EmptyIterable self, String separator  ) {
    return "";
  }
  
static Iterable where(EmptyIterable self, Function test  ) {
    return self;
  }
  
static Iterable map(EmptyIterable self, Function toElement  ) {
    return EmptyIterable.create();
  }
  
static dynamic reduce(EmptyIterable self, Function combine  ) {
    {
      throw IterableElementError.noElement();
    }
  }
  
static dynamic fold(EmptyIterable self, dynamic initialValue, Function combine  ) {
    {
      return initialValue;
    }
  }
  
static Iterable skip(EmptyIterable self, int count  ) {
    {
      RangeError.checkNotNegative(count, "count");
      return self;
    }
  }
  
static Iterable skipWhile(EmptyIterable self, Function test  ) {
    return self;
  }
  
static Iterable take(EmptyIterable self, int count  ) {
    {
      RangeError.checkNotNegative(count, "count");
      return self;
    }
  }
  
static Iterable takeWhile(EmptyIterable self, Function test  ) {
    return self;
  }
  
static List toList(EmptyIterable self, bool growable  ) {
    return List.empty();
  }
  
static Set toSet(EmptyIterable self  ) {
    return _Set.create();
  }
  
}

/// 转换后的类: EmptyIterator
class EmptyIterator implements Iterator {
  EmptyIterator();
  
static EmptyIterator create(  ) {
    final instance = EmptyIterator();
    ;
    return instance;
  }
  
static bool moveNext(EmptyIterator self  ) {
    return false;
  }
  
static dynamic current(EmptyIterator self  ) {
    {
      throw IterableElementError.noElement();
    }
  }
  
}

/// 转换后的类: FollowedByIterable
class FollowedByIterable extends Iterable {
  late Iterable _first;
  late Iterable _second;
  
  FollowedByIterable();
  
static FollowedByIterable create(Iterable _first, Iterable _second  ) {
    final instance = FollowedByIterable();
    instance._first = _first;
    instance._second = _second;
    ;
    return instance;
  }
  
static Iterator iterator(FollowedByIterable self  ) {
    return FollowedByIterator.create(self._first, self._second);
  }
  
static int length(FollowedByIterable self  ) {
    return add(self, self.length);
  }
  
static bool isEmpty(FollowedByIterable self  ) {
    return self.isEmpty && self.isEmpty;
  }
  
static bool isNotEmpty(FollowedByIterable self  ) {
    return self.isNotEmpty || self.isNotEmpty;
  }
  
static bool contains(FollowedByIterable self, Object value  ) {
    return contains(self, value) || contains(self, value);
  }
  
static dynamic first(FollowedByIterable self  ) {
    {
      Iterator iterator = self.iterator;
if (moveNext(self))       return self.current;
      return self.first;
    }
  }
  
static dynamic last(FollowedByIterable self  ) {
    {
      Iterator iterator = self.iterator;
if (moveNext(self))       {
        dynamic last = self.current;
while (moveNext(self))         last = self.current;
        return last;
      }
      return self.last;
    }
  }
  
}

/// 转换后的类: EfficientLengthFollowedByIterable
class EfficientLengthFollowedByIterable extends FollowedByIterable implements EfficientLengthIterable, HideEfficientLengthIterable {
  EfficientLengthFollowedByIterable();
  
static EfficientLengthFollowedByIterable create(EfficientLengthIterable first, EfficientLengthIterable second  ) {
    final instance = EfficientLengthFollowedByIterable();
    ;
    return instance;
  }
  
static dynamic elementAt(EfficientLengthFollowedByIterable self, int index  ) {
    {
      int firstLength = self.length;
if (lessThan(self, firstLength))       return elementAt(self, index);
      return elementAt(self, subtract(self, firstLength));
    }
  }
  
static dynamic first(EfficientLengthFollowedByIterable self  ) {
    {
if (self.isNotEmpty)       return self.first;
      return self.first;
    }
  }
  
static dynamic last(EfficientLengthFollowedByIterable self  ) {
    {
if (self.isNotEmpty)       return self.last;
      return self.last;
    }
  }
  
}

/// 转换后的类: FollowedByIterator
class FollowedByIterator implements Iterator {
  FollowedByIterator();
  
static FollowedByIterator create(Iterable first, Iterable _nextIterable  ) {
    final instance = FollowedByIterator();
    instance._nextIterable = _nextIterable;
    instance._currentIterator = self.iterator;
    ;
    return instance;
  }
  
static bool moveNext(FollowedByIterator self  ) {
    {
if (moveNext(self))       return true;
if (!self._nextIterable == null)       {
        self._currentIterator = self.iterator;
        self._nextIterable = null;
        return moveNext(self);
      }
      return false;
    }
  }
  
static dynamic current(FollowedByIterator self  ) {
    return self.current;
  }
  
}

/// 转换后的类: WhereTypeIterable
class WhereTypeIterable extends Iterable {
  late Iterable _source;
  
  WhereTypeIterable();
  
static WhereTypeIterable create(Iterable _source  ) {
    final instance = WhereTypeIterable();
    instance._source = _source;
    ;
    return instance;
  }
  
static Iterator iterator(WhereTypeIterable self  ) {
    return WhereTypeIterator.create(self.iterator);
  }
  
}

/// 转换后的类: WhereTypeIterator
class WhereTypeIterator implements Iterator {
  late Iterator _source;
  
  WhereTypeIterator();
  
static WhereTypeIterator create(Iterator _source  ) {
    final instance = WhereTypeIterator();
    instance._source = _source;
    ;
    return instance;
  }
  
static bool moveNext(WhereTypeIterator self  ) {
    {
while (moveNext(self))       {
if (self.current is dynamic)         return true;
      }
      return false;
    }
  }
  
static dynamic current(WhereTypeIterator self  ) {
    return self.current as dynamic;
  }
  
}

/// 转换后的类: NonNullsIterable
class NonNullsIterable extends Iterable {
  late Iterable _source;
  
  NonNullsIterable();
  
static NonNullsIterable create(Iterable _source  ) {
    final instance = NonNullsIterable();
    instance._source = _source;
    ;
    return instance;
  }
  
static dynamic _firstNonNull(NonNullsIterable self  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (!element == null)             return element;
          }
        }
      }
      return null;
    }
  }
  
static bool isEmpty(NonNullsIterable self  ) {
    return self._firstNonNull == null;
  }
  
static bool isNotEmpty(NonNullsIterable self  ) {
    return !self._firstNonNull == null;
  }
  
static dynamic first(NonNullsIterable self  ) {
    return let_expression;
  }
  
static Iterator iterator(NonNullsIterable self  ) {
    return NonNullsIterator.create(self.iterator);
  }
  
}

/// 转换后的类: NonNullsIterator
class NonNullsIterator implements Iterator {
  late Iterator _source;
  
  NonNullsIterator();
  
static NonNullsIterator create(Iterator _source  ) {
    final instance = NonNullsIterator();
    instance._source = _source;
    ;
    return instance;
  }
  
static bool moveNext(NonNullsIterator self  ) {
    {
      self._current = null;
while (moveNext(self))       {
        dynamic next = self.current;
if (!next == null)         {
          self._current = next;
          return true;
        }
      }
      return false;
    }
  }
  
static dynamic current(NonNullsIterator self  ) {
    return let_expression;
  }
  
}

/// 转换后的类: IndexedIterable
class IndexedIterable extends Iterable {
  late Iterable _source;
  late int _start;
  
  IndexedIterable();
  
static IndexedIterable create_nonEfficientLength(Iterable source, int start  ) {
    final instance = IndexedIterable();
    ;
    return instance;
  }
  
static IndexedIterable create__(Iterable _source, int _start  ) {
    final instance = IndexedIterable();
    instance._source = _source;
    instance._start = _start;
    ;
    return instance;
  }
  
static int length(IndexedIterable self  ) {
    return self.length;
  }
  
static bool isEmpty(IndexedIterable self  ) {
    return self.isEmpty;
  }
  
static bool isNotEmpty(IndexedIterable self  ) {
    return self.isNotEmpty;
  }
  
static dynamic first(IndexedIterable self  ) {
    return (self._start, self.first);
  }
  
static dynamic single(IndexedIterable self  ) {
    return (self._start, self.single);
  }
  
static dynamic elementAt(IndexedIterable self, int index  ) {
    return (add(self, self._start), elementAt(self, index));
  }
  
static bool contains(IndexedIterable self, Object element  ) {
    {
      {
        Object _0_0 = element;
        Object _0_2;
        bool _0_2_isSet = false;
        Object _0_3;
        bool _0_3_isSet = false;
        {
          int index;
          Object other;
if (_0_0 is dynamic && _0_2_isSet ? _0_2 : let_expression is int && let_expression && _0_3_isSet ? _0_3 : let_expression is Object && let_expression && greaterThanOrEqual(self, self._start))           {
            int unbiasedIndex = subtract(self, self._start);
            Iterator iterator = self.iterator;
            return moveNext(self) && self.current == other;
          }
        }
      }
      return false;
    }
  }
  
static Iterable take(IndexedIterable self, int count  ) {
    return IndexedIterable.create_nonEfficientLength(take(self, _checkCount(count)), self._start);
  }
  
static Iterable skip(IndexedIterable self, int count  ) {
    return IndexedIterable.create_nonEfficientLength(skip(self, _checkCount(count)), add(self, self._start));
  }
  
static Iterator iterator(IndexedIterable self  ) {
    return IndexedIterator.create(self.iterator, self._start);
  }
  
}

/// 转换后的类: EfficientLengthIndexedIterable
class EfficientLengthIndexedIterable extends IndexedIterable implements EfficientLengthIterable, HideEfficientLengthIterable {
  EfficientLengthIndexedIterable();
  
static EfficientLengthIndexedIterable create(Iterable _source, int _start  ) {
    final instance = EfficientLengthIndexedIterable();
    ;
    return instance;
  }
  
static dynamic last(EfficientLengthIndexedIterable self  ) {
    {
      int length = self.length;
if (lessThanOrEqual(self, 0))       throw IterableElementError.noElement();
      dynamic last = self.last;
if (!length == self.length)       {
        throw ConcurrentModificationError.create(self);
      }
      return (add(self, self._start), last);
    }
  }
  
static bool contains(EfficientLengthIndexedIterable self, Object element  ) {
    {
      {
        Object _0_0 = element;
        Object _0_2;
        bool _0_2_isSet = false;
        Object _0_3;
        bool _0_3_isSet = false;
        {
          int index;
          Object other;
if (_0_0 is dynamic && _0_2_isSet ? _0_2 : let_expression is int && let_expression && _0_3_isSet ? _0_3 : let_expression is Object && let_expression && greaterThanOrEqual(self, self._start))           {
            int unbiasedIndex = subtract(self, self._start);
            return lessThan(self, self.length) && elementAt(self, unbiasedIndex) == other;
          }
        }
      }
      return false;
    }
  }
  
static Iterable take(EfficientLengthIndexedIterable self, int count  ) {
    return EfficientLengthIndexedIterable.create(take(self, _checkCount(count)), self._start);
  }
  
static Iterable skip(EfficientLengthIndexedIterable self, int count  ) {
    return EfficientLengthIndexedIterable.create(skip(self, _checkCount(count)), add(self, count));
  }
  
}

/// 转换后的类: IndexedIterator
class IndexedIterator implements Iterator {
  late Iterator _source;
  late int _start;
  
  IndexedIterator();
  
static IndexedIterator create(Iterator _source, int _start  ) {
    final instance = IndexedIterator();
    instance._source = _source;
    instance._start = _start;
    ;
    return instance;
  }
  
static bool moveNext(IndexedIterator self  ) {
    {
      int index = self._index = add(self, 1);
if (greaterThanOrEqual(self, 0) && moveNext(self))       {
        return true;
      }
      self._index = negate(self);
      return false;
    }
  }
  
static dynamic current(IndexedIterator self  ) {
    return greaterThanOrEqual(self, 0) ? (add(self, self._index), self.current) : throw IterableElementError.noElement();
  }
  
}

/// 转换后的类: IterableElementError
class IterableElementError {
  IterableElementError();
  
static IterableElementError create(  ) {
    final instance = IterableElementError();
    ;
    return instance;
  }
  
}

/// 转换后的类: FixedLengthListMixin
class FixedLengthListMixin {
  FixedLengthListMixin();
  
static dynamic length(FixedLengthListMixin self, int newLength  ) {
    {
      throw UnsupportedError.create("Cannot change the length of a fixed-length list");
    }
  }
  
static dynamic add(FixedLengthListMixin self, dynamic value  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static dynamic insert(FixedLengthListMixin self, int index, dynamic value  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static dynamic insertAll(FixedLengthListMixin self, int at, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static dynamic addAll(FixedLengthListMixin self, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static bool remove(FixedLengthListMixin self, Object element  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic removeWhere(FixedLengthListMixin self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic retainWhere(FixedLengthListMixin self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic clear(FixedLengthListMixin self  ) {
    {
      throw UnsupportedError.create("Cannot clear a fixed-length list");
    }
  }
  
static dynamic removeAt(FixedLengthListMixin self, int index  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic removeLast(FixedLengthListMixin self  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic removeRange(FixedLengthListMixin self, int start, int end  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic replaceRange(FixedLengthListMixin self, int start, int end, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
}

/// 转换后的类: UnmodifiableListMixin
class UnmodifiableListMixin implements List {
  UnmodifiableListMixin();
  
static dynamic length(UnmodifiableListMixin self, int newLength  ) {
    {
      throw UnsupportedError.create("Cannot change the length of an unmodifiable list");
    }
  }
  
static dynamic first(UnmodifiableListMixin self, dynamic element  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic last(UnmodifiableListMixin self, dynamic element  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic setAll(UnmodifiableListMixin self, int at, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic add(UnmodifiableListMixin self, dynamic value  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static dynamic insert(UnmodifiableListMixin self, int index, dynamic element  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static dynamic insertAll(UnmodifiableListMixin self, int at, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static dynamic addAll(UnmodifiableListMixin self, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static bool remove(UnmodifiableListMixin self, Object element  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic removeWhere(UnmodifiableListMixin self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic retainWhere(UnmodifiableListMixin self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic sort(UnmodifiableListMixin self, Function compare  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic shuffle(UnmodifiableListMixin self, Random random  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic clear(UnmodifiableListMixin self  ) {
    {
      throw UnsupportedError.create("Cannot clear an unmodifiable list");
    }
  }
  
static dynamic removeAt(UnmodifiableListMixin self, int index  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic removeLast(UnmodifiableListMixin self  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic setRange(UnmodifiableListMixin self, int start, int end, Iterable iterable, int skipCount  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic removeRange(UnmodifiableListMixin self, int start, int end  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic replaceRange(UnmodifiableListMixin self, int start, int end, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic fillRange(UnmodifiableListMixin self, int start, int end, dynamic fillValue  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic setElement(UnmodifiableListMixin self, int indexdynamic value  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
}

/// 转换后的类: FixedLengthListBase
class FixedLengthListBase extends ListBase implements FixedLengthListMixin {
  FixedLengthListBase();
  
static FixedLengthListBase create(  ) {
    final instance = FixedLengthListBase();
    ;
    return instance;
  }
  
static dynamic length(FixedLengthListBase self, int newLength  ) {
    {
      throw UnsupportedError.create("Cannot change the length of a fixed-length list");
    }
  }
  
static dynamic add(FixedLengthListBase self, dynamic value  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static dynamic insert(FixedLengthListBase self, int index, dynamic value  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static dynamic insertAll(FixedLengthListBase self, int at, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static dynamic addAll(FixedLengthListBase self, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to a fixed-length list");
    }
  }
  
static bool remove(FixedLengthListBase self, Object element  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic removeWhere(FixedLengthListBase self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic retainWhere(FixedLengthListBase self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic clear(FixedLengthListBase self  ) {
    {
      throw UnsupportedError.create("Cannot clear a fixed-length list");
    }
  }
  
static dynamic removeAt(FixedLengthListBase self, int index  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic removeLast(FixedLengthListBase self  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic removeRange(FixedLengthListBase self, int start, int end  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
static dynamic replaceRange(FixedLengthListBase self, int start, int end, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot remove from a fixed-length list");
    }
  }
  
}

/// 转换后的类: UnmodifiableListBase
class UnmodifiableListBase extends ListBase implements UnmodifiableListMixin {
  UnmodifiableListBase();
  
static UnmodifiableListBase create(  ) {
    final instance = UnmodifiableListBase();
    ;
    return instance;
  }
  
static dynamic length(UnmodifiableListBase self, int newLength  ) {
    {
      throw UnsupportedError.create("Cannot change the length of an unmodifiable list");
    }
  }
  
static dynamic first(UnmodifiableListBase self, dynamic element  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic last(UnmodifiableListBase self, dynamic element  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic setAll(UnmodifiableListBase self, int at, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic add(UnmodifiableListBase self, dynamic value  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static dynamic insert(UnmodifiableListBase self, int index, dynamic element  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static dynamic insertAll(UnmodifiableListBase self, int at, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static dynamic addAll(UnmodifiableListBase self, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot add to an unmodifiable list");
    }
  }
  
static bool remove(UnmodifiableListBase self, Object element  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic removeWhere(UnmodifiableListBase self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic retainWhere(UnmodifiableListBase self, Function test  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic sort(UnmodifiableListBase self, Function compare  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic shuffle(UnmodifiableListBase self, Random random  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic clear(UnmodifiableListBase self  ) {
    {
      throw UnsupportedError.create("Cannot clear an unmodifiable list");
    }
  }
  
static dynamic removeAt(UnmodifiableListBase self, int index  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic removeLast(UnmodifiableListBase self  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic setRange(UnmodifiableListBase self, int start, int end, Iterable iterable, int skipCount  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic removeRange(UnmodifiableListBase self, int start, int end  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic replaceRange(UnmodifiableListBase self, int start, int end, Iterable iterable  ) {
    {
      throw UnsupportedError.create("Cannot remove from an unmodifiable list");
    }
  }
  
static dynamic fillRange(UnmodifiableListBase self, int start, int end, dynamic fillValue  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
static dynamic setElement(UnmodifiableListBase self, int indexdynamic value  ) {
    {
      throw UnsupportedError.create("Cannot modify an unmodifiable list");
    }
  }
  
}

/// 转换后的类: ListMapView
class ListMapView extends UnmodifiableMapBase {
  ListMapView();
  
static ListMapView create(List _values  ) {
    final instance = ListMapView();
    instance._values = _values;
    ;
    return instance;
  }
  
static int length(ListMapView self  ) {
    return self.length;
  }
  
static Iterable values(ListMapView self  ) {
    return SubListIterable.create(self._values, 0, null);
  }
  
static Iterable keys(ListMapView self  ) {
    return _ListIndicesIterable.create(self._values);
  }
  
static bool isEmpty(ListMapView self  ) {
    return self.isEmpty;
  }
  
static bool isNotEmpty(ListMapView self  ) {
    return self.isNotEmpty;
  }
  
static bool containsValue(ListMapView self, Object value  ) {
    return contains(self, value);
  }
  
static bool containsKey(ListMapView self, Object key  ) {
    return key is int && greaterThanOrEqual(self, 0) && lessThan(self, self.length);
  }
  
static dynamic forEach(ListMapView self, Function f  ) {
    {
      int length = self.length;
for (int i = 0; lessThan(self, length); i = add(self, 1))       {
        functionInvocation(i, getElement(self, i));
if (!length == self.length)         {
          throw ConcurrentModificationError.create(self._values);
        }
      }
    }
  }
  
static dynamic getElement(ListMapView self, Object key  ) {
    return containsKey(self, key) ? getElement(self, key as int) : null;
  }
  
}

/// 转换后的类: ReversedListIterable
class ReversedListIterable extends ListIterable {
  ReversedListIterable();
  
static ReversedListIterable create(Iterable _source  ) {
    final instance = ReversedListIterable();
    instance._source = _source;
    ;
    return instance;
  }
  
static int length(ReversedListIterable self  ) {
    return self.length;
  }
  
static dynamic elementAt(ReversedListIterable self, int index  ) {
    return elementAt(self, subtract(self, index));
  }
  
}

/// 转换后的类: UnmodifiableListError
class UnmodifiableListError {
  UnmodifiableListError();
  
static UnmodifiableListError create(  ) {
    final instance = UnmodifiableListError();
    ;
    return instance;
  }
  
}

/// 转换后的类: NonGrowableListError
class NonGrowableListError {
  NonGrowableListError();
  
static NonGrowableListError create(  ) {
    final instance = NonGrowableListError();
    ;
    return instance;
  }
  
}

/// 转换后的类: LinkedList
class LinkedList extends Iterable {
  LinkedList();
  
static LinkedList create(  ) {
    final instance = LinkedList();
    ;
    return instance;
  }
  
static dynamic first(LinkedList self  ) {
    return let_expression;
  }
  
static dynamic last(LinkedList self  ) {
    return let_expression;
  }
  
static bool isEmpty(LinkedList self  ) {
    return self.length == 0;
  }
  
static dynamic add(LinkedList self, dynamic newLast  ) {
    {
assert(self._next == null && self._previous == null      );
if (!self._last == null)       {
assert(self._next == null        );
        self._next = newLast;
      }
 else       {
        self._first = newLast;
      }
      self._previous = self._last;
      self._last = newLast;
      self._list = self;
      self.length = add(self, 1);
    }
  }
  
static dynamic addFirst(LinkedList self, dynamic newFirst  ) {
    {
if (!self._first == null)       {
assert(self._previous == null        );
        self._previous = newFirst;
      }
 else       {
        self._last = newFirst;
      }
      self._next = self._first;
      self._first = newFirst;
      self._list = self;
      self.length = add(self, 1);
    }
  }
  
static dynamic remove(LinkedList self, dynamic node  ) {
    {
if (!self._list == self)       return Void;
      self.length = subtract(self, 1);
if (self._previous == null)       {
assert(identical(node, self._first)        );
        self._first = self._next;
      }
 else       {
        self._next = self._next;
      }
if (self._next == null)       {
assert(identical(node, self._last)        );
        self._last = self._previous;
      }
 else       {
        self._previous = self._previous;
      }
      self._next = self._previous = null;
      self._list = null;
    }
  }
  
static Iterator iterator(LinkedList self  ) {
    return _LinkedListIterator.create(self);
  }
  
}

/// 转换后的类: LinkedListEntry
class LinkedListEntry {
  LinkedListEntry();
  
static LinkedListEntry create(  ) {
    final instance = LinkedListEntry();
    ;
    return instance;
  }
  
static dynamic unlink(LinkedListEntry self  ) {
    {
      let_expression;
    }
  }
  
}

/// 转换后的类: Sort
class Sort {
  Sort();
  
static Sort create(  ) {
    final instance = Sort();
    ;
    return instance;
  }
  
}

/// 转换后的类: Symbol
class Symbol implements Symbol {
  late String _name;
  
  Symbol();
  
static Symbol create(String name  ) {
    final instance = Symbol();
    instance._name = name;
    ;
    return instance;
  }
  
static Symbol create_unvalidated(String _name  ) {
    final instance = Symbol();
    instance._name = _name;
    ;
    return instance;
  }
  
static int hashCode(Symbol self  ) {
    {
      return bitwiseAnd(self, multiply(self, self.hashCode));
    }
  }
  
static String toString(Symbol self  ) {
    return "Symbol("" + Symbol.computeUnmangledName(self) + "")";
  }
  
static bool equals(Symbol self, Object other  ) {
    return other is Symbol && self._name == self._name;
  }
  
}

/// 转换后的类: IsolateSpawnException
class IsolateSpawnException implements Exception {
  late String message;
  
  IsolateSpawnException();
  
static IsolateSpawnException create(String message  ) {
    final instance = IsolateSpawnException();
    instance.message = message;
    ;
    return instance;
  }
  
static String toString(IsolateSpawnException self  ) {
    return "IsolateSpawnException: " + self.message;
  }
  
}

/// 转换后的类: Isolate
class Isolate {
  late SendPort controlPort;
  late Capability pauseCapability;
  late Capability terminateCapability;
  
  Isolate();
  
static Isolate create(SendPort controlPort, Capability pauseCapability, Capability terminateCapability  ) {
    final instance = Isolate();
    instance.controlPort = controlPort;
    instance.pauseCapability = pauseCapability;
    instance.terminateCapability = terminateCapability;
    ;
    return instance;
  }
  
static String debugName(Isolate self  ) {
    return Isolate._getDebugName(self.controlPort);
  }
  
static Capability pause(Isolate self, Capability resumeCapability  ) {
    {
      resumeCapability == null ? resumeCapability = Capability.() : null;
      _pause(self, resumeCapability);
      return resumeCapability;
    }
  }
  
static dynamic _pause(Isolate self, Capability resumeCapability  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic resume(Isolate self, Capability resumeCapability  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic addOnExitListener(Isolate self, SendPort responsePort, Object response  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic removeOnExitListener(Isolate self, SendPort responsePort  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic setErrorsFatal(Isolate self, bool errorsAreFatal  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic kill(Isolate self, int priority  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic ping(Isolate self, SendPort responsePort, Object response, int priority  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic addErrorListener(Isolate self, SendPort port  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static dynamic removeErrorListener(Isolate self, SendPort port  ) {
    {
      List msg = let_expression;
      Isolate._sendOOB(self.controlPort, msg);
    }
  }
  
static Stream errors(Isolate self  ) {
    {
      StreamController controller = StreamController.broadcast();
      RawReceivePort port;
      // TODO: 处理语句类型 FunctionDeclaration
      self.onListen = () { /* TODO: 实现匿名函数 */ return null as dynamic; };
      self.onCancel = () { /* TODO: 实现匿名函数 */ return null as Null; };
      return self.stream;
    }
  }
  
}

/// 转换后的类: SendPort
class SendPort implements Capability {
  SendPort();
  
static SendPort create(  ) {
    final instance = SendPort();
    ;
    return instance;
  }
  
}

/// 转换后的类: ReceivePort
class ReceivePort implements Stream {
  ReceivePort();
  
}

/// 转换后的类: RawReceivePort
class RawReceivePort {
  RawReceivePort();
  
}

/// 转换后的类: RemoteError
class RemoteError implements Error {
  late String _description;
  late StackTrace stackTrace;
  
  RemoteError();
  
static RemoteError create(String description, String stackDescription  ) {
    final instance = RemoteError();
    instance._description = description;
    instance.stackTrace = _StringStackTrace.create(stackDescription);
    ;
    return instance;
  }
  
static String toString(RemoteError self  ) {
    return self._description;
  }
  
static StackTrace _stackTrace(RemoteError self  ) {
    return throw NoSuchMethodError.withInvocation(self, _InvocationMirror.create__withType(const SymbolConstant(#_stackTrace), 1, const ListConstant(const <Type>[]), const ListConstant(const <dynamic>[]), Map.unmodifiable(const MapConstant(const <Symbol, dynamic>{}))));
  }
  
static dynamic _stackTrace(RemoteError self, StackTrace value  ) {
    return throw NoSuchMethodError.withInvocation(self, _InvocationMirror.create__withType(const SymbolConstant(#_stackTrace=), 2, const ListConstant(const <Type>[]), List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const MapConstant(const <Symbol, dynamic>{}))));
  }
  
}

/// 转换后的类: TransferableTypedData
class TransferableTypedData {
  TransferableTypedData();
  
}

/// 转换后的类: Capability
class Capability {
  Capability();
  
}

/// 转换后的类: Point
class Point {
  late dynamic x;
  late dynamic y;
  
  Point();
  
static Point create(dynamic x, dynamic y  ) {
    final instance = Point();
    instance.x = x;
    instance.y = y;
    ;
    return instance;
  }
  
static String toString(Point self  ) {
    return "Point(" + self.x + ", " + self.y + ")";
  }
  
static int hashCode(Point self  ) {
    return SystemHash.hash2(self.hashCode, self.hashCode, 0);
  }
  
static double magnitude(Point self  ) {
    return sqrt(+(self, multiply(self, self.y)));
  }
  
static double distanceTo(Point self, Point other  ) {
    {
      num dx = subtract(self, self.x);
      num dy = subtract(self, self.y);
      return sqrt(+(self, multiply(self, dy)));
    }
  }
  
static dynamic squaredDistanceTo(Point self, Point other  ) {
    {
      num dx = subtract(self, self.x);
      num dy = subtract(self, self.y);
      return +(self, multiply(self, dy)) as dynamic;
    }
  }
  
static bool equals(Point self, Object other  ) {
    return other is Point && self.x == self.x && self.y == self.y;
  }
  
static Point add(Point self, Point other  ) {
    {
      return Point.create(add(self, self.x) as dynamic, add(self, self.y) as dynamic);
    }
  }
  
static Point subtract(Point self, Point other  ) {
    {
      return Point.create(subtract(self, self.x) as dynamic, subtract(self, self.y) as dynamic);
    }
  }
  
static Point multiply(Point self, num factor  ) {
    {
      return Point.create(multiply(self, factor) as dynamic, multiply(self, factor) as dynamic);
    }
  }
  
}

/// 转换后的类: Random
class Random {
  Random();
  
}

/// 转换后的类: Rectangle
class Rectangle extends _RectangleBase {
  late dynamic left;
  late dynamic top;
  late dynamic width;
  late dynamic height;
  
  Rectangle();
  
static Rectangle create(dynamic left, dynamic top, dynamic width, dynamic height  ) {
    final instance = Rectangle();
    instance.left = left;
    instance.top = top;
    instance.width = lessThan(self, 0) ? width == const DoubleConstant(-Infinity) ? 0.0 : multiply(self, 0) as dynamic : add(self, 0) as dynamic as dynamic;
    instance.height = lessThan(self, 0) ? height == const DoubleConstant(-Infinity) ? 0.0 : multiply(self, 0) as dynamic : add(self, 0) as dynamic as dynamic;
    ;
    return instance;
  }
  
}

/// 转换后的类: MutableRectangle
class MutableRectangle extends _RectangleBase implements Rectangle {
  MutableRectangle();
  
static MutableRectangle create(dynamic left, dynamic top, dynamic width, dynamic height  ) {
    final instance = MutableRectangle();
    instance.left = left;
    instance.top = top;
    instance._width = lessThan(self, 0) ? _clampToZero(width) : add(self, 0) as dynamic as dynamic;
    instance._height = lessThan(self, 0) ? _clampToZero(height) : add(self, 0) as dynamic as dynamic;
    ;
    return instance;
  }
  
static dynamic width(MutableRectangle self  ) {
    return self._width;
  }
  
static dynamic width(MutableRectangle self, dynamic width  ) {
    {
if (lessThan(self, 0))       width = _clampToZero(width);
      self._width = width;
    }
  }
  
static dynamic height(MutableRectangle self  ) {
    return self._height;
  }
  
static dynamic height(MutableRectangle self, dynamic height  ) {
    {
if (lessThan(self, 0))       height = _clampToZero(height);
      self._height = height;
    }
  }
  
}

/// 转换后的类: AbstractClassInstantiationError
class AbstractClassInstantiationError extends Error {
  late String _className;
  
  AbstractClassInstantiationError();
  
static AbstractClassInstantiationError create__create(String _className, String _url, int _line  ) {
    final instance = AbstractClassInstantiationError();
    instance._className = _className;
    instance._url = _url;
    instance._line = _line;
    ;
    return instance;
  }
  
static AbstractClassInstantiationError create(String className  ) {
    final instance = AbstractClassInstantiationError();
    instance._url = null;
    instance._className = className;
    ;
    return instance;
  }
  
static String toString(AbstractClassInstantiationError self  ) {
    {
      return "Cannot instantiate abstract class " + self._className + ": " + "_url '" + self._url + "' line " + self._line;
    }
  }
  
}

/// 转换后的类: MirrorSystem
class MirrorSystem {
  MirrorSystem();
  
static MirrorSystem create(  ) {
    final instance = MirrorSystem();
    ;
    return instance;
  }
  
static LibraryMirror findLibrary(MirrorSystem self, Symbol libraryName  ) {
    {
      Iterable candidates = where(self, (LibraryMirror lib) { /* TODO: 实现匿名函数 */ return null as bool; });
if (self.length == 1)       {
        return self.single;
      }
if (greaterThan(self, 1))       {
        List uris = toList(self, );
        throw Exception.("There are multiple libraries named " + "'" + MirrorSystem.getName(libraryName) + "': " + uris);
      }
      throw Exception.("There is no library named '" + MirrorSystem.getName(libraryName) + "'");
    }
  }
  
}

/// 转换后的类: Mirror
class Mirror {
  Mirror();
  
static Mirror create(  ) {
    final instance = Mirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: IsolateMirror
class IsolateMirror implements Mirror {
  IsolateMirror();
  
static IsolateMirror create(  ) {
    final instance = IsolateMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: DeclarationMirror
class DeclarationMirror implements Mirror {
  DeclarationMirror();
  
static DeclarationMirror create(  ) {
    final instance = DeclarationMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: ObjectMirror
class ObjectMirror implements Mirror {
  ObjectMirror();
  
static ObjectMirror create(  ) {
    final instance = ObjectMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: InstanceMirror
class InstanceMirror implements ObjectMirror {
  InstanceMirror();
  
static InstanceMirror create(  ) {
    final instance = InstanceMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: ClosureMirror
class ClosureMirror implements InstanceMirror {
  ClosureMirror();
  
static ClosureMirror create(  ) {
    final instance = ClosureMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: LibraryMirror
class LibraryMirror implements DeclarationMirror, ObjectMirror {
  LibraryMirror();
  
static LibraryMirror create(  ) {
    final instance = LibraryMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: LibraryDependencyMirror
class LibraryDependencyMirror implements Mirror {
  LibraryDependencyMirror();
  
static LibraryDependencyMirror create(  ) {
    final instance = LibraryDependencyMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: CombinatorMirror
class CombinatorMirror implements Mirror {
  CombinatorMirror();
  
static CombinatorMirror create(  ) {
    final instance = CombinatorMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: TypeMirror
class TypeMirror implements DeclarationMirror {
  TypeMirror();
  
static TypeMirror create(  ) {
    final instance = TypeMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: ClassMirror
class ClassMirror implements TypeMirror, ObjectMirror {
  ClassMirror();
  
static ClassMirror create(  ) {
    final instance = ClassMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: FunctionTypeMirror
class FunctionTypeMirror implements ClassMirror {
  FunctionTypeMirror();
  
static FunctionTypeMirror create(  ) {
    final instance = FunctionTypeMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: TypeVariableMirror
class TypeVariableMirror extends TypeMirror {
  TypeVariableMirror();
  
static TypeVariableMirror create(  ) {
    final instance = TypeVariableMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: TypedefMirror
class TypedefMirror implements TypeMirror {
  TypedefMirror();
  
static TypedefMirror create(  ) {
    final instance = TypedefMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: MethodMirror
class MethodMirror implements DeclarationMirror {
  MethodMirror();
  
static MethodMirror create(  ) {
    final instance = MethodMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: VariableMirror
class VariableMirror implements DeclarationMirror {
  VariableMirror();
  
static VariableMirror create(  ) {
    final instance = VariableMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: ParameterMirror
class ParameterMirror implements VariableMirror {
  ParameterMirror();
  
static ParameterMirror create(  ) {
    final instance = ParameterMirror();
    ;
    return instance;
  }
  
}

/// 转换后的类: SourceLocation
class SourceLocation {
  SourceLocation();
  
static SourceLocation create(  ) {
    final instance = SourceLocation();
    ;
    return instance;
  }
  
}

/// 转换后的类: ByteBuffer
class ByteBuffer {
  ByteBuffer();
  
static ByteBuffer create(  ) {
    final instance = ByteBuffer();
    ;
    return instance;
  }
  
}

/// 转换后的类: TypedData
class TypedData {
  TypedData();
  
static TypedData create(  ) {
    final instance = TypedData();
    ;
    return instance;
  }
  
}

/// 转换后的类: TypedDataList
class TypedDataList implements TypedData, List {
  TypedDataList();
  
static TypedDataList create(  ) {
    final instance = TypedDataList();
    ;
    return instance;
  }
  
}

/// 转换后的类: Endian
class Endian {
  late bool _littleEndian;
  
  Endian();
  
static Endian create__(bool _littleEndian  ) {
    final instance = Endian();
    instance._littleEndian = _littleEndian;
    ;
    return instance;
  }
  
}

/// 转换后的类: ByteData
class ByteData implements TypedData {
  ByteData();
  
}

/// 转换后的类: Int8List
class Int8List implements _TypedIntList {
  Int8List();
  
}

/// 转换后的类: Uint8List
class Uint8List implements _TypedIntList {
  Uint8List();
  
}

/// 转换后的类: Uint8ClampedList
class Uint8ClampedList implements _TypedIntList {
  Uint8ClampedList();
  
}

/// 转换后的类: Int16List
class Int16List implements _TypedIntList {
  Int16List();
  
}

/// 转换后的类: Uint16List
class Uint16List implements _TypedIntList {
  Uint16List();
  
}

/// 转换后的类: Int32List
class Int32List implements _TypedIntList {
  Int32List();
  
}

/// 转换后的类: Uint32List
class Uint32List implements _TypedIntList {
  Uint32List();
  
}

/// 转换后的类: Int64List
class Int64List implements _TypedIntList {
  Int64List();
  
}

/// 转换后的类: Uint64List
class Uint64List implements _TypedIntList {
  Uint64List();
  
}

/// 转换后的类: Float32List
class Float32List implements _TypedFloatList {
  Float32List();
  
}

/// 转换后的类: Float64List
class Float64List implements _TypedFloatList {
  Float64List();
  
}

/// 转换后的类: Float32x4List
class Float32x4List implements TypedDataList, TypedData {
  Float32x4List();
  
}

/// 转换后的类: Int32x4List
class Int32x4List implements TypedDataList, TypedData {
  Int32x4List();
  
}

/// 转换后的类: Float64x2List
class Float64x2List implements TypedDataList, TypedData {
  Float64x2List();
  
}

/// 转换后的类: Float32x4
class Float32x4 {
  Float32x4();
  
}

/// 转换后的类: Int32x4
class Int32x4 {
  Int32x4();
  
}

/// 转换后的类: Float64x2
class Float64x2 {
  Float64x2();
  
}

/// 转换后的类: PendingWrite
class PendingWrite {
  late Completer completer;
  late Uri uri;
  late List bytes;
  
  PendingWrite();
  
static PendingWrite create(Uri uri, List bytes  ) {
    final instance = PendingWrite();
    instance.uri = uri;
    instance.bytes = bytes;
    ;
    return instance;
  }
  
static Future write(PendingWrite self  ) {
    {
      File file = File.fromUri(self.uri);
      Directory parent_directory = self.parent;
      await create(self, );
if (await exists(self, ))       {
        await delete(self, );
      }
      await writeAsBytes(self, self.bytes);
      complete(self, );
      WriteLimiter._writeCompleted();
    }
  }
  
}

/// 转换后的类: WriteLimiter
class WriteLimiter {
  WriteLimiter();
  
static WriteLimiter create(  ) {
    final instance = WriteLimiter();
    ;
    return instance;
  }
  
}

/// 转换后的类: WebSocketClient
class WebSocketClient extends Client {
  late WebSocket socket;
  
  WebSocketClient();
  
static WebSocketClient create(WebSocket socket, VMService service  ) {
    final instance = WebSocketClient();
    instance.socket = socket;
    {
      listen(self, (dynamic message) { /* TODO: 实现匿名函数 */ return null as dynamic; });
      then(self, (dynamic formal_0) { /* TODO: 实现匿名函数 */ return null as dynamic; });
    }
    return instance;
  }
  
static Future disconnect(WebSocketClient self  ) {
    return close(self, );
  }
  
static dynamic onWebSocketMessage(WebSocketClient self, dynamic message  ) {
    {
if (message is String)       {
        dynamic jsonObj;
try         {
          jsonObj = decode(self, message);
        }
        // TODO: 实现try-catch语句
if (!jsonObj is Map)         {
          close(self, const IntConstant(4002), "Message must be a JSON map.");
          return Void;
        }
        Map map = jsonObj;
        Message rpc = Message.fromJsonRpc(self, map);
        // TODO: 实现标签语句
switch (self.type) {        // TODO: 实现switch语句
        }
      }
 else       {
        close(self, const IntConstant(4001), "Message must be a string.");
      }
    }
  }
  
static dynamic post(WebSocketClient self, Response result  ) {
    {
if (result == null)       {
        return Void;
      }
try       {
        // TODO: 实现标签语句
switch (self.kind) {        // TODO: 实现switch语句
        }
      }
      // TODO: 实现try-catch语句
    }
  }
  
static Map toJson(WebSocketClient self  ) {
    return (() {
    Map var = LinkedHashMap.of(super.toJson());
    setElement(self, "type", "WebSocketClient");
    setElement(self, "socket", self.socket);
    return null;
  })();
  }
  
}

/// 转换后的类: HttpRequestClient
class HttpRequestClient extends Client {
  late HttpRequest request;
  
  HttpRequestClient();
  
static HttpRequestClient create(HttpRequest request, VMService service  ) {
    final instance = HttpRequestClient();
    instance.request = request;
    ;
    return instance;
  }
  
static Future disconnect(HttpRequestClient self  ) {
    {
      await close(self, );
      close(self, );
    }
  }
  
static dynamic post(HttpRequestClient self, Response result  ) {
    {
if (result == null)       {
        close(self, );
        return Void;
      }
      HttpResponse response = self.response;
      add(self, "Access-Control-Allow-Origin", "*");
      self.contentType = self.jsonContentType;
      // TODO: 实现标签语句
switch (self.kind) {      // TODO: 实现switch语句
      }
      close(self, );
      close(self, );
    }
  }
  
static Map toJson(HttpRequestClient self  ) {
    {
      Map map = super.toJson();
      setElement(self, "type", "HttpRequestClient");
      setElement(self, "request", self.request);
      return map;
    }
  }
  
}

/// 转换后的类: Server
class Server {
  late VMService _service;
  late String _ip;
  late bool _originCheckDisabled;
  late bool _authCodesDisabled;
  late bool _enableServicePortFallback;
  late String _serviceInfoFilename;
  
  Server();
  
static Server create(VMService _service, String _ip, int _port, bool _originCheckDisabled, bool authCodesDisabled, String _serviceInfoFilename, bool _enableServicePortFallback  ) {
    final instance = Server();
    instance._service = _service;
    instance._ip = _ip;
    instance._port = _port;
    instance._originCheckDisabled = _originCheckDisabled;
    instance._serviceInfoFilename = _serviceInfoFilename;
    instance._enableServicePortFallback = _enableServicePortFallback;
    instance._authCodesDisabled = authCodesDisabled || self.isFuchsia;
    ;
    return instance;
  }
  
static bool running(Server self  ) {
    return self._running;
  }
  
static Uri serverAddress(Server self  ) {
    {
if (!self.ddsUri == null)       {
        return self.ddsUri;
      }
      HttpServer server = self._httpServer;
if (!server == null)       {
        String ip = self.address;
        int port = self.port;
        String path = !self._authCodesDisabled ? self.serviceAuthToken + "/" : "/";
        return _Uri.();
      }
      return null;
    }
  }
  
static Future startup(Server self  ) {
    {
if (self.running)       {
        return Void;
      }
      {
        Completer startingCompleter = self._startingCompleter;
if (!startingCompleter == null)         {
if (!self.isCompleted)           {
            await self.future;
          }
          return Void;
        }
      }
      Completer startingCompleter = Completer.();
      self._startingCompleter = startingCompleter;
      // TODO: 处理语句类型 FunctionDeclaration
if (!await call())       {
        complete(self, true);
        return Void;
      }
if (self.isExiting)       {
        serverPrint(const StringConstant("Dart VM service HTTP server exiting before listening as vm service has received exit request\n"));
        complete(self, true);
        await shutdown(self, true);
        return Void;
      }
      HttpServer server = self._httpServer!;
      listen(self, instance_tearoff);
if (self._waitForDdsToAdvertiseService)       {
        self._ddsInstance = _DebuggingSession.create();
        await start(self, self.serverAddress!, self._ddsIP, toString(self, ), self._authCodesDisabled, self._serveDevtools);
      }
 else       {
        await outputConnectionInformation(self, );
      }
      self._running = true;
      _notifyServerState(toString(self, ));
      onServerAddressChange(self.serverAddress);
      complete(self, true);
    }
  }
  
static Future shutdown(Server self, bool forced  ) {
    {
if (!self._startingCompleter == null)       {
if (!self.isCompleted)         {
          await self.future;
        }
      }
      HttpServer server = self._httpServer;
if (server == null)       {
        return Void;
      }
if (self.isFuchsia)       {
        _cleanupFuchsiaState(self, self.port);
      }
      Uri address = self.serverAddress!;
      // TODO: 处理语句类型 TryFinally
    }
  }
  
static Future outputConnectionInformation(Server self  ) {
    {
      serverPrint("The Dart VM service is listening on " + self.serverAddress);
if (self.isFuchsia)       {
        _writeFuchsiaState(self, self.port);
      }
      String serviceInfoFilenameLocal = self._serviceInfoFilename;
if (!serviceInfoFilenameLocal == null && self.isNotEmpty)       {
        await _dumpServiceInfoToFile(self, serviceInfoFilenameLocal);
      }
    }
  }
  
static bool _isAllowedOrigin(Server self, String origin  ) {
    {
      Uri uri;
try       {
        uri = Uri.parse(origin);
      }
      // TODO: 实现try-catch语句
if (self.host == "localhost" || self.host == "::1" || self.host == "127.0.0.1")       {
        return true;
      }
      HttpServer server = self._httpServer!;
if (self.port == self.port && self.host == self.address || self.host == self.host)       {
        return true;
      }
      return false;
    }
  }
  
static bool _originCheck(Server self, HttpRequest request  ) {
    {
if (self._originCheckDisabled)       {
        return true;
      }
      List origins = getElement(self, "Sec-WebSocket-Origin");
if (origins == null)       {
        origins = getElement(self, "Origin");
      }
if (origins == null)       {
        return true;
      }
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          String origin = self.current;
          {
if (_isAllowedOrigin(self, origin))             {
              return true;
            }
          }
        }
      }
      return false;
    }
  }
  
static dynamic _checkAuthTokenAndGetPath(Server self, Uri requestUri  ) {
    {
if (self._authCodesDisabled)       {
        return self.path == "/" ? const StringConstant("/index.html") : self.path;
      }
      List requestPathSegments = self.pathSegments;
if (self.isEmpty)       {
        return null;
      }
      String authToken = getElement(self, 0);
if (!authToken == self.serviceAuthToken)       {
        return null;
      }
if (self.length == 1)       {
        List pathSegments = List.from(requestPathSegments);
        add(self, "");
        return replace(self, );
      }
      return getElement(self, 1) == "" ? const StringConstant("/index.html") : "/" + join(self, "/");
    }
  }
  
static Future _processDevFSRequest(Server self, HttpRequest request  ) {
    {
      String fsName;
      String fsPath;
      Uri fsUri;
try       {
        fsName = getElement(self, 0);
        {
          List _0_0 = getElement(self, "dev_fs_uri_b64");
          String _0_6;
          bool _0_6_isSet = false;
          {
            String base64Uri;
if (_0_0 is List && self.length == const IntConstant(1) && _0_6_isSet ? _0_6 : let_expression is String)             {
              base64Uri = _0_6_isSet ? _0_6 : let_expression;
              {
                fsUri = Uri.parse(decode(self, decode(self, base64Uri)));
              }
            }
 else             {
              List _1_0 = getElement(self, "dev_fs_path_b64");
              String _1_6;
              bool _1_6_isSet = false;
              {
                String base64Uri;
if (_1_0 is List && self.length == const IntConstant(1) && _1_6_isSet ? _1_6 : let_expression is String)                 {
                  base64Uri = _1_6_isSet ? _1_6 : let_expression;
                  {
                    fsPath = decode(self, decode(self, base64Uri));
                  }
                }
 else                 {
                  List _2_0 = getElement(self, "dev_fs_path");
                  String _2_6;
                  bool _2_6_isSet = false;
                  {
                    String path;
if (_2_0 is List && self.length == const IntConstant(1) && _2_6_isSet ? _2_6 : let_expression is String)                     {
                      path = _2_6_isSet ? _2_6 : let_expression;
                      {
                        fsPath = path;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      // TODO: 实现try-catch语句
      // TODO: 处理语句类型 TryFinally
    }
  }
  
static dynamic _handleWebSocketRequest(Server self, HttpRequest request  ) {
    {
      List subprotocols = getElement(self, "sec-websocket-protocol");
if (self.acceptNewWebSocketConnections)       {
        then(self, (WebSocket webSocket) { /* TODO: 实现匿名函数 */ return null as Null; });
      }
 else       {
        redirect(self, self.ddsUri!);
      }
    }
  }
  
static Future _redirectToDevTools(Server self, HttpRequest request  ) {
    {
      Uri ddsUri = self.ddsUri;
if (ddsUri == null)       {
        self.contentType = self.text;
        write(self, const StringConstant("This VM does not have a registered Dart Development Service (DDS) instance and is not currently serving Dart DevTools."));
        close(self, );
        return Void;
      }
      StringBuffer path = StringBuffer.create();
if (greaterThan(self, 1))       {
        writeAll(self, _GrowableList._literal2(join(self, "/"), "/"));
      }
      String queryComponent = Uri.encodeQueryComponent(toString(self, ));
      writeAll(self, _GrowableList._literal2("devtools/", "?uri=" + queryComponent));
      Uri redirectUri = Uri.parse("http://" + self.host + ":" + self.port + "/" + path);
      redirect(self, redirectUri);
      return Void;
    }
  }
  
static Future _requestHandler(Server self, HttpRequest request  ) {
    {
if (!_originCheck(self, request))       {
        self.statusCode = const IntConstant(403);
        write(self, "forbidden origin");
        close(self, );
        return Void;
      }
if (self.method == "PUT")       {
        await _processDevFSRequest(self, request);
        return Void;
      }
if (!self.method == "GET")       {
        self.statusCode = const IntConstant(405);
        write(self, "method not allowed");
        close(self, );
        return Void;
      }
      dynamic result = _checkAuthTokenAndGetPath(self, self.uri);
if (result == null)       {
        self.statusCode = const IntConstant(403);
        write(self, "missing or invalid authentication code");
        close(self, );
        return Void;
      }
 else if (result is Uri)       {
        redirect(self, result);
        return Void;
      }
      String path = result as String;
if (path == const StringConstant("/ws"))       {
        _handleWebSocketRequest(self, request);
        return Void;
      }
if (!self._serveObservatory && path == const StringConstant("/index.html"))       {
        await _redirectToDevTools(self, request);
        return Void;
      }
if (self.assets == null)       {
        self.contentType = self.text;
        write(self, "This VM was built without the Observatory UI.");
        close(self, );
        return Void;
      }
      Asset asset = getElement(self, path);
if (!asset == null)       {
        self.contentType = ContentType.parse(self.mimeType);
        add(self, self.data);
        close(self, );
        return Void;
      }
      HttpRequestClient client = HttpRequestClient.create(request, self._service);
      Message message = Message.create_fromUri(client, _Uri.());
      onRequest(self, message);
    }
  }
  
static Future _dumpServiceInfoToFile(Server self, String serviceInfoFilenameLocal  ) {
    {
      Map serviceInfo = {"uri": toString(self, )};
      Uri uri = startsWith(self, const StringConstant("file://")) ? Uri.parse(serviceInfoFilenameLocal) : _Uri.file(serviceInfoFilenameLocal);
      File file = File.fromUri(uri);
      return writeAsString(self, encode(self, serviceInfo));
    }
  }
  
static dynamic _writeFuchsiaState(Server self, int port  ) {
    {
      String tmp = self.path;
      String path = tmp + "/dart.services/" + port;
      serverPrint("Creating " + path);
      createSync(self, );
    }
  }
  
static dynamic _cleanupFuchsiaState(Server self, int port  ) {
    {
      String tmp = self.path;
      String path = tmp + "/dart.services/" + port;
      serverPrint("Deleting " + path);
      deleteSync(self, );
    }
  }
  
}

/// 转换后的类: VMServiceEmbedderHooks
class VMServiceEmbedderHooks {
  VMServiceEmbedderHooks();
  
static VMServiceEmbedderHooks create(  ) {
    final instance = VMServiceEmbedderHooks();
    ;
    return instance;
  }
  
}

/// 转换后的类: VMService
class VMService extends MessageRouter {
  late NamedLookup clients;
  late IdGenerator _serviceRequests;
  late RunningIsolates runningIsolates;
  late RawReceivePort eventPort;
  late DevFS devfs;
  late Set _profilerUserTagSubscriptions;
  
  VMService();
  
static VMService create__internal(  ) {
    final instance = VMService();
    instance.eventPort = self.isolateControlPort;
    {
      self.handler = instance_tearoff;
    }
    return instance;
  }
  
static bool isExiting(VMService self  ) {
    return self._isExiting;
  }
  
static Uri ddsUri(VMService self  ) {
    return self._ddsUri;
  }
  
static dynamic _sendDdsConnectedEvent(VMService self, Client client, String uri  ) {
    {
      String message = "A Dart Developer Service instance has connected and this direct " + "connection to the VM service will now be closed. Please reconnect to " + "the Dart Development Service at " + uri + ".";
      Response event = Response.create_json({"jsonrpc": "2.0", "method": "streamNotify", "params": {"streamId": const StringConstant("Service"), "event": {"type": "Event", "kind": "DartDevelopmentServiceConnected", "message": message, "uri": uri, "timestamp": self.millisecondsSinceEpoch}}});
      post(self, event);
    }
  }
  
static Future _yieldControlToDDS(VMService self, Message message  ) {
    {
      Function acceptNewWebSocketConnections = self.acceptNewWebSocketConnections;
if (acceptNewWebSocketConnections == null)       {
        return encodeRpcError(message, const IntConstant(100));
      }
      Uri ddsUri = self._ddsUri;
if (!ddsUri == null)       {
        return encodeRpcError(message, const IntConstant(100));
      }
      String uri = getElement(self, "uri") as String;
if (uri == null)       {
        return encodeMissingParamError(message, "uri");
      }
      functionInvocation(false);
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Client client = self.current;
          // TODO: 实现标签语句
          {
if (self.client == client)             {
              break;
            }
            _sendDdsConnectedEvent(self, client, uri);
            disconnect(self, );
          }
        }
      }
      self._ddsUri = Uri.parse(uri);
      await functionInvocation();
      return encodeSuccess(message);
    }
  }
  
static dynamic _addClient(VMService self, Client client  ) {
    {
assert(self.isEmpty      );
assert(self.isEmpty      );
      add(self, client);
    }
  }
  
static dynamic _removeClient(VMService self, Client client  ) {
    {
      String namespace = keyOf(self, client);
      remove(self, client);
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          String streamId = self.current;
          {
if (!_isAnyClientSubscribed(self, streamId))             {
              _vmCancelStream(streamId);
            }
          }
        }
      }
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic pair = self.current;
          {
            routeRequest(self, self, Message.create__fromJsonRpcRequest(client, {"method": "deleteIdZone", "params": {"isolateId": pair.isolateId, "idZoneId": pair.serviceIdZoneId}}));
          }
        }
      }
      _cleanupUnusedUserTagSubscriptions(self, );
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          String service = self.current;
          {
            _eventMessageHandler(self, "Service", Response.create_json({"jsonrpc": "2.0", "method": "streamNotify", "params": {"streamId": "Service", "event": {"type": "Event", "kind": "ServiceUnregistered", "timestamp": self.millisecondsSinceEpoch, "service": service, "method": add(self, service)}}}));
          }
        }
      }
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Function handle = self.current;
          {
            functionInvocation(null);
          }
        }
      }
if (self.isEmpty)       {
        Function acceptNewWebSocketConnections = self.acceptNewWebSocketConnections;
if (!self._ddsUri == null && !acceptNewWebSocketConnections == null)         {
          self._ddsUri = null;
          functionInvocation();
          functionInvocation(true);
        }
      }
    }
  }
  
static dynamic _profilerEventMessageHandler(VMService self, Client client, Response event  ) {
    {
      Map eventJson = decodeJson(self, ) as Map;
      Map params = getElement(self, "params")! as Map;
      Map eventData = getElement(self, "event")! as Map;
if (!getElement(self, "kind")! == "CpuSamples")       {
        post(self, event);
        return Void;
      }
      Map cpuSamplesEvent = getElement(self, "cpuSamples")! as Map;
      List samples = cast(self, );
      List updatedSamples = toList(self, );
if (self.isEmpty)       {
        return Void;
      }
      setElement(self, "samples", updatedSamples);
      setElement(self, "sampleCount", self.length);
      post(self, Response.create_json(eventJson));
    }
  }
  
static dynamic _eventMessageHandler(VMService self, String streamId, Response event  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Client client = self.current;
          {
if (self.sendEvents && contains(self, streamId))             {
if (streamId == "Profiler")               {
                _profilerEventMessageHandler(self, client, event);
              }
 else               {
                post(self, event);
              }
            }
          }
        }
      }
    }
  }
  
static dynamic _controlMessageHandler(VMService self, int code, int portId, SendPort sp, String name  ) {
    {
      // TODO: 实现标签语句
switch (code) {      // TODO: 实现switch语句
      }
    }
  }
  
static Future _serverMessageHandler(VMService self, int code, SendPort sp, bool enable, bool silenceOutput  ) {
    {
      // TODO: 实现标签语句
switch (code) {      // TODO: 实现switch语句
      }
    }
  }
  
static Future _handleNativeRpcCall(VMService self, List message, SendPort replyPort  ) {
    {
      Response response;
try       {
        Message rpc = Message.fromJsonRpc(null, decode(self, decode(self, message)) as Map);
if (!self.type == const InstanceConstant(const MessageType{_Enum.index: 0, _Enum._name: "Request"}))         {
          response = Response.internalError("The client sent a non-request json-rpc message.");
        }
 else         {
          response = await routeRequest(self, self, rpc)!;
        }
      }
      // TODO: 实现try-catch语句
      List bytes;
      // TODO: 实现标签语句
switch (self.kind) {      // TODO: 实现switch语句
      }
      send(self, bytes);
    }
  }
  
static Future clearState(VMService self  ) {
    {
      List clientsList = toList(self, );
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Client client = self.current;
          {
            await disconnect(self, );
          }
        }
      }
      cleanup(self, );
    }
  }
  
static Future _exit(VMService self  ) {
    {
      self._isExiting = true;
      close(self, );
      await functionInvocation();
      await clearState(self, );
      _onExit();
    }
  }
  
static dynamic messageHandler(VMService self, dynamic message  ) {
    {
if (message is List)       {
        {
          List _0_0 = message;
          dynamic _0_4;
          bool _0_4_isSet = false;
          dynamic _0_5;
          bool _0_5_isSet = false;
          {
            String streamId;
            Object event;
if (self.length == const IntConstant(2) && _0_4_isSet ? _0_4 : let_expression is String && let_expression && _0_5_isSet ? _0_5 : let_expression is Object)             {
              event = let_expression;
              {
                _eventMessageHandler(self, streamId, Response.from(event));
                return Void;
              }
            }
          }
        }
        {
          List _1_0 = message;
          dynamic _1_4;
          bool _1_4_isSet = false;
          {
            int opcode;
if (self.length == const IntConstant(1) && _1_4_isSet ? _1_4 : let_expression is int)             {
              opcode = _1_4_isSet ? _1_4 : let_expression as int;
              {
assert(opcode == const IntConstant(0)                );
                _exit(self, );
                return Void;
              }
            }
          }
        }
        {
          List _2_0 = message;
          dynamic _2_4;
          bool _2_4_isSet = false;
          dynamic _2_5;
          bool _2_5_isSet = false;
          dynamic _2_6;
          bool _2_6_isSet = false;
          {
            int opcode;
            List messageBytes;
            SendPort replyPort;
if (self.length == const IntConstant(3) && _2_4_isSet ? _2_4 : let_expression is int && let_expression && _2_5_isSet ? _2_5 : let_expression is List && let_expression && _2_6_isSet ? _2_6 : let_expression is SendPort && let_expression && opcode == const IntConstant(5))             {
              _handleNativeRpcCall(self, messageBytes, replyPort);
              return Void;
            }
          }
        }
        {
          List _3_0 = message;
          dynamic _3_4;
          bool _3_4_isSet = false;
          dynamic _3_5;
          bool _3_5_isSet = false;
          dynamic _3_6;
          bool _3_6_isSet = false;
          dynamic _3_7;
          bool _3_7_isSet = false;
          {
            int opcode;
            SendPort sendPort;
            bool enable;
            bool silenceOutput;
if (self.length == const IntConstant(4) && _3_4_isSet ? _3_4 : let_expression is int && let_expression && _3_5_isSet ? _3_5 : let_expression is SendPort && let_expression && _3_6_isSet ? _3_6 : let_expression is bool && let_expression && _3_7_isSet ? _3_7 : let_expression is bool && let_expression && opcode == const IntConstant(3) || opcode == const IntConstant(4))             {
              _serverMessageHandler(self, opcode, sendPort, enable, silenceOutput);
              return Void;
            }
          }
        }
        {
          List _4_0 = message;
          dynamic _4_4;
          bool _4_4_isSet = false;
          dynamic _4_5;
          bool _4_5_isSet = false;
          dynamic _4_6;
          bool _4_6_isSet = false;
          dynamic _4_7;
          bool _4_7_isSet = false;
          {
            int opcode;
            int portId;
            SendPort sendPort;
            String name;
if (self.length == const IntConstant(4) && _4_4_isSet ? _4_4 : let_expression is int && let_expression && _4_5_isSet ? _4_5 : let_expression is int && let_expression && _4_6_isSet ? _4_6 : let_expression is SendPort && let_expression && _4_7_isSet ? _4_7 : let_expression is String && let_expression && opcode == const IntConstant(1) || opcode == const IntConstant(2))             {
              _controlMessageHandler(self, opcode, portId, sendPort, name);
              return Void;
            }
          }
        }
        print("Internal vm-service error: ignoring illegal message: " + message);
      }
    }
  }
  
static bool _isAnyClientSubscribed(VMService self, String streamId  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Client client = self.current;
          {
if (contains(self, streamId))             {
              return true;
            }
          }
        }
      }
      return false;
    }
  }
  
static Client _findFirstClientThatHandlesService(VMService self, String service  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          Client c = self.current;
          {
if (containsKey(self, service))             {
              return c;
            }
          }
        }
      }
      return null;
    }
  }
  
static Future _streamListen(VMService self, Message message  ) {
    {
      Client client = self.client!;
      String streamId = getElement(self, "streamId")! as String;
if (contains(self, streamId))       {
        return encodeRpcError(message, const IntConstant(103));
      }
if (!_isAnyClientSubscribed(self, streamId))       {
        bool includePrivates = getElement(self, "_includePrivateMembers") == true;
if (!contains(self, streamId) && !_vmListenStream(streamId, includePrivates))         {
          return encodeRpcError(message, const IntConstant(-32602));
        }
      }
      // TODO: 实现标签语句
switch (streamId) {      // TODO: 实现switch语句
      }
      add(self, streamId);
      return encodeSuccess(message);
    }
  }
  
static Future _streamCancel(VMService self, Message message  ) {
    {
      Client client = self.client!;
      String streamId = getElement(self, "streamId")! as String;
if (!contains(self, streamId))       {
        return encodeRpcError(message, const IntConstant(104));
      }
      remove(self, streamId);
if (!contains(self, streamId) && !_isAnyClientSubscribed(self, streamId))       {
        _vmCancelStream(streamId);
      }
      return encodeSuccess(message);
    }
  }
  
static Future _registerService(VMService self, Message message  ) {
    {
      Client client = self.client!;
      dynamic service = getElement(self, "service");
      dynamic alias = getElement(self, "alias");
if (!service is String || service == "")       {
        return encodeRpcError(message, const IntConstant(-32602));
      }
if (!alias is String || alias == "")       {
        return encodeRpcError(message, const IntConstant(-32602));
      }
if (containsKey(self, service))       {
        return encodeRpcError(message, const IntConstant(111));
      }
      setElement(self, service, alias);
      bool removed = false;
      // TODO: 处理语句类型 TryFinally
      return encodeSuccess(message);
    }
  }
  
static Future _sendServiceRegisteredEvent(VMService self, Client client, String service, Client target  ) {
    {
      String namespace = keyOf(self, client);
      String alias = getElement(self, service);
      Response event = Response.create_json({"jsonrpc": "2.0", "method": "streamNotify", "params": {"streamId": const StringConstant("Service"), "event": {"type": "Event", "kind": "ServiceRegistered", "timestamp": self.millisecondsSinceEpoch, "service": service, "method": add(self, service), "alias": alias}}});
if (target == null)       {
        _eventMessageHandler(self, const StringConstant("Service"), event);
      }
 else       {
        post(self, event);
      }
    }
  }
  
static Future _handleService(VMService self, Message message  ) {
    {
      String namespace = VMService._getNamespace(self.method!);
      String method = VMService._getMethod(self.method!);
      Client client = getElement(self, namespace);
if (containsKey(self, method))       {
        String id = newId(self, );
        Object oldId = self.serial;
        Completer completer = Completer.();
        setElement(self, id, (Message m) { /* TODO: 实现匿名函数 */ return null as dynamic; });
        post(self, Response.create_json(forwardToJson(self, {"id": id, "method": method})));
        return self.future;
      }
      return encodeRpcError(message, const IntConstant(-32601));
    }
  }
  
static Future _getSupportedProtocols(VMService self, Message message  ) {
    {
      Map payload = decode(self, decode(self, self.payload as List)) as Map;
      Map version = getElement(self, "result") as Map;
      Map protocols = {"type": "ProtocolList", "protocols": _GrowableList._literal1({"protocolName": "VM Service", "major": getElement(self, "major"), "minor": getElement(self, "minor")})};
      return encodeResult(message, protocols);
    }
  }
  
static dynamic _cleanupUnusedUserTagSubscriptions(VMService self  ) {
    {
      List unsubscribeableTags = _GrowableList.(0);
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          String subscribedTag = self.current;
          {
            bool hasSubscriber = false;
            // TODO: 实现标签语句
            {
              Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )               {
                Client c = self.current;
                {
if (contains(self, subscribedTag))                   {
                    hasSubscriber = true;
                    break;
                  }
                }
              }
            }
if (!hasSubscriber)             {
              add(self, subscribedTag);
            }
          }
        }
      }
if (self.isNotEmpty)       {
        removeAll(self, unsubscribeableTags);
        _removeUserTagsFromStreamableSampleList(unsubscribeableTags);
      }
    }
  }
  
static Future _streamCpuSamplesWithUserTag(VMService self, Message message  ) {
    {
if (!containsKey(self, "userTags"))       {
        return encodeRpcError(message, const IntConstant(-32602));
      }
      Client client = self.client!;
      List userTags = cast(self, );
      Set tags = toSet(self, );
      Set newTags = difference(self, self._profilerUserTagSubscriptions);
      clear(self, );
      addAll(self, tags);
      addAll(self, tags);
if (self.isNotEmpty)       {
        _addUserTagsToStreamableSampleList(toList(self, ));
      }
      _cleanupUnusedUserTagSubscriptions(self, );
      return encodeSuccess(message);
    }
  }
  
static dynamic _recordInformationAboutCreatedServiceIdZone(VMService self, Client client, Map decodedResponse, String isolateId  ) {
    {
if (containsKey(self, "result"))       {
        add(self, let_expression);
      }
    }
  }
  
static Future routeRequest(VMService self, VMService formal_0, Message message  ) {
    {
      Object response = await _routeRequestImpl(self, message);
if (response == null)       {
assert(self.type == const InstanceConstant(const MessageType{_Enum.index: 1, _Enum._name: "Notification"})        );
        return null;
      }
      return Response.from(response);
    }
  }
  
static Future _routeRequestImpl(VMService self, Message message  ) {
    {
try       {
if (self.completed)         {
          return await self.response;
        }
if (self.method == "_serveObservatory")         {
          let_expression;
          return encodeSuccess(message);
        }
if (self.method == "_yieldControlToDDS")         {
          return await _yieldControlToDDS(self, message);
        }
if (self.method == "streamListen")         {
          return await _streamListen(self, message);
        }
if (self.method == "streamCancel")         {
          return await _streamCancel(self, message);
        }
if (self.method == "registerService")         {
          return await _registerService(self, message);
        }
if (self.method == "getSupportedProtocols")         {
          return await _getSupportedProtocols(self, message);
        }
if (self.method == "streamCpuSamplesWithUserTag")         {
          return await _streamCpuSamplesWithUserTag(self, message);
        }
if (shouldHandleMessage(self, message))         {
          return await handleMessage(self, message);
        }
if (VMService._hasNamespace(self.method!))         {
          return await _handleService(self, message);
        }
if (!getElement(self, "isolateId") == null)         {
          Response response = await routeRequest(self, self, message);
if (self.method == "createIdZone")           {
            _recordInformationAboutCreatedServiceIdZone(self, self.client!, decodeJson(self, ) as Map, getElement(self, "isolateId") as String);
          }
          return response;
        }
        return await sendToVM(self, );
      }
      // TODO: 实现try-catch语句
    }
  }
  
static dynamic routeResponse(VMService self, Message message  ) {
    {
      Client client = self.client!;
if (containsKey(self, self.serial))       {
        functionInvocation(message);
        release(self, self.serial as String);
      }
    }
  }
  
}

/// 转换后的类: Asset
class Asset {
  late String name;
  late Uint8List data;
  
  Asset();
  
static Asset create(String name, Uint8List data  ) {
    final instance = Asset();
    instance.name = name;
    instance.data = data;
    ;
    return instance;
  }
  
static String mimeType(Asset self  ) {
    {
      int extensionStart = lastIndexOf(self, ".");
      String extension = substring(self, add(self, 1));
      // TODO: 实现标签语句
switch (extension) {      // TODO: 实现switch语句
      }
    }
  }
  
static String toString(Asset self  ) {
    return self.name + " (" + self.mimeType + ")";
  }
  
}

/// 转换后的类: Client
class Client {
  late VMService service;
  late bool sendEvents;
  late int _id;
  late Set streams;
  late List createdServiceIdZones;
  late Set profilerUserTagFilters;
  late Map services;
  late Map serviceHandles;
  
  Client();
  
static Client create(VMService service, bool sendEvents  ) {
    final instance = Client();
    instance.service = service;
    instance.sendEvents = sendEvents;
    {
      self._name = self.defaultClientName;
      _addClient(self, self);
    }
    return instance;
  }
  
static String defaultClientName(Client self  ) {
    return "client" + self._id;
  }
  
static String name(Client self  ) {
    return self._name;
  }
  
static dynamic name(Client self, String n  ) {
    return self._name = let_expression;
  }
  
static dynamic close(Client self  ) {
    return _removeClient(self, self);
  }
  
static dynamic onRequest(Client self, Message message  ) {
    return then(self, instance_tearoff);
  }
  
static dynamic onResponse(Client self, Message message  ) {
    return routeResponse(self, message);
  }
  
static dynamic onNotification(Client self, Message message  ) {
    return routeRequest(self, self.service, message);
  }
  
static Map toJson(Client self  ) {
    return {};
  }
  
}

/// 转换后的类: DevFS
class DevFS {
  late Map _fsMap;
  late Set _rpcNames;
  
  DevFS();
  
static DevFS create(  ) {
    final instance = DevFS();
    ;
    return instance;
  }
  
static dynamic cleanup(DevFS self  ) {
    {
      Function deleteDir = self.deleteDir;
if (deleteDir == null)       {
        return Void;
      }
      List deletions = (() {
    List var = _GrowableList.(0);
    {
    Iterator _sync_for_iterator = self.iterator;
    // TODO: 处理语句类型 ForStatement
  }
    return null;
  })();
      Future.wait(deletions);
      clear(self, );
    }
  }
  
static bool shouldHandleMessage(DevFS self, Message message  ) {
    return contains(self, self.method);
  }
  
static Future handleMessage(DevFS self, Message message  ) {
    {
      // TODO: 实现标签语句
switch (self.method!) {      // TODO: 实现switch语句
      }
    }
  }
  
static Future handlePutStream(DevFS self, Object fsName, Object path, Uri fsUri, Stream bytes  ) {
    {
      Message message = Message.create_forMethod("_writeDevFSFile");
      Function writeStreamFile = self.writeStreamFile;
if (writeStreamFile == null)       {
        return _encodeDevFSDisabledError(message);
      }
if (fsName == null)       {
        return encodeMissingParamError(message, "fsName");
      }
if (!fsName is String)       {
        return encodeInvalidParamError(message, "fsName");
      }
      _FileSystem fs = getElement(self, fsName);
if (fs == null)       {
        return _encodeFileSystemDoesNotExistError(message, fsName);
      }
      Uri uri = fsUri;
if (uri == null)       {
if (path == null)         {
          return encodeMissingParamError(message, "path");
        }
if (!path is String)         {
          return encodeInvalidParamError(message, "path");
        }
        uri = resolvePath(self, path);
if (uri == null)         {
          return encodeInvalidParamError(message, "path");
        }
      }
 else       {
        uri = resolve(self, uri);
if (uri == null)         {
          return encodeInvalidParamError(message, "uri");
        }
      }
      await functionInvocation(uri, bytes);
      return encodeSuccess(message);
    }
  }
  
static Future _listDevFS(DevFS self, Message message  ) {
    {
      Map result = {};
      setElement(self, "type", "FileSystemList");
      setElement(self, "fsNames", toList(self, ));
      return encodeResult(message, result);
    }
  }
  
static Future _createDevFS(DevFS self, Message message  ) {
    {
      Function createTempDir = self.createTempDir;
if (createTempDir == null)       {
        return _encodeDevFSDisabledError(message);
      }
      dynamic fsName = getElement(self, "fsName");
if (fsName == null)       {
        return encodeMissingParamError(message, "fsName");
      }
if (!fsName is String)       {
        return encodeInvalidParamError(message, "fsName");
      }
      _FileSystem fs = getElement(self, fsName);
if (!fs == null)       {
        return _encodeFileSystemAlreadyExistsError(message, fsName);
      }
      Uri tempDir = await functionInvocation(fsName);
      fs = _FileSystem.create(fsName, tempDir);
      setElement(self, fsName, fs);
      return encodeResult(message, toMap(self, ));
    }
  }
  
static Future _deleteDevFS(DevFS self, Message message  ) {
    {
      Function deleteDir = self.deleteDir;
if (deleteDir == null)       {
        return _encodeDevFSDisabledError(message);
      }
      dynamic fsName = getElement(self, "fsName");
if (fsName == null)       {
        return encodeMissingParamError(message, "fsName");
      }
if (!fsName is String)       {
        return encodeInvalidParamError(message, "fsName");
      }
      _FileSystem fs = remove(self, fsName);
if (fs == null)       {
        return _encodeFileSystemDoesNotExistError(message, fsName);
      }
      await functionInvocation(self.uri);
      return encodeSuccess(message);
    }
  }
  
static Future _readDevFSFile(DevFS self, Message message  ) {
    {
      Function readFile = self.readFile;
if (readFile == null)       {
        return _encodeDevFSDisabledError(message);
      }
      dynamic fsName = getElement(self, "fsName");
if (fsName == null)       {
        return encodeMissingParamError(message, "fsName");
      }
if (!fsName is String)       {
        return encodeInvalidParamError(message, "fsName");
      }
      _FileSystem fs = getElement(self, fsName);
if (fs == null)       {
        return _encodeFileSystemDoesNotExistError(message, fsName);
      }
      Uri uri;
if (!getElement(self, "uri") == null)       {
try         {
          dynamic uriParam = getElement(self, "uri");
if (!uriParam is String)           {
            return encodeInvalidParamError(message, "uri");
          }
          Uri parsedUri = Uri.parse(uriParam);
          uri = resolve(self, parsedUri);
if (uri == null)           {
            return encodeInvalidParamError(message, "uri");
          }
        }
        // TODO: 实现try-catch语句
      }
 else       {
        dynamic path = getElement(self, "path");
if (path == null)         {
          return encodeMissingParamError(message, "path");
        }
if (!path is String)         {
          return encodeInvalidParamError(message, "path");
        }
        uri = resolvePath(self, path);
if (uri == null)         {
          return encodeInvalidParamError(message, "path");
        }
      }
try       {
        List bytes = await functionInvocation(uri);
        Map result = {"type": "FSFile", "fileContents": encode(self, bytes)};
        return encodeResult(message, result);
      }
      // TODO: 实现try-catch语句
    }
  }
  
static Future _writeDevFSFile(DevFS self, Message message  ) {
    {
      Function writeFile = self.writeFile;
if (writeFile == null)       {
        return _encodeDevFSDisabledError(message);
      }
      dynamic fsName = getElement(self, "fsName");
if (fsName == null)       {
        return encodeMissingParamError(message, "fsName");
      }
if (!fsName is String)       {
        return encodeInvalidParamError(message, "fsName");
      }
      _FileSystem fs = getElement(self, fsName);
if (fs == null)       {
        return _encodeFileSystemDoesNotExistError(message, fsName);
      }
      Uri uri;
if (!getElement(self, "uri") == null)       {
try         {
          dynamic uriParam = getElement(self, "uri");
if (!uriParam is String)           {
            return encodeInvalidParamError(message, "uri");
          }
          Uri parsedUri = Uri.parse(uriParam);
          uri = resolve(self, parsedUri);
if (uri == null)           {
            return encodeInvalidParamError(message, "uri");
          }
        }
        // TODO: 实现try-catch语句
      }
 else       {
        dynamic path = getElement(self, "path");
if (path == null)         {
          return encodeMissingParamError(message, "path");
        }
if (!path is String)         {
          return encodeInvalidParamError(message, "path");
        }
        uri = resolvePath(self, path);
if (uri == null)         {
          return encodeInvalidParamError(message, "path");
        }
      }
      dynamic fileContents = getElement(self, "fileContents");
if (fileContents == null)       {
        return encodeMissingParamError(message, "fileContents");
      }
if (!fileContents is String)       {
        return encodeInvalidParamError(message, "fileContents");
      }
      Uint8List decodedFileContents = decode(self, fileContents);
      await functionInvocation(uri, decodedFileContents);
      return encodeSuccess(message);
    }
  }
  
static Future _writeDevFSFiles(DevFS self, Message message  ) {
    {
      Function writeFile = self.writeFile;
if (writeFile == null)       {
        return _encodeDevFSDisabledError(message);
      }
      dynamic fsName = getElement(self, "fsName");
if (fsName == null)       {
        return encodeMissingParamError(message, "fsName");
      }
if (!fsName is String)       {
        return encodeInvalidParamError(message, "fsName");
      }
      _FileSystem fs = getElement(self, fsName);
if (fs == null)       {
        return _encodeFileSystemDoesNotExistError(message, fsName);
      }
      dynamic files = getElement(self, "files");
if (files == null)       {
        return encodeMissingParamError(message, "files");
      }
if (!files is List)       {
        return encodeInvalidParamError(message, "files");
      }
      List uris = _GrowableList.(0);
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        dynamic fileInfo = getElement(self, i);
if (!fileInfo is List || !self.length == 2 || !getElement(self, 0) is String || !getElement(self, 1) is String)         {
          return encodeRpcError(message, const IntConstant(-32602));
        }
        Uri uri = resolvePath(self, getElement(self, 0) as String);
if (uri == null)         {
          return encodeRpcError(message, const IntConstant(-32602));
        }
        add(self, uri);
      }
      List pendingWrites = _GrowableList.(0);
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        List file = cast(self, );
        Uint8List decodedFileContents = decode(self, getElement(self, 1));
        add(self, functionInvocation(getElement(self, i), decodedFileContents));
      }
      await Future.wait(pendingWrites);
      return encodeSuccess(message);
    }
  }
  
static Future _listDevFSFiles(DevFS self, Message message  ) {
    {
      Function listFiles = self.listFiles;
if (listFiles == null)       {
        return _encodeDevFSDisabledError(message);
      }
      dynamic fsName = getElement(self, "fsName");
if (fsName == null)       {
        return encodeMissingParamError(message, "fsName");
      }
if (!fsName is String)       {
        return encodeInvalidParamError(message, "fsName");
      }
      _FileSystem fs = getElement(self, fsName);
if (fs == null)       {
        return _encodeFileSystemDoesNotExistError(message, fsName);
      }
      List fileList = await functionInvocation(self.uri);
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        setElement(self, "name", Uri.decodeFull(getElement(self, "name") as String));
      }
      Map result = {"type": "FSFileList", "files": fileList};
      return encodeResult(message, result);
    }
  }
  
}

/// 转换后的类: Constants
class Constants {
  Constants();
  
static Constants create(  ) {
    final instance = Constants();
    ;
    return instance;
  }
  
}

/// 转换后的类: RunningIsolate
class RunningIsolate implements MessageRouter {
  late int portId;
  late SendPort sendPort;
  late String name;
  late List pendingMessagesReceivePorts;
  
  RunningIsolate();
  
static RunningIsolate create(int portId, SendPort sendPort, String name  ) {
    final instance = RunningIsolate();
    instance.portId = portId;
    instance.sendPort = sendPort;
    instance.name = name;
    ;
    return instance;
  }
  
static dynamic onIsolateExit(RunningIsolate self  ) {
    {
      forEach(self, (RawReceivePort port) { /* TODO: 实现匿名函数 */ return null as dynamic; });
    }
  }
  
static String serviceId(RunningIsolate self  ) {
    return "isolates/" + self.portId;
  }
  
static Future routeRequest(RunningIsolate self, VMService service, Message message  ) {
    {
      return sendToIsolate(self, self.pendingMessagesReceivePorts, self.sendPort);
    }
  }
  
static dynamic routeResponse(RunningIsolate self, Message message  ) {
    {
    }
  }
  
}

/// 转换后的类: RunningIsolates
class RunningIsolates implements MessageRouter {
  late Map isolates;
  
  RunningIsolates();
  
static RunningIsolates create(  ) {
    final instance = RunningIsolates();
    ;
    return instance;
  }
  
static dynamic isolateStartup(RunningIsolates self, int portId, SendPort sp, String name  ) {
    {
if (self._rootPortId == null)       {
        self._rootPortId = portId;
      }
      RunningIsolate ri = RunningIsolate.create(portId, sp, name);
      setElement(self, portId, ri);
    }
  }
  
static dynamic isolateShutdown(RunningIsolates self, int portId, SendPort sp  ) {
    {
if (self._rootPortId == portId)       {
        self._rootPortId = null;
      }
      let_expression;
    }
  }
  
static Future _handleReloadSourcesRequest(RunningIsolates self, VMService service, Message message, RunningIsolate isolate  ) {
    {
if (functionInvocation() == null)       {
        return routeRequest(self, service, message);
      }
 else       {
        String rootLibUri;
if (getElement(self, const StringConstant("rootLibUri")) == null)         {
          Message getIsolateRequest = Message.create_forMethod("getIsolate");
          setElement(self, const StringConstant("isolateId"), getElement(self, self.serviceId));
          Response getIsolateResponse = await routeRequest(self, service, getIsolateRequest);
          Map isolateJson = getElement(self, "result") as Map;
          Map rootLibJson = getElement(self, "rootLib") as Map;
          rootLibUri = getElement(self, "uri") as String;
        }
 else         {
          rootLibUri = getElement(self, const StringConstant("rootLibUri")) as String;
        }
        Directory tempDirectory = createTempSync(self, );
        File outputDill = File.(self.path + self.pathSeparator + "for_hot_reload.dill");
        Map responseFromResidentCompiler = await _sendRequestToResidentFrontendCompilerAndRecieveResponse(jsonEncode({"command": "compile", const StringConstant("useCachedCompilerOptionsAsBase"): true, "executable": toFilePath(self, ), "output-dill": self.path}), functionInvocation()!);
if (getElement(self, const StringConstant("success")) == false)         {
          return Response.from(encodeRpcError(message, const IntConstant(-32603)));
        }
        Message reloadKernelRequest = Message.create_forMethod("_reloadKernel");
        setElement(self, const StringConstant("isolateId"), getElement(self, self.serviceId));
        setElement(self, "kernelFilePath", toFilePath(self, ));
        Future response = routeRequest(self, service, message);
        deleteSync(self, );
        return response;
      }
    }
  }
  
static Future routeRequest(RunningIsolates self, VMService service, Message message  ) {
    {
      String isolateParam = getElement(self, "isolateId")! as String;
      int isolateId;
if (!startsWith(self, "isolates/"))       {
        setErrorResponse(self, const IntConstant(-32602), "invalid 'isolateId' parameter: " + isolateParam);
        return self.response;
      }
      isolateParam = substring(self, self.length);
if (isolateParam == "root")       {
        isolateId = self._rootPortId!;
      }
 else       {
try         {
          isolateId = int.parse(isolateParam);
        }
        // TODO: 实现try-catch语句
      }
      RunningIsolate isolate = getElement(self, isolateId);
if (isolate == null)       {
        Map result = {"type": "Sentinel", "kind": "Collected", "valueAsString": "<collected>"};
        setResponse(self, encodeResult(message, result));
        return self.response;
      }
if (self.method == "evaluateInFrame" || self.method == "evaluate")       {
        return run(self, );
      }
 else if (self.method == "reloadSources")       {
        return _handleReloadSourcesRequest(self, service, message, isolate);
      }
 else       {
        return routeRequest(self, service, message);
      }
    }
  }
  
static dynamic routeResponse(RunningIsolates self, Message message  ) {
    {
    }
  }
  
}

/// 转换后的类: MessageType
class MessageType extends _Enum {
  MessageType();
  
static MessageType create(int _index, String _name  ) {
    final instance = MessageType();
    ;
    return instance;
  }
  
static String _enumToString(MessageType self  ) {
    return "MessageType." + self._name;
  }
  
}

/// 转换后的类: Message
class Message {
  late Completer _completer;
  late MessageType type;
  late Object serial;
  late String method;
  late Map params;
  late Map result;
  late Map error;
  
  Message();
  
static Message create__fromJsonRpcRequest(Client client, Map map  ) {
    final instance = Message();
    instance.client = client;
    instance.type = const InstanceConstant(const MessageType{_Enum.index: 0, _Enum._name: "Request"});
    instance.serial = getElement(self, "id");
    instance.method = getElement(self, "method") as String;
    {
if (!getElement(self, "params") == null)       {
        addAll(self, getElement(self, "params") as Map);
      }
    }
    return instance;
  }
  
static Message create__fromJsonRpcNotification(Client client, Map map  ) {
    final instance = Message();
    instance.client = client;
    instance.type = const InstanceConstant(const MessageType{_Enum.index: 1, _Enum._name: "Notification"});
    instance.method = getElement(self, "method") as String;
    instance.serial = null;
    {
if (!getElement(self, "params") == null)       {
        addAll(self, getElement(self, "params") as Map);
      }
    }
    return instance;
  }
  
static Message create__fromJsonRpcResult(Client client, Map map  ) {
    final instance = Message();
    instance.client = client;
    instance.type = const InstanceConstant(const MessageType{_Enum.index: 2, _Enum._name: "Response"});
    instance.serial = getElement(self, "id");
    instance.method = null;
    {
      addAll(self, getElement(self, "result") as Map);
    }
    return instance;
  }
  
static Message create__fromJsonRpcError(Client client, Map map  ) {
    final instance = Message();
    instance.client = client;
    instance.type = const InstanceConstant(const MessageType{_Enum.index: 2, _Enum._name: "Response"});
    instance.serial = getElement(self, "id");
    instance.method = null;
    {
      addAll(self, getElement(self, "error") as Map);
    }
    return instance;
  }
  
static Message create_forMethod(String method  ) {
    final instance = Message();
    instance.client = null;
    instance.method = method;
    instance.type = const InstanceConstant(const MessageType{_Enum.index: 0, _Enum._name: "Request"});
    instance.serial = "";
    ;
    return instance;
  }
  
static Message create_fromUri(Client client, Uri uri  ) {
    final instance = Message();
    instance.client = client;
    instance.type = const InstanceConstant(const MessageType{_Enum.index: 0, _Enum._name: "Request"});
    instance.serial = "";
    instance.method = Message._methodNameFromUri(uri);
    {
      addAll(self, self.queryParameters);
    }
    return instance;
  }
  
static Message create_forIsolate(Client client, Uri uri, RunningIsolate isolate  ) {
    final instance = Message();
    instance.client = client;
    instance.type = const InstanceConstant(const MessageType{_Enum.index: 0, _Enum._name: "Request"});
    instance.serial = "";
    instance.method = Message._methodNameFromUri(uri);
    {
      addAll(self, self.queryParameters);
      setElement(self, "isolateId", self.serviceId);
    }
    return instance;
  }
  
static bool completed(Message self  ) {
    return self.isCompleted;
  }
  
static Future response(Message self  ) {
    return self.future;
  }
  
static Uri toUri(Message self  ) {
    return _Uri.();
  }
  
static dynamic toJson(Message self  ) {
    return throw "unsupported";
  }
  
static Map forwardToJson(Message self, Map overloads  ) {
    {
      Map json = {"jsonrpc": "2.0", "id": self.serial};
      // TODO: 实现标签语句
switch (self.type) {      // TODO: 实现switch语句
      }
if (!overloads == null)       {
        addAll(self, overloads);
      }
      return json;
    }
  }
  
static List _makeAllString(Message self, List list  ) {
    {
      List new_list = _List.filled(self.length, "");
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        setElement(self, i, toString(self, ));
      }
      return new_list;
    }
  }
  
static Future sendToIsolate(Message self, List ports, SendPort sendPort  ) {
    {
      RawReceivePort receivePort = RawReceivePort.(null, "Isolate Message");
      add(self, receivePort);
      self.handler = (dynamic value) { /* TODO: 实现匿名函数 */ return null as Null; };
      List keys = _makeAllString(self, toList(self, ));
      List values = _makeAllString(self, toList(self, ));
      List request = let_expression;
if (!sendIsolateServiceMessage(sendPort, request))       {
        close(self, );
        remove(self, receivePort);
        complete(self, Response.internalError("could not send message [" + self.serial + "] to isolate"));
      }
      return self.future;
    }
  }
  
static bool _methodNeedsObjectParameters(Message self, String method  ) {
    {
      // TODO: 实现标签语句
switch (method) {      // TODO: 实现switch语句
      }
    }
  }
  
static Future sendToVM(Message self  ) {
    {
      RawReceivePort receivePort = RawReceivePort.(null, "VM Message");
      self.handler = (dynamic value) { /* TODO: 实现匿名函数 */ return null as Null; };
      List keys = toList(self, );
      List values = toList(self, );
if (!_methodNeedsObjectParameters(self, self.method!))       {
        keys = _makeAllString(self, keys);
        values = _makeAllString(self, values);
      }
      List request = let_expression;
if (_methodNeedsObjectParameters(self, self.method!))       {
        sendObjectRootServiceMessage(request);
      }
 else       {
        sendRootServiceMessage(request);
      }
      return self.future;
    }
  }
  
static dynamic _setResponseFromPort(Message self, Object response  ) {
    {
if (response == null)       {
assert(self.type == const InstanceConstant(const MessageType{_Enum.index: 1, _Enum._name: "Notification"})        );
        return null;
      }
      complete(self, Response.from(response));
    }
  }
  
static dynamic setResponse(Message self, String response  ) {
    return complete(self, Response.create(const InstanceConstant(const ResponsePayloadKind{_Enum.index: 0, _Enum._name: "String"}), response));
  }
  
static dynamic setErrorResponse(Message self, int code, String details  ) {
    return setResponse(self, encodeRpcError(self, code));
  }
  
}

/// 转换后的类: MessageRouter
class MessageRouter {
  MessageRouter();
  
static MessageRouter create(  ) {
    final instance = MessageRouter();
    ;
    return instance;
  }
  
}

/// 转换后的类: ResponsePayloadKind
class ResponsePayloadKind extends _Enum {
  ResponsePayloadKind();
  
static ResponsePayloadKind create(int _index, String _name  ) {
    final instance = ResponsePayloadKind();
    ;
    return instance;
  }
  
static String _enumToString(ResponsePayloadKind self  ) {
    return "ResponsePayloadKind." + self._name;
  }
  
}

/// 转换后的类: Response
class Response {
  late ResponsePayloadKind kind;
  late dynamic payload;
  
  Response();
  
static Response create(ResponsePayloadKind kind, dynamic payload  ) {
    final instance = Response();
    instance.kind = kind;
    instance.payload = payload;
    {
assert(functionInvocation()      );
    }
    return instance;
  }
  
static Response create_json(Object value  ) {
    final instance = Response();
    ;
    return instance;
  }
  
static dynamic decodeJson(Response self  ) {
    {
      // TODO: 实现标签语句
switch (self.kind) {      // TODO: 实现switch语句
      }
    }
  }
  
}

/// 转换后的类: NamedLookup
class NamedLookup extends Iterable {
  late IdGenerator _generator;
  late Map _elements;
  late Map _ids;
  
  NamedLookup();
  
static NamedLookup create(String prologue  ) {
    final instance = NamedLookup();
    instance._generator = IdGenerator.create();
    ;
    return instance;
  }
  
static dynamic add(NamedLookup self, dynamic e  ) {
    {
      String id = newId(self, );
      setElement(self, id, e);
      setElement(self, e, id);
    }
  }
  
static dynamic remove(NamedLookup self, dynamic e  ) {
    {
      String id = remove(self, e)!;
      remove(self, id);
      release(self, id);
    }
  }
  
static String keyOf(NamedLookup self, dynamic e  ) {
    return getElement(self, e)!;
  }
  
static Iterator iterator(NamedLookup self  ) {
    return self.iterator;
  }
  
static dynamic getElement(NamedLookup self, String id  ) {
    return getElement(self, id)!;
  }
  
}

/// 转换后的类: IdGenerator
class IdGenerator {
  late String prologue;
  late Set _used;
  late Set _free;
  
  IdGenerator();
  
static IdGenerator create(String prologue  ) {
    final instance = IdGenerator();
    instance.prologue = prologue;
    ;
    return instance;
  }
  
static String newId(IdGenerator self  ) {
    {
      String id;
if (self.isEmpty)       {
        id = +(self, toString(self, ));
      }
 else       {
        id = self.first;
      }
      remove(self, id);
      add(self, id);
      return id;
    }
  }
  
static dynamic release(IdGenerator self, String id  ) {
    {
if (remove(self, id))       {
        add(self, id);
      }
    }
  }
  
}

/// 转换后的类: NativeFieldWrapperClass1
class NativeFieldWrapperClass1 {
  NativeFieldWrapperClass1();
  
static NativeFieldWrapperClass1 create(  ) {
    final instance = NativeFieldWrapperClass1();
    ;
    return instance;
  }
  
}

/// 转换后的类: NativeFieldWrapperClass2
class NativeFieldWrapperClass2 extends NativeFieldWrapperClass1 {
  NativeFieldWrapperClass2();
  
static NativeFieldWrapperClass2 create(  ) {
    final instance = NativeFieldWrapperClass2();
    ;
    return instance;
  }
  
}

/// 转换后的类: NativeFieldWrapperClass3
class NativeFieldWrapperClass3 extends NativeFieldWrapperClass2 {
  NativeFieldWrapperClass3();
  
static NativeFieldWrapperClass3 create(  ) {
    final instance = NativeFieldWrapperClass3();
    ;
    return instance;
  }
  
}

/// 转换后的类: NativeFieldWrapperClass4
class NativeFieldWrapperClass4 extends NativeFieldWrapperClass3 {
  NativeFieldWrapperClass4();
  
static NativeFieldWrapperClass4 create(  ) {
    final instance = NativeFieldWrapperClass4();
    ;
    return instance;
  }
  
}

/// 转换后的类: IOException
class IOException implements Exception {
  IOException();
  
static IOException create(  ) {
    final instance = IOException();
    ;
    return instance;
  }
  
static String toString(IOException self  ) {
    return "IOException";
  }
  
}

/// 转换后的类: OSError
class OSError implements Exception {
  late String message;
  late int errorCode;
  
  OSError();
  
static OSError create(String message, int errorCode  ) {
    final instance = OSError();
    instance.message = message;
    instance.errorCode = errorCode;
    ;
    return instance;
  }
  
static String toString(OSError self  ) {
    {
      StringBuffer sb = StringBuffer.create();
      write(self, "OS Error");
if (self.isNotEmpty)       {
        let_expression;
if (!self.errorCode == const IntConstant(-1))         {
          let_expression;
        }
      }
 else if (!self.errorCode == const IntConstant(-1))       {
        let_expression;
      }
      return toString(self, );
    }
  }
  
}

/// 转换后的类: ZLibOption
class ZLibOption {
  ZLibOption();
  
static ZLibOption create(  ) {
    final instance = ZLibOption();
    ;
    return instance;
  }
  
}

/// 转换后的类: ZLibCodec
class ZLibCodec extends Codec {
  late bool gzip;
  late int level;
  late int memLevel;
  late int strategy;
  late int windowBits;
  late bool raw;
  late List dictionary;
  
  ZLibCodec();
  
static ZLibCodec create(int level, int windowBits, int memLevel, int strategy, List dictionary, bool raw, bool gzip  ) {
    final instance = ZLibCodec();
    instance.level = level;
    instance.windowBits = windowBits;
    instance.memLevel = memLevel;
    instance.strategy = strategy;
    instance.dictionary = dictionary;
    instance.raw = raw;
    instance.gzip = gzip;
    {
      _validateZLibeLevel(self.level);
      _validateZLibMemLevel(self.memLevel);
      _validateZLibStrategy(self.strategy);
      _validateZLibWindowBits(self.windowBits);
    }
    return instance;
  }
  
static ZLibCodec create__default(  ) {
    final instance = ZLibCodec();
    instance.level = const IntConstant(6);
    instance.windowBits = const IntConstant(15);
    instance.memLevel = const IntConstant(8);
    instance.strategy = const IntConstant(0);
    instance.raw = false;
    instance.gzip = false;
    instance.dictionary = null;
    ;
    return instance;
  }
  
static ZLibEncoder encoder(ZLibCodec self  ) {
    return ZLibEncoder.create();
  }
  
static ZLibDecoder decoder(ZLibCodec self  ) {
    return ZLibDecoder.create();
  }
  
}

/// 转换后的类: GZipCodec
class GZipCodec extends Codec {
  late bool gzip;
  late int level;
  late int memLevel;
  late int strategy;
  late int windowBits;
  late List dictionary;
  late bool raw;
  
  GZipCodec();
  
static GZipCodec create(int level, int windowBits, int memLevel, int strategy, List dictionary, bool raw, bool gzip  ) {
    final instance = GZipCodec();
    instance.level = level;
    instance.windowBits = windowBits;
    instance.memLevel = memLevel;
    instance.strategy = strategy;
    instance.dictionary = dictionary;
    instance.raw = raw;
    instance.gzip = gzip;
    {
      _validateZLibeLevel(self.level);
      _validateZLibMemLevel(self.memLevel);
      _validateZLibStrategy(self.strategy);
      _validateZLibWindowBits(self.windowBits);
    }
    return instance;
  }
  
static GZipCodec create__default(  ) {
    final instance = GZipCodec();
    instance.level = const IntConstant(6);
    instance.windowBits = const IntConstant(15);
    instance.memLevel = const IntConstant(8);
    instance.strategy = const IntConstant(0);
    instance.raw = false;
    instance.gzip = true;
    instance.dictionary = null;
    ;
    return instance;
  }
  
static ZLibEncoder encoder(GZipCodec self  ) {
    return ZLibEncoder.create();
  }
  
static ZLibDecoder decoder(GZipCodec self  ) {
    return ZLibDecoder.create();
  }
  
}

/// 转换后的类: ZLibEncoder
class ZLibEncoder extends Converter {
  late bool gzip;
  late int level;
  late int memLevel;
  late int strategy;
  late int windowBits;
  late List dictionary;
  late bool raw;
  
  ZLibEncoder();
  
static ZLibEncoder create(bool gzip, int level, int windowBits, int memLevel, int strategy, List dictionary, bool raw  ) {
    final instance = ZLibEncoder();
    instance.gzip = gzip;
    instance.level = level;
    instance.windowBits = windowBits;
    instance.memLevel = memLevel;
    instance.strategy = strategy;
    instance.dictionary = dictionary;
    instance.raw = raw;
    {
      _validateZLibeLevel(self.level);
      _validateZLibMemLevel(self.memLevel);
      _validateZLibStrategy(self.strategy);
      _validateZLibWindowBits(self.windowBits);
    }
    return instance;
  }
  
static List convert(ZLibEncoder self, List bytes  ) {
    {
      _BufferSink sink = _BufferSink.create();
      let_expression;
      return takeBytes(self, );
    }
  }
  
static ByteConversionSink startChunkedConversion(ZLibEncoder self, Sink sink  ) {
    {
if (!sink is ByteConversionSink)       {
        sink = _ByteAdapterSink.create(sink);
      }
      return _ZLibEncoderSink.create__(sink, self.gzip, self.level, self.windowBits, self.memLevel, self.strategy, self.dictionary, self.raw);
    }
  }
  
}

/// 转换后的类: ZLibDecoder
class ZLibDecoder extends Converter {
  late bool gzip;
  late int windowBits;
  late List dictionary;
  late bool raw;
  
  ZLibDecoder();
  
static ZLibDecoder create(bool gzip, int windowBits, List dictionary, bool raw  ) {
    final instance = ZLibDecoder();
    instance.gzip = gzip;
    instance.windowBits = windowBits;
    instance.dictionary = dictionary;
    instance.raw = raw;
    {
      _validateZLibWindowBits(self.windowBits);
    }
    return instance;
  }
  
static List convert(ZLibDecoder self, List bytes  ) {
    {
      _BufferSink sink = _BufferSink.create();
      let_expression;
      return takeBytes(self, );
    }
  }
  
static ByteConversionSink startChunkedConversion(ZLibDecoder self, Sink sink  ) {
    {
if (!sink is ByteConversionSink)       {
        sink = _ByteAdapterSink.create(sink);
      }
      return _ZLibDecoderSink.create__(sink, self.gzip, self.windowBits, self.dictionary, self.raw);
    }
  }
  
}

/// 转换后的类: RawZLibFilter
class RawZLibFilter {
  RawZLibFilter();
  
}

/// 转换后的类: Directory
class Directory implements FileSystemEntity {
  Directory();
  
}

/// 转换后的类: FileMode
class FileMode {
  late int _mode;
  
  FileMode();
  
static FileMode create__internal(int _mode  ) {
    final instance = FileMode();
    instance._mode = _mode;
    ;
    return instance;
  }
  
}

/// 转换后的类: FileLock
class FileLock {
  late int _type;
  
  FileLock();
  
static FileLock create__internal(int _type  ) {
    final instance = FileLock();
    instance._type = _type;
    ;
    return instance;
  }
  
}

/// 转换后的类: File
class File implements FileSystemEntity {
  File();
  
}

/// 转换后的类: RandomAccessFile
class RandomAccessFile {
  RandomAccessFile();
  
static RandomAccessFile create(  ) {
    final instance = RandomAccessFile();
    ;
    return instance;
  }
  
}

/// 转换后的类: FileSystemException
class FileSystemException implements IOException {
  late String message;
  late String path;
  late OSError osError;
  
  FileSystemException();
  
static FileSystemException create(String message, String path, OSError osError  ) {
    final instance = FileSystemException();
    instance.message = message;
    instance.path = path;
    instance.osError = osError;
    ;
    return instance;
  }
  
static String _toStringHelper(FileSystemException self, String className  ) {
    {
      StringBuffer sb = StringBuffer.create();
      write(self, className);
if (self.isNotEmpty)       {
        write(self, ": " + self.message);
if (!self.path == null)         {
          write(self, ", path = '" + self.path + "'");
        }
if (!self.osError == null)         {
          write(self, " (" + self.osError + ")");
        }
      }
 else if (!self.osError == null)       {
        write(self, ": " + self.osError);
if (!self.path == null)         {
          write(self, ", path = '" + self.path + "'");
        }
      }
 else if (!self.path == null)       {
        write(self, ": " + self.path);
      }
      return toString(self, );
    }
  }
  
static String toString(FileSystemException self  ) {
    {
      return _toStringHelper(self, "FileSystemException");
    }
  }
  
}

/// 转换后的类: PathAccessException
class PathAccessException extends FileSystemException {
  PathAccessException();
  
static PathAccessException create(String path, OSError osError, String message  ) {
    final instance = PathAccessException();
    ;
    return instance;
  }
  
static String toString(PathAccessException self  ) {
    return _toStringHelper(self, "PathAccessException");
  }
  
}

/// 转换后的类: PathExistsException
class PathExistsException extends FileSystemException {
  PathExistsException();
  
static PathExistsException create(String path, OSError osError, String message  ) {
    final instance = PathExistsException();
    ;
    return instance;
  }
  
static String toString(PathExistsException self  ) {
    return _toStringHelper(self, "PathExistsException");
  }
  
}

/// 转换后的类: PathNotFoundException
class PathNotFoundException extends FileSystemException {
  PathNotFoundException();
  
static PathNotFoundException create(String path, OSError osError, String message  ) {
    final instance = PathNotFoundException();
    ;
    return instance;
  }
  
static String toString(PathNotFoundException self  ) {
    return _toStringHelper(self, "PathNotFoundException");
  }
  
}

/// 转换后的类: ReadPipe
class ReadPipe implements Stream {
  ReadPipe();
  
static ReadPipe create(  ) {
    final instance = ReadPipe();
    ;
    return instance;
  }
  
}

/// 转换后的类: WritePipe
class WritePipe implements IOSink {
  WritePipe();
  
static WritePipe create(  ) {
    final instance = WritePipe();
    ;
    return instance;
  }
  
}

/// 转换后的类: Pipe
class Pipe {
  Pipe();
  
}

/// 转换后的类: FileSystemEntityType
class FileSystemEntityType {
  late int _type;
  
  FileSystemEntityType();
  
static FileSystemEntityType create__internal(int _type  ) {
    final instance = FileSystemEntityType();
    instance._type = _type;
    ;
    return instance;
  }
  
static String toString(FileSystemEntityType self  ) {
    return getElement(self, self._type);
  }
  
}

/// 转换后的类: FileStat
class FileStat {
  late DateTime changed;
  late DateTime modified;
  late DateTime accessed;
  late FileSystemEntityType type;
  late int mode;
  late int size;
  
  FileStat();
  
static FileStat create__internal(DateTime changed, DateTime modified, DateTime accessed, FileSystemEntityType type, int mode, int size  ) {
    final instance = FileStat();
    instance.changed = changed;
    instance.modified = modified;
    instance.accessed = accessed;
    instance.type = type;
    instance.mode = mode;
    instance.size = size;
    ;
    return instance;
  }
  
static String toString(FileStat self  ) {
    return "FileStat: type " + self.type + "
          changed " + self.changed + "
          modified " + self.modified + "
          accessed " + self.accessed + "
          mode " + modeString(self, ) + "
          size " + self.size;
  }
  
static String modeString(FileStat self  ) {
    {
      int permissions = bitwiseAnd(self, 4095);
      List codes = const ListConstant(const <String>["---", "--x", "-w-", "-wx", "r--", "r-x", "rw-", "rwx"]);
      List result = _GrowableList.(0);
if (!bitwiseAnd(self, 2048) == 0)       add(self, "(suid) ");
if (!bitwiseAnd(self, 1024) == 0)       add(self, "(guid) ");
if (!bitwiseAnd(self, 512) == 0)       add(self, "(sticky) ");
      let_expression;
      return join(self, );
    }
  }
  
}

/// 转换后的类: FileSystemEntity
class FileSystemEntity {
  FileSystemEntity();
  
static FileSystemEntity create(  ) {
    final instance = FileSystemEntity();
    ;
    return instance;
  }
  
static Uri uri(FileSystemEntity self  ) {
    return _Uri.file(self.path);
  }
  
static Future resolveSymbolicLinks(FileSystemEntity self  ) {
    {
      return then(self, (Object response) { /* TODO: 实现匿名函数 */ return null as String; });
    }
  }
  
static String resolveSymbolicLinksSync(FileSystemEntity self  ) {
    {
      dynamic result = FileSystemEntity._resolveSymbolicLinks(self._namespace, self._rawPath);
      FileSystemEntity._throwIfError(let_expression, "Cannot resolve symbolic links", self.path);
      return result as String;
    }
  }
  
static Future stat(FileSystemEntity self  ) {
    return FileStat.stat(self.path);
  }
  
static FileStat statSync(FileSystemEntity self  ) {
    return FileStat.statSync(self.path);
  }
  
static Future delete(FileSystemEntity self, bool recursive  ) {
    return _delete(self, );
  }
  
static dynamic deleteSync(FileSystemEntity self, bool recursive  ) {
    return _deleteSync(self, );
  }
  
static Stream watch(FileSystemEntity self, int events, bool recursive  ) {
    {
      String trimmedPath = FileSystemEntity._trimTrailingPathSeparators(self.path);
      IOOverrides overrides = self.current;
if (overrides == null)       {
        return _FileSystemWatcher._watch(trimmedPath, events, recursive);
      }
      return fsWatch(self, trimmedPath, events, recursive);
    }
  }
  
static bool isAbsolute(FileSystemEntity self  ) {
    return FileSystemEntity._isAbsolute(self.path);
  }
  
static String _absolutePath(FileSystemEntity self  ) {
    {
if (self.isAbsolute)       return self.path;
if (self.isWindows)       return FileSystemEntity._absoluteWindowsPath(self.path);
      String current = self.path;
if (endsWith(self, "/"))       {
        return current + self.path;
      }
 else       {
        return current + self.pathSeparator + self.path;
      }
    }
  }
  
static Directory parent(FileSystemEntity self  ) {
    return Directory.(FileSystemEntity.parentOf(self.path));
  }
  
}

/// 转换后的类: FileSystemEvent
class FileSystemEvent {
  late int type;
  late String path;
  late bool isDirectory;
  
  FileSystemEvent();
  
static FileSystemEvent create__(int type, String path, bool isDirectory  ) {
    final instance = FileSystemEvent();
    instance.type = type;
    instance.path = path;
    instance.isDirectory = isDirectory;
    ;
    return instance;
  }
  
}

/// 转换后的类: FileSystemCreateEvent
class FileSystemCreateEvent extends FileSystemEvent {
  FileSystemCreateEvent();
  
static FileSystemCreateEvent create(String path, bool isDirectory  ) {
    final instance = FileSystemCreateEvent();
    ;
    return instance;
  }
  
static String toString(FileSystemCreateEvent self  ) {
    return "FileSystemCreateEvent('" + self.path + "', isDirectory=" + self.isDirectory + ")";
  }
  
}

/// 转换后的类: FileSystemModifyEvent
class FileSystemModifyEvent extends FileSystemEvent {
  late bool contentChanged;
  
  FileSystemModifyEvent();
  
static FileSystemModifyEvent create(String path, bool isDirectory, bool contentChanged  ) {
    final instance = FileSystemModifyEvent();
    instance.contentChanged = contentChanged;
    ;
    return instance;
  }
  
static String toString(FileSystemModifyEvent self  ) {
    return "FileSystemModifyEvent('" + self.path + "', isDirectory=" + self.isDirectory + ", " + "contentChanged=" + self.contentChanged + ")";
  }
  
}

/// 转换后的类: FileSystemDeleteEvent
class FileSystemDeleteEvent extends FileSystemEvent {
  FileSystemDeleteEvent();
  
static FileSystemDeleteEvent create(String path, bool isDirectory  ) {
    final instance = FileSystemDeleteEvent();
    ;
    return instance;
  }
  
static String toString(FileSystemDeleteEvent self  ) {
    return "FileSystemDeleteEvent('" + self.path + "')";
  }
  
static bool isDirectory(FileSystemDeleteEvent self  ) {
    return false;
  }
  
}

/// 转换后的类: FileSystemMoveEvent
class FileSystemMoveEvent extends FileSystemEvent {
  late String destination;
  
  FileSystemMoveEvent();
  
static FileSystemMoveEvent create(String path, bool isDirectory, String destination  ) {
    final instance = FileSystemMoveEvent();
    instance.destination = destination;
    ;
    return instance;
  }
  
static String toString(FileSystemMoveEvent self  ) {
    return "FileSystemMoveEvent('" + self.path + "', " + "isDirectory=" + self.isDirectory + ", destination=" + self.destination + ")";
  }
  
}

/// 转换后的类: IOSink
class IOSink implements StreamSink, StringSink {
  IOSink();
  
}

/// 转换后的类: Link
class Link implements FileSystemEntity {
  Link();
  
}

/// 转换后的类: IOOverrides
class IOOverrides {
  IOOverrides();
  
static IOOverrides create(  ) {
    final instance = IOOverrides();
    ;
    return instance;
  }
  
static Directory createDirectory(IOOverrides self, String path  ) {
    return _Directory.create(path);
  }
  
static Directory getCurrentDirectory(IOOverrides self  ) {
    return self.current;
  }
  
static dynamic setCurrentDirectory(IOOverrides self, String path  ) {
    {
      self.current = path;
    }
  }
  
static Directory getSystemTempDirectory(IOOverrides self  ) {
    return self.systemTemp;
  }
  
static File createFile(IOOverrides self, String path  ) {
    return _File.create(path);
  }
  
static Future stat(IOOverrides self, String path  ) {
    {
      return FileStat._stat(path);
    }
  }
  
static FileStat statSync(IOOverrides self, String path  ) {
    {
      return FileStat._statSyncInternal(path);
    }
  }
  
static Future fseIdentical(IOOverrides self, String path1, String path2  ) {
    {
      return FileSystemEntity._identical(path1, path2);
    }
  }
  
static bool fseIdenticalSync(IOOverrides self, String path1, String path2  ) {
    {
      return FileSystemEntity._identicalSync(path1, path2);
    }
  }
  
static Future fseGetType(IOOverrides self, String path, bool followLinks  ) {
    {
      return FileSystemEntity._getTypeRequest(encode(self, path), followLinks);
    }
  }
  
static FileSystemEntityType fseGetTypeSync(IOOverrides self, String path, bool followLinks  ) {
    {
      return FileSystemEntity._getTypeSyncHelper(encode(self, path), followLinks);
    }
  }
  
static Stream fsWatch(IOOverrides self, String path, int events, bool recursive  ) {
    {
      return _FileSystemWatcher._watch(path, events, recursive);
    }
  }
  
static bool fsWatchIsSupported(IOOverrides self  ) {
    return self.isSupported;
  }
  
static Link createLink(IOOverrides self, String path  ) {
    return _Link.create(path);
  }
  
static Future socketConnect(IOOverrides self, dynamic host, int port, dynamic sourceAddress, int sourcePort, Duration timeout  ) {
    {
      return Socket._connect(host, port);
    }
  }
  
static Future socketStartConnect(IOOverrides self, dynamic host, int port, dynamic sourceAddress, int sourcePort  ) {
    {
      return Socket._startConnect(host, port);
    }
  }
  
static Future serverSocketBind(IOOverrides self, dynamic address, int port, int backlog, bool v6Only, bool shared  ) {
    {
      return ServerSocket._bind(address, port);
    }
  }
  
static Stdin stdin(IOOverrides self  ) {
    {
      return self._stdin;
    }
  }
  
static Stdout stdout(IOOverrides self  ) {
    {
      return self._stdout;
    }
  }
  
static Stdout stderr(IOOverrides self  ) {
    {
      return self._stderr;
    }
  }
  
}

/// 转换后的类: Platform
class Platform {
  Platform();
  
static Platform create(  ) {
    final instance = Platform();
    ;
    return instance;
  }
  
}

/// 转换后的类: ProcessInfo
class ProcessInfo {
  ProcessInfo();
  
static ProcessInfo create(  ) {
    final instance = ProcessInfo();
    ;
    return instance;
  }
  
}

/// 转换后的类: ProcessStartMode
class ProcessStartMode {
  late int _mode;
  
  ProcessStartMode();
  
static ProcessStartMode create__internal(int _mode  ) {
    final instance = ProcessStartMode();
    instance._mode = _mode;
    ;
    return instance;
  }
  
static String toString(ProcessStartMode self  ) {
    return getElement(self, self._mode);
  }
  
}

/// 转换后的类: Process
class Process {
  Process();
  
static Process create(  ) {
    final instance = Process();
    ;
    return instance;
  }
  
}

/// 转换后的类: ProcessResult
class ProcessResult {
  late int exitCode;
  late dynamic stdout;
  late dynamic stderr;
  late int pid;
  
  ProcessResult();
  
static ProcessResult create(int pid, int exitCode, dynamic stdout, dynamic stderr  ) {
    final instance = ProcessResult();
    instance.pid = pid;
    instance.exitCode = exitCode;
    instance.stdout = stdout;
    instance.stderr = stderr;
    ;
    return instance;
  }
  
}

/// 转换后的类: ProcessSignal
class ProcessSignal {
  late int signalNumber;
  late String name;
  
  ProcessSignal();
  
static ProcessSignal create__(int signalNumber, String name  ) {
    final instance = ProcessSignal();
    instance.signalNumber = signalNumber;
    instance.name = name;
    ;
    return instance;
  }
  
static String toString(ProcessSignal self  ) {
    return self.name;
  }
  
static Stream watch(ProcessSignal self  ) {
    return _ProcessUtils._watchSignal(self);
  }
  
}

/// 转换后的类: SignalException
class SignalException implements IOException {
  late String message;
  late dynamic osError;
  
  SignalException();
  
static SignalException create(String message, dynamic osError  ) {
    final instance = SignalException();
    instance.message = message;
    instance.osError = osError;
    ;
    return instance;
  }
  
static String toString(SignalException self  ) {
    {
      String msg = "";
if (!self.osError == null)       {
        msg = ", osError: " + self.osError;
      }
      return "SignalException: " + self.message + msg;
    }
  }
  
}

/// 转换后的类: ProcessException
class ProcessException implements IOException {
  late String executable;
  late List arguments;
  late String message;
  late int errorCode;
  
  ProcessException();
  
static ProcessException create(String executable, List arguments, String message, int errorCode  ) {
    final instance = ProcessException();
    instance.executable = executable;
    instance.arguments = arguments;
    instance.message = message;
    instance.errorCode = errorCode;
    ;
    return instance;
  }
  
static String toString(ProcessException self  ) {
    {
      String args = join(self, " ");
      return "ProcessException: " + self.message + "
  Command: " + self.executable + " " + args;
    }
  }
  
}

/// 转换后的类: SecureServerSocket
class SecureServerSocket extends Stream implements ServerSocketBase {
  late RawSecureServerSocket _socket;
  
  SecureServerSocket();
  
static SecureServerSocket create__(RawSecureServerSocket _socket  ) {
    final instance = SecureServerSocket();
    instance._socket = _socket;
    ;
    return instance;
  }
  
static StreamSubscription listen(SecureServerSocket self, Function onData, Function onError, Function onDone, bool cancelOnError  ) {
    {
      return listen(self, onData);
    }
  }
  
static int port(SecureServerSocket self  ) {
    return self.port;
  }
  
static InternetAddress address(SecureServerSocket self  ) {
    return self.address;
  }
  
static Future close(SecureServerSocket self  ) {
    return then(self, (RawSecureServerSocket formal_0) { /* TODO: 实现匿名函数 */ return null as SecureServerSocket; });
  }
  
static dynamic _owner(SecureServerSocket self, dynamic owner  ) {
    {
      self._owner = owner;
    }
  }
  
}

/// 转换后的类: RawSecureServerSocket
class RawSecureServerSocket extends Stream {
  late RawServerSocket _socket;
  late SecurityContext _context;
  late bool requestClientCertificate;
  late bool requireClientCertificate;
  late List supportedProtocols;
  
  RawSecureServerSocket();
  
static RawSecureServerSocket create__(RawServerSocket _socket, SecurityContext _context, bool requestClientCertificate, bool requireClientCertificate, List supportedProtocols  ) {
    final instance = RawSecureServerSocket();
    instance._socket = _socket;
    instance._context = _context;
    instance.requestClientCertificate = requestClientCertificate;
    instance.requireClientCertificate = requireClientCertificate;
    instance.supportedProtocols = supportedProtocols;
    {
      self._controller = StreamController.();
    }
    return instance;
  }
  
static StreamSubscription listen(RawSecureServerSocket self, Function onData, Function onError, Function onDone, bool cancelOnError  ) {
    {
      return listen(self, onData);
    }
  }
  
static int port(RawSecureServerSocket self  ) {
    return self.port;
  }
  
static InternetAddress address(RawSecureServerSocket self  ) {
    return self.address;
  }
  
static Future close(RawSecureServerSocket self  ) {
    {
      self._closed = true;
      return then(self, (RawServerSocket formal_0) { /* TODO: 实现匿名函数 */ return null as RawSecureServerSocket; });
    }
  }
  
static dynamic _onData(RawSecureServerSocket self, RawSocket connection  ) {
    {
      dynamic remotePort;
try       {
        remotePort = self.remotePort;
      }
      // TODO: 实现try-catch语句
      catchError(self, (dynamic e, dynamic s) { /* TODO: 实现匿名函数 */ return null as Null; });
    }
  }
  
static dynamic _onPauseStateChange(RawSecureServerSocket self  ) {
    {
if (self.isPaused)       {
        pause(self, );
      }
 else       {
        resume(self, );
      }
    }
  }
  
static dynamic _onSubscriptionStateChange(RawSecureServerSocket self  ) {
    {
if (self.hasListener)       {
        self._subscription = listen(self, instance_tearoff);
      }
 else       {
        close(self, );
      }
    }
  }
  
static dynamic _owner(RawSecureServerSocket self, dynamic owner  ) {
    {
      self._owner = owner;
    }
  }
  
}

/// 转换后的类: SecureSocket
class SecureSocket implements Socket {
  SecureSocket();
  
}

/// 转换后的类: RawSecureSocket
class RawSecureSocket implements RawSocket {
  RawSecureSocket();
  
static RawSecureSocket create(  ) {
    final instance = RawSecureSocket();
    ;
    return instance;
  }
  
}

/// 转换后的类: X509Certificate
class X509Certificate {
  X509Certificate();
  
}

/// 转换后的类: TlsException
class TlsException implements IOException {
  late String type;
  late String message;
  late OSError osError;
  
  TlsException();
  
static TlsException create(String message, OSError osError  ) {
    final instance = TlsException();
    ;
    return instance;
  }
  
static TlsException create__(String type, String message, OSError osError  ) {
    final instance = TlsException();
    instance.type = type;
    instance.message = message;
    instance.osError = osError;
    ;
    return instance;
  }
  
static String toString(TlsException self  ) {
    {
      StringBuffer sb = StringBuffer.create();
      write(self, self.type);
if (self.isNotEmpty)       {
        write(self, ": " + self.message);
if (!self.osError == null)         {
          write(self, " (" + self.osError + ")");
        }
      }
 else if (!self.osError == null)       {
        write(self, ": " + self.osError);
      }
      return toString(self, );
    }
  }
  
}

/// 转换后的类: HandshakeException
class HandshakeException extends TlsException {
  HandshakeException();
  
static HandshakeException create(String message, OSError osError  ) {
    final instance = HandshakeException();
    ;
    return instance;
  }
  
}

/// 转换后的类: CertificateException
class CertificateException extends TlsException {
  CertificateException();
  
static CertificateException create(String message, OSError osError  ) {
    final instance = CertificateException();
    ;
    return instance;
  }
  
}

/// 转换后的类: TlsProtocolVersion
class TlsProtocolVersion {
  late int _version;
  
  TlsProtocolVersion();
  
static TlsProtocolVersion create__(int _version  ) {
    final instance = TlsProtocolVersion();
    instance._version = _version;
    ;
    return instance;
  }
  
}

/// 转换后的类: SecurityContext
class SecurityContext {
  SecurityContext();
  
}

/// 转换后的类: InternetAddressType
class InternetAddressType {
  late int _value;
  
  InternetAddressType();
  
static InternetAddressType create__(int _value  ) {
    final instance = InternetAddressType();
    instance._value = _value;
    ;
    return instance;
  }
  
static String name(InternetAddressType self  ) {
    return getElement(self, add(self, 1));
  }
  
static String toString(InternetAddressType self  ) {
    return "InternetAddressType: " + self.name;
  }
  
}

/// 转换后的类: InternetAddress
class InternetAddress {
  InternetAddress();
  
}

/// 转换后的类: NetworkInterface
class NetworkInterface {
  NetworkInterface();
  
static NetworkInterface create(  ) {
    final instance = NetworkInterface();
    ;
    return instance;
  }
  
}

/// 转换后的类: RawServerSocket
class RawServerSocket implements Stream {
  RawServerSocket();
  
static RawServerSocket create(  ) {
    final instance = RawServerSocket();
    ;
    return instance;
  }
  
}

/// 转换后的类: ServerSocket
class ServerSocket implements ServerSocketBase {
  ServerSocket();
  
static ServerSocket create(  ) {
    final instance = ServerSocket();
    ;
    return instance;
  }
  
}

/// 转换后的类: SocketDirection
class SocketDirection {
  late dynamic _value;
  
  SocketDirection();
  
static SocketDirection create__(dynamic _value  ) {
    final instance = SocketDirection();
    instance._value = _value;
    ;
    return instance;
  }
  
}

/// 转换后的类: SocketOption
class SocketOption {
  late dynamic _value;
  
  SocketOption();
  
static SocketOption create__(dynamic _value  ) {
    final instance = SocketOption();
    instance._value = _value;
    ;
    return instance;
  }
  
}

/// 转换后的类: RawSocketOption
class RawSocketOption {
  late int level;
  late int option;
  late Uint8List value;
  
  RawSocketOption();
  
static RawSocketOption create(int level, int option, Uint8List value  ) {
    final instance = RawSocketOption();
    instance.level = level;
    instance.option = option;
    instance.value = value;
    ;
    return instance;
  }
  
}

/// 转换后的类: RawSocketEvent
class RawSocketEvent {
  late int _value;
  
  RawSocketEvent();
  
static RawSocketEvent create__(int _value  ) {
    final instance = RawSocketEvent();
    instance._value = _value;
    ;
    return instance;
  }
  
static String toString(RawSocketEvent self  ) {
    {
      return getElement(self, self._value);
    }
  }
  
}

/// 转换后的类: ConnectionTask
class ConnectionTask {
  late Future socket;
  late Function _onCancel;
  
  ConnectionTask();
  
static ConnectionTask create__(Future socket, Function onCancel  ) {
    final instance = ConnectionTask();
    instance.socket = socket;
    instance._onCancel = onCancel;
    ;
    return instance;
  }
  
static dynamic cancel(ConnectionTask self  ) {
    {
      functionInvocation();
    }
  }
  
}

/// 转换后的类: RawSocket
class RawSocket implements Stream {
  RawSocket();
  
static RawSocket create(  ) {
    final instance = RawSocket();
    ;
    return instance;
  }
  
}

/// 转换后的类: Socket
class Socket implements Stream, IOSink {
  Socket();
  
static Socket create(  ) {
    final instance = Socket();
    ;
    return instance;
  }
  
}

/// 转换后的类: Datagram
class Datagram {
  Datagram();
  
static Datagram create(Uint8List data, InternetAddress address, int port  ) {
    final instance = Datagram();
    instance.data = data;
    instance.address = address;
    instance.port = port;
    ;
    return instance;
  }
  
}

/// 转换后的类: ResourceHandle
class ResourceHandle {
  ResourceHandle();
  
}

/// 转换后的类: SocketControlMessage
class SocketControlMessage {
  SocketControlMessage();
  
}

/// 转换后的类: SocketMessage
class SocketMessage {
  late Uint8List data;
  late List controlMessages;
  
  SocketMessage();
  
static SocketMessage create(Uint8List data, List controlMessages  ) {
    final instance = SocketMessage();
    instance.data = data;
    instance.controlMessages = controlMessages;
    ;
    return instance;
  }
  
}

/// 转换后的类: RawDatagramSocket
class RawDatagramSocket extends Stream {
  RawDatagramSocket();
  
static RawDatagramSocket create(  ) {
    final instance = RawDatagramSocket();
    ;
    return instance;
  }
  
}

/// 转换后的类: SocketException
class SocketException implements IOException {
  late String message;
  late OSError osError;
  late InternetAddress address;
  late int port;
  
  SocketException();
  
static SocketException create(String message, OSError osError, InternetAddress address, int port  ) {
    final instance = SocketException();
    instance.message = message;
    instance.osError = osError;
    instance.address = address;
    instance.port = port;
    ;
    return instance;
  }
  
static SocketException create_closed(  ) {
    final instance = SocketException();
    instance.message = "Socket has been closed";
    instance.osError = null;
    instance.address = null;
    instance.port = null;
    ;
    return instance;
  }
  
static String toString(SocketException self  ) {
    {
      StringBuffer sb = StringBuffer.create();
      write(self, "SocketException");
if (self.isNotEmpty)       {
        write(self, ": " + self.message);
if (!self.osError == null)         {
          write(self, " (" + self.osError + ")");
        }
      }
 else if (!self.osError == null)       {
        write(self, ": " + self.osError);
      }
if (!self.address == null)       {
        write(self, ", address = " + self.host);
      }
if (!self.port == null)       {
        write(self, ", port = " + self.port);
      }
      return toString(self, );
    }
  }
  
}

/// 转换后的类: Stdin
class Stdin extends _StdStream implements Stream {
  Stdin();
  
static Stdin create__(Stream stream, int _fd  ) {
    final instance = Stdin();
    instance._fd = _fd;
    ;
    return instance;
  }
  
static String readLineSync(Stdin self, Encoding encoding, bool retainNewlines  ) {
    {
      List line = _GrowableList.(0);
      bool crIsNewline = self.isWindows && stdioType(self.stdin) == const InstanceConstant(const StdioType{StdioType.name: "terminal"}) && !self.lineMode;
if (retainNewlines)       {
        int byte;
        // TODO: 实现标签语句
do         {
          byte = readByteSync(self, );
if (lessThan(self, 0))           {
            break;
          }
          add(self, byte);
        }
 while (!byte == const IntConstant(10) && !byte == const IntConstant(13) && crIsNewline);if (self.isEmpty)         {
          return null;
        }
      }
 else if (crIsNewline)       {
        // TODO: 实现标签语句
while (true)         {
          int byte = readByteSync(self, );
if (lessThan(self, 0))           {
if (self.isEmpty)             return null;
            break;
          }
if (byte == const IntConstant(10) || byte == const IntConstant(13))           break;
          add(self, byte);
        }
      }
 else       {
        // TODO: 实现标签语句
while (true)         {
          int byte = readByteSync(self, );
if (byte == const IntConstant(10))           break;
if (byte == const IntConstant(13))           {
do             {
              byte = readByteSync(self, );
if (byte == const IntConstant(10))               break;
              add(self, const IntConstant(13));
            }
 while (byte == const IntConstant(13));          }
if (lessThan(self, 0))           {
if (self.isEmpty)             return null;
            break;
          }
          add(self, byte);
        }
      }
      return decode(self, line);
    }
  }
  
static bool echoMode(Stdin self  ) {
    {
      dynamic result = Stdin._echoMode(self._fd);
if (result is OSError)       {
        throw StdinException.create("Error getting terminal echo mode", result);
      }
      return result as bool;
    }
  }
  
static dynamic echoMode(Stdin self, bool enabled  ) {
    {
if (!self._maySetEchoMode)       {
        throw UnsupportedError.create("This embedder disallows setting Stdin.echoMode");
      }
      dynamic result = Stdin._setEchoMode(self._fd, enabled);
if (result is OSError)       {
        throw StdinException.create("Error setting terminal echo mode", result);
      }
    }
  }
  
static bool echoNewlineMode(Stdin self  ) {
    {
      dynamic result = Stdin._echoNewlineMode(self._fd);
if (result is OSError)       {
        throw StdinException.create("Error getting terminal echo newline mode", result);
      }
      return result as bool;
    }
  }
  
static dynamic echoNewlineMode(Stdin self, bool enabled  ) {
    {
if (!self._maySetEchoNewlineMode)       {
        throw UnsupportedError.create("This embedder disallows setting Stdin.echoNewlineMode");
      }
      dynamic result = Stdin._setEchoNewlineMode(self._fd, enabled);
if (result is OSError)       {
        throw StdinException.create("Error setting terminal echo newline mode", result);
      }
    }
  }
  
static bool lineMode(Stdin self  ) {
    {
      dynamic result = Stdin._lineMode(self._fd);
if (result is OSError)       {
        throw StdinException.create("Error getting terminal line mode", result);
      }
      return result as bool;
    }
  }
  
static dynamic lineMode(Stdin self, bool enabled  ) {
    {
if (!self._maySetLineMode)       {
        throw UnsupportedError.create("This embedder disallows setting Stdin.lineMode");
      }
      dynamic result = Stdin._setLineMode(self._fd, enabled);
if (result is OSError)       {
        throw StdinException.create("Error setting terminal line mode", result);
      }
    }
  }
  
static bool supportsAnsiEscapes(Stdin self  ) {
    {
      dynamic result = Stdin._supportsAnsiEscapes(self._fd);
if (result is OSError)       {
        throw StdinException.create("Error determining ANSI support", result);
      }
      return result as bool;
    }
  }
  
static int readByteSync(Stdin self  ) {
    {
      dynamic result = Stdin._readByte(self._fd);
if (result is OSError)       {
        throw StdinException.create("Error reading byte from stdin", result);
      }
      return result as int;
    }
  }
  
static bool hasTerminal(Stdin self  ) {
    {
try       {
        return stdioType(self) == const InstanceConstant(const StdioType{StdioType.name: "terminal"});
      }
      // TODO: 实现try-catch语句
    }
  }
  
}

/// 转换后的类: Stdout
class Stdout extends _StdSink implements IOSink {
  late int _fd;
  
  Stdout();
  
static Stdout create__(IOSink sink, int _fd  ) {
    final instance = Stdout();
    instance._fd = _fd;
    ;
    return instance;
  }
  
static bool hasTerminal(Stdout self  ) {
    return _hasTerminal(self, self._fd);
  }
  
static int terminalColumns(Stdout self  ) {
    return _terminalColumns(self, self._fd);
  }
  
static int terminalLines(Stdout self  ) {
    return _terminalLines(self, self._fd);
  }
  
static bool supportsAnsiEscapes(Stdout self  ) {
    return Stdout._supportsAnsiEscapes(self._fd);
  }
  
static bool _hasTerminal(Stdout self, int fd  ) {
    return Stdout._getTerminalSize(fd) is List;
  }
  
static int _terminalColumns(Stdout self, int fd  ) {
    return getElement(self, 0) as int;
  }
  
static int _terminalLines(Stdout self, int fd  ) {
    return getElement(self, 1) as int;
  }
  
static IOSink nonBlocking(Stdout self  ) {
    {
      return let_expression;
    }
  }
  
}

/// 转换后的类: StdoutException
class StdoutException implements IOException {
  late String message;
  late OSError osError;
  
  StdoutException();
  
static StdoutException create(String message, OSError osError  ) {
    final instance = StdoutException();
    instance.message = message;
    instance.osError = osError;
    ;
    return instance;
  }
  
static String toString(StdoutException self  ) {
    {
      return "StdoutException: " + self.message + self.osError == null ? "" : ", " + self.osError;
    }
  }
  
}

/// 转换后的类: StdinException
class StdinException implements IOException {
  late String message;
  late OSError osError;
  
  StdinException();
  
static StdinException create(String message, OSError osError  ) {
    final instance = StdinException();
    instance.message = message;
    instance.osError = osError;
    ;
    return instance;
  }
  
static String toString(StdinException self  ) {
    {
      return "StdinException: " + self.message + self.osError == null ? "" : ", " + self.osError;
    }
  }
  
}

/// 转换后的类: StdioType
class StdioType {
  late String name;
  
  StdioType();
  
static StdioType create__(String name  ) {
    final instance = StdioType();
    instance.name = name;
    ;
    return instance;
  }
  
static String toString(StdioType self  ) {
    return "StdioType: " + self.name;
  }
  
}

/// 转换后的类: SystemEncoding
class SystemEncoding extends Encoding {
  SystemEncoding();
  
static SystemEncoding create(  ) {
    final instance = SystemEncoding();
    ;
    return instance;
  }
  
static String name(SystemEncoding self  ) {
    return "system";
  }
  
static List encode(SystemEncoding self, String input  ) {
    return convert(self, input);
  }
  
static String decode(SystemEncoding self, List encoded  ) {
    return convert(self, encoded);
  }
  
static Converter encoder(SystemEncoding self  ) {
    {
if (self.operatingSystem == "windows")       {
        return const InstanceConstant(const _WindowsCodePageEncoder{});
      }
 else       {
        return const InstanceConstant(const Utf8Encoder{});
      }
    }
  }
  
static Converter decoder(SystemEncoding self  ) {
    {
if (self.operatingSystem == "windows")       {
        return const InstanceConstant(const _WindowsCodePageDecoder{});
      }
 else       {
        return const InstanceConstant(const Utf8Decoder{Utf8Decoder._allowMalformed: false});
      }
    }
  }
  
}

/// 转换后的类: RawSynchronousSocket
class RawSynchronousSocket {
  RawSynchronousSocket();
  
static RawSynchronousSocket create(  ) {
    final instance = RawSynchronousSocket();
    ;
    return instance;
  }
  
}

/// 转换后的类: Deprecated
class Deprecated {
  late String message;
  
  Deprecated();
  
static Deprecated create(String message  ) {
    final instance = Deprecated();
    instance.message = message;
    ;
    return instance;
  }
  
static String toString(Deprecated self  ) {
    return "Deprecated feature: " + self.message;
  }
  
}

/// 转换后的类: pragma
class pragma {
  late String name;
  late Object options;
  
  pragma();
  
static pragma create__(String name, Object options  ) {
    final instance = pragma();
    instance.name = name;
    instance.options = options;
    ;
    return instance;
  }
  
}

/// 转换后的类: BigInt
class BigInt implements Comparable {
  BigInt();
  
}

/// 转换后的类: bool
class bool {
  bool();
  
static int _identityHashCode(bool self  ) {
    return self ? 1231 : 1237;
  }
  
static int hashCode(bool self  ) {
    return self ? 1231 : 1237;
  }
  
static bool bitwiseAnd(bool self, bool other  ) {
    return other && self;
  }
  
static bool bitwiseOr(bool self, bool other  ) {
    return other || self;
  }
  
static bool bitwiseXor(bool self, bool other  ) {
    return !other == self;
  }
  
static String toString(bool self  ) {
    {
      return self ? "true" : "false";
    }
  }
  
}

/// 转换后的类: Comparable
class Comparable {
  Comparable();
  
static Comparable create(  ) {
    final instance = Comparable();
    ;
    return instance;
  }
  
}

/// 转换后的类: DateTime
class DateTime implements Comparable {
  late int _value;
  late bool isUtc;
  
  DateTime();
  
static DateTime create__(int _value, bool isUtc  ) {
    final instance = DateTime();
    instance._value = _value;
    instance.isUtc = isUtc;
    ;
    return instance;
  }
  
static DateTime create__withValue(int _value, bool isUtc  ) {
    final instance = DateTime();
    instance._value = _value;
    instance.isUtc = isUtc;
    {
      DateTime._validate(self.millisecondsSinceEpoch, self.microsecond, self.isUtc);
    }
    return instance;
  }
  
static DateTime create(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond  ) {
    final instance = DateTime();
    ;
    return instance;
  }
  
static DateTime create_utc(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond  ) {
    final instance = DateTime();
    ;
    return instance;
  }
  
static DateTime create_now(  ) {
    final instance = DateTime();
    ;
    return instance;
  }
  
static DateTime create_timestamp(  ) {
    final instance = DateTime();
    ;
    return instance;
  }
  
static DateTime create__nowUtc(  ) {
    final instance = DateTime();
    instance.isUtc = true;
    instance._value = DateTime._getCurrentMicros();
    ;
    return instance;
  }
  
static DateTime create_fromMillisecondsSinceEpoch(int millisecondsSinceEpoch, bool isUtc  ) {
    final instance = DateTime();
    ;
    return instance;
  }
  
static DateTime create_fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch, bool isUtc  ) {
    final instance = DateTime();
    ;
    return instance;
  }
  
static DateTime create__internal(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond, bool isUtc  ) {
    final instance = DateTime();
    instance.isUtc = checkNotNullable(isUtc, "isUtc");
    instance._value = let_expression;
    {
if (self._value == const IntConstant(-8640000000000000001))       {
        throw ArgumentError.create("(" + year + ", " + month + ", " + day + "," + " " + hour + ", " + minute + ", " + second + ", " + millisecond + ", " + microsecond + ")");
      }
    }
    return instance;
  }
  
static DateTime create__now(  ) {
    final instance = DateTime();
    instance.isUtc = false;
    instance._value = DateTime._getCurrentMicros();
    ;
    return instance;
  }
  
static List _parts(DateTime self  ) {
    {
      return let_expression;
    }
  }
  
static int _localDateInUtcMicros(DateTime self  ) {
    {
      int micros = self._value;
if (self.isUtc)       return micros;
      int offset = multiply(self, const IntConstant(1000000));
      return add(self, offset);
    }
  }
  
static int hashCode(DateTime self  ) {
    return bitwiseAnd(self, 1073741823);
  }
  
static bool isBefore(DateTime self, DateTime other  ) {
    return lessThan(self, self.microsecondsSinceEpoch);
  }
  
static bool isAfter(DateTime self, DateTime other  ) {
    return greaterThan(self, self.microsecondsSinceEpoch);
  }
  
static bool isAtSameMomentAs(DateTime self, DateTime other  ) {
    return self._value == self.microsecondsSinceEpoch;
  }
  
static int compareTo(DateTime self, DateTime other  ) {
    return compareTo(self, self.microsecondsSinceEpoch);
  }
  
static DateTime toLocal(DateTime self  ) {
    {
if (self.isUtc)       {
        return _withUtc(self, );
      }
      return self;
    }
  }
  
static DateTime toUtc(DateTime self  ) {
    {
if (self.isUtc)       return self;
      return _withUtc(self, );
    }
  }
  
static DateTime _withUtc(DateTime self, bool isUtc  ) {
    {
      return DateTime.create__(self._value);
    }
  }
  
static String toString(DateTime self  ) {
    {
      String y = DateTime._fourDigits(self.year);
      String m = DateTime._twoDigits(self.month);
      String d = DateTime._twoDigits(self.day);
      String h = DateTime._twoDigits(self.hour);
      String min = DateTime._twoDigits(self.minute);
      String sec = DateTime._twoDigits(self.second);
      String ms = DateTime._threeDigits(self.millisecond);
      String us = self.microsecond == 0 ? "" : DateTime._threeDigits(self.microsecond);
if (self.isUtc)       {
        return y + "-" + m + "-" + d + " " + h + ":" + min + ":" + sec + "." + ms + us + "Z";
      }
 else       {
        return y + "-" + m + "-" + d + " " + h + ":" + min + ":" + sec + "." + ms + us;
      }
    }
  }
  
static String toIso8601String(DateTime self  ) {
    {
      String y = greaterThanOrEqual(self, negate(self)) && lessThanOrEqual(self, 9999) ? DateTime._fourDigits(self.year) : DateTime._sixDigits(self.year);
      String m = DateTime._twoDigits(self.month);
      String d = DateTime._twoDigits(self.day);
      String h = DateTime._twoDigits(self.hour);
      String min = DateTime._twoDigits(self.minute);
      String sec = DateTime._twoDigits(self.second);
      String ms = DateTime._threeDigits(self.millisecond);
      String us = self.microsecond == 0 ? "" : DateTime._threeDigits(self.microsecond);
if (self.isUtc)       {
        return y + "-" + m + "-" + d + "T" + h + ":" + min + ":" + sec + "." + ms + us + "Z";
      }
 else       {
        return y + "-" + m + "-" + d + "T" + h + ":" + min + ":" + sec + "." + ms + us;
      }
    }
  }
  
static DateTime add(DateTime self, Duration duration  ) {
    {
      return DateTime.create__withValue(add(self, self.inMicroseconds));
    }
  }
  
static DateTime subtract(DateTime self, Duration duration  ) {
    {
      return DateTime.create__withValue(subtract(self, self.inMicroseconds));
    }
  }
  
static Duration difference(DateTime self, DateTime other  ) {
    {
      return Duration.create();
    }
  }
  
static int millisecondsSinceEpoch(DateTime self  ) {
    return DateTime._flooredDivision(self._value, const IntConstant(1000));
  }
  
static int microsecondsSinceEpoch(DateTime self  ) {
    return self._value;
  }
  
static String timeZoneName(DateTime self  ) {
    {
if (self.isUtc)       return "UTC";
      return DateTime._timeZoneName(self.microsecondsSinceEpoch);
    }
  }
  
static Duration timeZoneOffset(DateTime self  ) {
    {
if (self.isUtc)       return Duration.create();
      int offsetInSeconds = DateTime._timeZoneOffsetInSeconds(self.microsecondsSinceEpoch);
      return Duration.create();
    }
  }
  
static int year(DateTime self  ) {
    return getElement(self, const IntConstant(8));
  }
  
static int month(DateTime self  ) {
    return getElement(self, const IntConstant(7));
  }
  
static int day(DateTime self  ) {
    return getElement(self, const IntConstant(5));
  }
  
static int hour(DateTime self  ) {
    return getElement(self, const IntConstant(4));
  }
  
static int minute(DateTime self  ) {
    return getElement(self, const IntConstant(3));
  }
  
static int second(DateTime self  ) {
    return getElement(self, const IntConstant(2));
  }
  
static int millisecond(DateTime self  ) {
    return getElement(self, const IntConstant(1));
  }
  
static int microsecond(DateTime self  ) {
    return getElement(self, const IntConstant(0));
  }
  
static int weekday(DateTime self  ) {
    return getElement(self, const IntConstant(6));
  }
  
static bool equals(DateTime self, dynamic other  ) {
    return other is DateTime && self._value == self.microsecondsSinceEpoch && self.isUtc == self.isUtc;
  }
  
}

/// 转换后的类: double
class double extends num {
  double();
  
static double create(  ) {
    final instance = double();
    ;
    return instance;
  }
  
}

/// 转换后的类: Duration
class Duration implements Comparable {
  late int _duration;
  
  Duration();
  
static Duration create(int days, int hours, int minutes, int seconds, int milliseconds, int microseconds  ) {
    final instance = Duration();
    ;
    return instance;
  }
  
static Duration create__microseconds(int duration  ) {
    final instance = Duration();
    instance._duration = add(self, 0);
    ;
    return instance;
  }
  
static Duration ~/(Duration self, int quotient  ) {
    {
if (quotient == 0)       throw IntegerDivisionByZeroException.create();
      return Duration.create__microseconds(~/(self, quotient));
    }
  }
  
static int inDays(Duration self  ) {
    return ~/(self, const IntConstant(86400000000));
  }
  
static int inHours(Duration self  ) {
    return ~/(self, const IntConstant(3600000000));
  }
  
static int inMinutes(Duration self  ) {
    return ~/(self, const IntConstant(60000000));
  }
  
static int inSeconds(Duration self  ) {
    return ~/(self, const IntConstant(1000000));
  }
  
static int inMilliseconds(Duration self  ) {
    return ~/(self, const IntConstant(1000));
  }
  
static int inMicroseconds(Duration self  ) {
    return self._duration;
  }
  
static int hashCode(Duration self  ) {
    return self.hashCode;
  }
  
static int compareTo(Duration self, Duration other  ) {
    return compareTo(self, self._duration);
  }
  
static String toString(Duration self  ) {
    {
      int microseconds = self.inMicroseconds;
      String sign = "";
      bool negative = lessThan(self, 0);
      int hours = ~/(self, const IntConstant(3600000000));
      microseconds = remainder(self, const IntConstant(3600000000));
if (negative)       {
        hours = subtract(self, hours);
        microseconds = subtract(self, microseconds);
        sign = "-";
      }
      int minutes = ~/(self, const IntConstant(60000000));
      microseconds = remainder(self, const IntConstant(60000000));
      String minutesPadding = lessThan(self, 10) ? "0" : "";
      int seconds = ~/(self, const IntConstant(1000000));
      microseconds = remainder(self, const IntConstant(1000000));
      String secondsPadding = lessThan(self, 10) ? "0" : "";
      String microsecondsText = padLeft(self, 6, "0");
      return sign + hours + ":" + minutesPadding + minutes + ":" + secondsPadding + seconds + "." + microsecondsText;
    }
  }
  
static bool isNegative(Duration self  ) {
    return lessThan(self, 0);
  }
  
static Duration abs(Duration self  ) {
    return Duration.create__microseconds(abs(self, ));
  }
  
static Duration negate(Duration self  ) {
    return Duration.create__microseconds(subtract(self, self._duration));
  }
  
static Duration add(Duration self, Duration other  ) {
    {
      return Duration.create__microseconds(add(self, self._duration));
    }
  }
  
static Duration subtract(Duration self, Duration other  ) {
    {
      return Duration.create__microseconds(subtract(self, self._duration));
    }
  }
  
static Duration multiply(Duration self, num factor  ) {
    {
      return Duration.create__microseconds(round(self, ));
    }
  }
  
static bool lessThan(Duration self, Duration other  ) {
    return lessThan(self, self._duration);
  }
  
static bool greaterThan(Duration self, Duration other  ) {
    return greaterThan(self, self._duration);
  }
  
static bool lessThanOrEqual(Duration self, Duration other  ) {
    return lessThanOrEqual(self, self._duration);
  }
  
static bool greaterThanOrEqual(Duration self, Duration other  ) {
    return greaterThanOrEqual(self, self._duration);
  }
  
static bool equals(Duration self, Object other  ) {
    return other is Duration && self._duration == self.inMicroseconds;
  }
  
}

/// 转换后的类: Enum
class Enum {
  Enum();
  
static Enum create(  ) {
    final instance = Enum();
    ;
    return instance;
  }
  
}

/// 转换后的类: Error
class Error {
  Error();
  
static Error create(  ) {
    final instance = Error();
    ;
    return instance;
  }
  
static StackTrace stackTrace(Error self  ) {
    return self._stackTrace;
  }
  
}

/// 转换后的类: AssertionError
class AssertionError extends Error {
  late Object message;
  
  AssertionError();
  
static AssertionError create(Object message  ) {
    final instance = AssertionError();
    instance.message = message;
    ;
    return instance;
  }
  
static String toString(AssertionError self  ) {
    {
if (!self.message == null)       {
        return "Assertion failed: " + Error.safeToString(self.message);
      }
      return "Assertion failed";
    }
  }
  
}

/// 转换后的类: TypeError
class TypeError extends Error {
  TypeError();
  
static TypeError create(  ) {
    final instance = TypeError();
    ;
    return instance;
  }
  
}

/// 转换后的类: ArgumentError
class ArgumentError extends Error {
  late bool _hasValue;
  late dynamic invalidValue;
  late String name;
  late dynamic message;
  
  ArgumentError();
  
static ArgumentError create(dynamic message, String name  ) {
    final instance = ArgumentError();
    instance.message = message;
    instance.name = name;
    instance.invalidValue = null;
    instance._hasValue = false;
    ;
    return instance;
  }
  
static ArgumentError create_value(dynamic value, String name, dynamic message  ) {
    final instance = ArgumentError();
    instance.name = name;
    instance.message = message;
    instance.invalidValue = value;
    instance._hasValue = true;
    ;
    return instance;
  }
  
static ArgumentError create_notNull(String name  ) {
    final instance = ArgumentError();
    instance.name = name;
    instance._hasValue = false;
    instance.message = "Must not be null";
    instance.invalidValue = null;
    ;
    return instance;
  }
  
static String _errorName(ArgumentError self  ) {
    return "Invalid argument" + !self._hasValue ? "(s)" : "";
  }
  
static String _errorExplanation(ArgumentError self  ) {
    return "";
  }
  
static String toString(ArgumentError self  ) {
    {
      String name = self.name;
      String nameString = name == null ? "" : " (" + name + ")";
      Object message = self.message;
      String messageString = message == null ? "" : ": " + message;
      String prefix = self._errorName + nameString + messageString;
if (!self._hasValue)       return prefix;
      String explanation = self._errorExplanation;
      String errorValue = Error.safeToString(self.invalidValue);
      return prefix + explanation + ": " + errorValue;
    }
  }
  
}

/// 转换后的类: RangeError
class RangeError extends ArgumentError {
  late num start;
  late num end;
  
  RangeError();
  
static RangeError create(dynamic message  ) {
    final instance = RangeError();
    instance.start = null;
    instance.end = null;
    ;
    return instance;
  }
  
static RangeError create_value(num value, String name, String message  ) {
    final instance = RangeError();
    instance.start = null;
    instance.end = null;
    ;
    return instance;
  }
  
static RangeError create_range(num invalidValue, int minValue, int maxValue, String name, String message  ) {
    final instance = RangeError();
    instance.start = minValue;
    instance.end = maxValue;
    ;
    return instance;
  }
  
static num invalidValue(RangeError self  ) {
    return super.invalidValue as num;
  }
  
static String _errorName(RangeError self  ) {
    return "RangeError";
  }
  
static String _errorExplanation(RangeError self  ) {
    {
assert(self._hasValue      );
      String explanation = "";
      num start = self.start;
      num end = self.end;
if (start == null)       {
if (!end == null)         {
          explanation = ": Not less than or equal to " + end;
        }
      }
 else if (end == null)       {
        explanation = ": Not greater than or equal to " + start;
      }
 else if (greaterThan(self, start))       {
        explanation = ": Not in inclusive range " + start + ".." + end;
      }
 else if (lessThan(self, start))       {
        explanation = ": Valid value range is empty";
      }
 else       {
        explanation = ": Only valid value is " + start;
      }
      return explanation;
    }
  }
  
}

/// 转换后的类: IndexError
class IndexError extends ArgumentError implements RangeError {
  late Object indexable;
  late int length;
  
  IndexError();
  
static IndexError create(int invalidValue, dynamic indexable, String name, String message, int length  ) {
    final instance = IndexError();
    instance.indexable = indexable;
    instance.length = let_expression as int;
    ;
    return instance;
  }
  
static IndexError create_withLength(int invalidValue, int length, Object indexable, String name, String message  ) {
    final instance = IndexError();
    instance.length = length;
    instance.indexable = indexable;
    ;
    return instance;
  }
  
static int invalidValue(IndexError self  ) {
    return super.invalidValue as int;
  }
  
static int start(IndexError self  ) {
    return 0;
  }
  
static int end(IndexError self  ) {
    return subtract(self, 1);
  }
  
static String _errorName(IndexError self  ) {
    return "RangeError";
  }
  
static String _errorExplanation(IndexError self  ) {
    {
assert(self._hasValue      );
      int invalidValue = self.invalidValue;
if (lessThan(self, 0))       {
        return ": index must not be negative";
      }
if (self.length == 0)       {
        return ": no indices are valid";
      }
      return ": index should be less than " + self.length;
    }
  }
  
}

/// 转换后的类: NoSuchMethodError
class NoSuchMethodError extends Error {
  late Object _receiver;
  late Invocation _invocation;
  
  NoSuchMethodError();
  
static NoSuchMethodError create__withInvocation(Object _receiver, Invocation _invocation  ) {
    final instance = NoSuchMethodError();
    instance._receiver = _receiver;
    instance._invocation = _invocation;
    ;
    return instance;
  }
  
static NoSuchMethodError create__withType(Object _receiver, String memberName, int invocationType, int typeArgumentsLength, Object typeArguments, List arguments, List argumentNames  ) {
    final instance = NoSuchMethodError();
    instance._receiver = _receiver;
    instance._invocation = _InvocationMirror.create__withType(Symbol.create(memberName), invocationType, _InvocationMirror._unpackTypeArguments(typeArguments, typeArgumentsLength), !argumentNames == null ? sublist(self, 0, subtract(self, self.length)) : arguments, !argumentNames == null ? NoSuchMethodError._NamedArgumentsMap(arguments!, argumentNames) : null);
    ;
    return instance;
  }
  
static String toString(NoSuchMethodError self  ) {
    {
      Invocation localInvocation = self._invocation;
if (localInvocation is _InvocationMirror)       {
        Symbol internalName = self.memberName as Symbol;
        String memberName = Symbol.computeUnmangledName(internalName);
        int level = bitwiseAnd(self, const IntConstant(7));
        int kind = bitwiseAnd(self, const IntConstant(7));
if (kind == const IntConstant(4))         {
          return "NoSuchMethodError: Cannot assign to final variable '" + memberName + "'";
        }
        StringBuffer typeArgumentsBuf = null;
        List typeArguments = self.typeArguments;
if (!typeArguments == null && greaterThan(self, 0))         {
          StringBuffer argsBuf = StringBuffer.create();
          write(self, "<");
for (int i = 0; lessThan(self, self.length); i = add(self, 1))           {
if (greaterThan(self, 0))             {
              write(self, ", ");
            }
            write(self, Error.safeToString(getElement(self, i)));
          }
          write(self, ">");
          typeArgumentsBuf = argsBuf;
        }
        StringBuffer argumentsBuf = StringBuffer.create();
        List positionalArguments = self.positionalArguments;
        int argumentCount = 0;
if (!positionalArguments == null)         {
for (; lessThan(self, self.length); argumentCount = add(self, 1))           {
if (greaterThan(self, 0))             {
              write(self, ", ");
            }
            write(self, Error.safeToString(getElement(self, argumentCount)));
          }
        }
        Map namedArguments = self.namedArguments;
if (!namedArguments == null)         {
          forEach(self, (Symbol key, dynamic value) { /* TODO: 实现匿名函数 */ return null as dynamic; });
        }
        String existingSig = NoSuchMethodError._existingMethodSignature(self._receiver, memberName, self._type);
        String argsMsg = !existingSig == null ? " with matching arguments" : "";
        String kindBuf = "function";
if (greaterThanOrEqual(self, 0) && lessThan(self, 5))         {
          kindBuf = getElement(self, kind);
        }
        StringBuffer msgBuf = StringBuffer.create("NoSuchMethodError: ");
        bool isTypeCall = false;
        // TODO: 实现标签语句
switch (level) {        // TODO: 实现switch语句
        }
if (level == const IntConstant(4))         {
          writeln(self, "Receiver: top-level");
        }
 else         {
          writeln(self, "Receiver: " + Error.safeToString(self._receiver));
        }
if (kind == const IntConstant(0))         {
          String m = isTypeCall ? self._receiver : memberName;
          write(self, "Tried calling: " + m);
if (!typeArgumentsBuf == null)           {
            write(self, typeArgumentsBuf);
          }
          write(self, "(" + argumentsBuf + ")");
        }
 else if (argumentCount == 0)         {
          write(self, "Tried calling: " + memberName);
        }
 else if (kind == const IntConstant(2))         {
          write(self, "Tried calling: " + memberName + argumentsBuf);
        }
 else         {
          write(self, "Tried calling: " + memberName + " = " + argumentsBuf);
        }
if (!existingSig == null)         {
          write(self, "
Found: " + memberName + existingSig);
        }
        return toString(self, );
      }
      return NoSuchMethodError._toStringPlain(self._receiver, localInvocation);
    }
  }
  
}

/// 转换后的类: UnsupportedError
class UnsupportedError extends Error {
  late String message;
  
  UnsupportedError();
  
static UnsupportedError create(String message  ) {
    final instance = UnsupportedError();
    instance.message = message;
    ;
    return instance;
  }
  
static String toString(UnsupportedError self  ) {
    return "Unsupported operation: " + self.message;
  }
  
}

/// 转换后的类: UnimplementedError
class UnimplementedError extends Error implements UnsupportedError {
  late String message;
  
  UnimplementedError();
  
static UnimplementedError create(String message  ) {
    final instance = UnimplementedError();
    instance.message = message;
    ;
    return instance;
  }
  
static String toString(UnimplementedError self  ) {
    {
      String message = self.message;
      return !message == null ? "UnimplementedError: " + message : "UnimplementedError";
    }
  }
  
}

/// 转换后的类: StateError
class StateError extends Error {
  late String message;
  
  StateError();
  
static StateError create(String message  ) {
    final instance = StateError();
    instance.message = message;
    ;
    return instance;
  }
  
static String toString(StateError self  ) {
    return "Bad state: " + self.message;
  }
  
}

/// 转换后的类: ConcurrentModificationError
class ConcurrentModificationError extends Error {
  late Object modifiedObject;
  
  ConcurrentModificationError();
  
static ConcurrentModificationError create(Object modifiedObject  ) {
    final instance = ConcurrentModificationError();
    instance.modifiedObject = modifiedObject;
    ;
    return instance;
  }
  
static String toString(ConcurrentModificationError self  ) {
    {
if (self.modifiedObject == null)       {
        return "Concurrent modification during iteration.";
      }
      return "Concurrent modification during iteration: " + Error.safeToString(self.modifiedObject) + ".";
    }
  }
  
}

/// 转换后的类: OutOfMemoryError
class OutOfMemoryError implements Error {
  OutOfMemoryError();
  
static OutOfMemoryError create(  ) {
    final instance = OutOfMemoryError();
    ;
    return instance;
  }
  
static StackTrace _stackTrace(OutOfMemoryError self  ) {
    return throw UnsupportedError.create("OutOfMemoryError._stackTrace");
  }
  
static dynamic _stackTrace(OutOfMemoryError self, StackTrace formal_0  ) {
    {
      throw UnsupportedError.create("OutOfMemoryError._stackTrace");
    }
  }
  
static String toString(OutOfMemoryError self  ) {
    return "Out of Memory";
  }
  
static StackTrace stackTrace(OutOfMemoryError self  ) {
    return null;
  }
  
}

/// 转换后的类: StackOverflowError
class StackOverflowError implements Error {
  StackOverflowError();
  
static StackOverflowError create(  ) {
    final instance = StackOverflowError();
    ;
    return instance;
  }
  
static StackTrace _stackTrace(StackOverflowError self  ) {
    return throw UnsupportedError.create("StackOverflowError._stackTrace");
  }
  
static dynamic _stackTrace(StackOverflowError self, StackTrace formal_1  ) {
    {
      throw UnsupportedError.create("StackOverflowError._stackTrace");
    }
  }
  
static String toString(StackOverflowError self  ) {
    return "Stack Overflow";
  }
  
static StackTrace stackTrace(StackOverflowError self  ) {
    return null;
  }
  
}

/// 转换后的类: Exception
class Exception {
  Exception();
  
}

/// 转换后的类: FormatException
class FormatException implements Exception {
  late String message;
  late dynamic source;
  late int offset;
  
  FormatException();
  
static FormatException create(String message, dynamic source, int offset  ) {
    final instance = FormatException();
    instance.message = message;
    instance.source = source;
    instance.offset = offset;
    ;
    return instance;
  }
  
static String toString(FormatException self  ) {
    {
      String report = "FormatException";
      Object message = self.message;
if (!message == null && !"" == message)       {
        report = report + ": " + message;
      }
      int offset = self.offset;
      Object source = self.source;
if (source is String)       {
if (!offset == null && lessThan(self, 0) || greaterThan(self, self.length))         {
          offset = null;
        }
if (offset == null)         {
if (greaterThan(self, 78))           {
            source = add(self, "...");
          }
          return report + "
" + source;
        }
        int lineNum = 1;
        int lineStart = 0;
        bool previousCharWasCR = false;
for (int i = 0; lessThan(self, offset); i = add(self, 1))         {
          int char = codeUnitAt(self, i);
if (char == 10)           {
if (!lineStart == i || !previousCharWasCR)             {
              lineNum = add(self, 1);
            }
            lineStart = add(self, 1);
            previousCharWasCR = false;
          }
 else if (char == 13)           {
            lineNum = add(self, 1);
            lineStart = add(self, 1);
            previousCharWasCR = true;
          }
        }
if (greaterThan(self, 1))         {
          report = +(self, " (at line " + lineNum + ", character " + add(self, 1) + ")
");
        }
 else         {
          report = +(self, " (at character " + add(self, 1) + ")
");
        }
        int lineEnd = self.length;
        // TODO: 实现标签语句
for (int i = offset; lessThan(self, self.length); i = add(self, 1))         {
          int char = codeUnitAt(self, i);
if (char == 10 || char == 13)           {
            lineEnd = i;
            break;
          }
        }
        int length = subtract(self, lineStart);
        int start = lineStart;
        int end = lineEnd;
        String prefix = "";
        String postfix = "";
if (greaterThan(self, 78))         {
          int index = subtract(self, lineStart);
if (lessThan(self, 75))           {
            end = add(self, 75);
            postfix = "...";
          }
 else if (lessThan(self, 75))           {
            start = subtract(self, 75);
            prefix = "...";
          }
 else           {
            start = subtract(self, 36);
            end = add(self, 36);
            prefix = postfix = "...";
          }
        }
        String slice = substring(self, start, end);
        int markOffset = add(self, self.length);
        return report + prefix + slice + postfix + "
" + multiply(self, markOffset) + "^
";
      }
 else       {
if (!offset == null)         {
          report = add(self, " (at offset " + offset + ")");
        }
        return report;
      }
    }
  }
  
}

/// 转换后的类: IntegerDivisionByZeroException
class IntegerDivisionByZeroException implements Exception, UnsupportedError {
  IntegerDivisionByZeroException();
  
static IntegerDivisionByZeroException create(  ) {
    final instance = IntegerDivisionByZeroException();
    ;
    return instance;
  }
  
static StackTrace _stackTrace(IntegerDivisionByZeroException self  ) {
    return throw UnsupportedError.create("IntegerDivisionByZeroException._stackTrace");
  }
  
static dynamic _stackTrace(IntegerDivisionByZeroException self, StackTrace formal_2  ) {
    {
      throw UnsupportedError.create("IntegerDivisionByZeroException._stackTrace");
    }
  }
  
static String message(IntegerDivisionByZeroException self  ) {
    return "Division resulted in non-finite value";
  }
  
static StackTrace stackTrace(IntegerDivisionByZeroException self  ) {
    return null;
  }
  
static String toString(IntegerDivisionByZeroException self  ) {
    return "IntegerDivisionByZeroException";
  }
  
}

/// 转换后的类: Function
class Function {
  Function();
  
static Function create(  ) {
    final instance = Function();
    ;
    return instance;
  }
  
}

/// 转换后的类: int
class int extends num {
  int();
  
}

/// 转换后的类: Invocation
class Invocation {
  Invocation();
  
static Invocation create(  ) {
    final instance = Invocation();
    ;
    return instance;
  }
  
static List typeArguments(Invocation self  ) {
    return const ListConstant(const <Type>[]);
  }
  
static bool isAccessor(Invocation self  ) {
    return self.isGetter || self.isSetter;
  }
  
}

/// 转换后的类: Iterable
class Iterable {
  Iterable();
  
static Iterable create(  ) {
    final instance = Iterable();
    ;
    return instance;
  }
  
static Iterable cast(Iterable self  ) {
    return CastIterable.(self);
  }
  
static Iterable followedBy(Iterable self, Iterable other  ) {
    {
      Iterable self = self;
if (self is EfficientLengthIterable)       {
        return FollowedByIterable.firstEfficient(self, other);
      }
      return FollowedByIterable.create(self, other);
    }
  }
  
static Iterable map(Iterable self, Function toElement  ) {
    return MappedIterable.(self, toElement);
  }
  
static Iterable where(Iterable self, Function test  ) {
    return WhereIterable.create(self, test);
  }
  
static Iterable whereType(Iterable self  ) {
    return WhereTypeIterable.create(self);
  }
  
static Iterable expand(Iterable self, Function toElements  ) {
    return ExpandIterable.create(self, toElements);
  }
  
static bool contains(Iterable self, Object element  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic e = self.current;
          {
if (e == element)             return true;
          }
        }
      }
      return false;
    }
  }
  
static dynamic forEach(Iterable self, Function action  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          functionInvocation(element);
        }
      }
    }
  }
  
static dynamic reduce(Iterable self, Function combine  ) {
    {
      Iterator iterator = self.iterator;
if (!moveNext(self))       {
        throw IterableElementError.noElement();
      }
      dynamic value = self.current;
while (moveNext(self))       {
        value = functionInvocation(value, self.current);
      }
      return value;
    }
  }
  
static dynamic fold(Iterable self, dynamic initialValue, Function combine  ) {
    {
      dynamic value = initialValue;
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          value = functionInvocation(value, element);
        }
      }
      return value;
    }
  }
  
static bool every(Iterable self, Function test  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (!functionInvocation(element))             return false;
          }
        }
      }
      return true;
    }
  }
  
static String join(Iterable self, String separator  ) {
    {
      Iterator iterator = self.iterator;
if (!moveNext(self))       return "";
      String first = toString(self, );
if (!moveNext(self))       return first;
      StringBuffer buffer = StringBuffer.create(first);
if (separator == null || self.isEmpty)       {
do         {
          write(self, toString(self, ));
        }
 while (moveNext(self));      }
 else       {
do         {
          let_expression;
        }
 while (moveNext(self));      }
      return toString(self, );
    }
  }
  
static bool any(Iterable self, Function test  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (functionInvocation(element))             return true;
          }
        }
      }
      return false;
    }
  }
  
static List toList(Iterable self, bool growable  ) {
    return List.of(self);
  }
  
static Set toSet(Iterable self  ) {
    return LinkedHashSet.of(self);
  }
  
static int length(Iterable self  ) {
    {
assert(!self is EfficientLengthIterable      );
      int count = 0;
      Iterator it = self.iterator;
while (moveNext(self))       {
        count = add(self, 1);
      }
      return count;
    }
  }
  
static bool isEmpty(Iterable self  ) {
    return !moveNext(self);
  }
  
static bool isNotEmpty(Iterable self  ) {
    return !self.isEmpty;
  }
  
static Iterable take(Iterable self, int count  ) {
    return TakeIterable.(self, count);
  }
  
static Iterable takeWhile(Iterable self, Function test  ) {
    return TakeWhileIterable.create(self, test);
  }
  
static Iterable skip(Iterable self, int count  ) {
    return SkipIterable.(self, count);
  }
  
static Iterable skipWhile(Iterable self, Function test  ) {
    return SkipWhileIterable.create(self, test);
  }
  
static dynamic first(Iterable self  ) {
    {
      Iterator it = self.iterator;
if (!moveNext(self))       {
        throw IterableElementError.noElement();
      }
      return self.current;
    }
  }
  
static dynamic last(Iterable self  ) {
    {
      Iterator it = self.iterator;
if (!moveNext(self))       {
        throw IterableElementError.noElement();
      }
      dynamic result;
do       {
        result = self.current;
      }
 while (moveNext(self));      return result;
    }
  }
  
static dynamic single(Iterable self  ) {
    {
      Iterator it = self.iterator;
if (!moveNext(self))       throw IterableElementError.noElement();
      dynamic result = self.current;
if (moveNext(self))       throw IterableElementError.tooMany();
      return result;
    }
  }
  
static dynamic firstWhere(Iterable self, Function test, Function orElse  ) {
    {
      {
        Iterator _sync_for_iterator = self.iterator;
for (; moveNext(self); )         {
          dynamic element = self.current;
          {
if (functionInvocation(element))             return element;
          }
        }
      }
if (!orElse == null)       return functionInvocation();
      throw IterableElementError.noElement();
    }
  }
  
static dynamic lastWhere(Iterable self, Function test, Function orElse  ) {
    {
      Iterator iterator = self.iterator;
      dynamic result;
do       {
if (!moveNext(self))         {
if (!orElse == null)           return functionInvocation();
          throw IterableElementError.noElement();
        }
        result = self.current;
      }
 while (!functionInvocation(result));while (moveNext(self))       {
        dynamic current = self.current;
if (functionInvocation(current))         result = current;
      }
      return result;
    }
  }
  
static dynamic singleWhere(Iterable self, Function test, Function orElse  ) {
    {
      Iterator iterator = self.iterator;
      dynamic result;
do       {
if (!moveNext(self))         {
if (!orElse == null)           return functionInvocation();
          throw IterableElementError.noElement();
        }
        result = self.current;
      }
 while (!functionInvocation(result));while (moveNext(self))       {
if (functionInvocation(self.current))         throw IterableElementError.tooMany();
      }
      return result;
    }
  }
  
static dynamic elementAt(Iterable self, int index  ) {
    {
      RangeError.checkNotNegative(index, "index");
      Iterator iterator = self.iterator;
      int skipCount = index;
while (moveNext(self))       {
if (skipCount == 0)         return self.current;
        skipCount = subtract(self, 1);
      }
      throw IndexError.create_withLength(index, subtract(self, skipCount));
    }
  }
  
static String toString(Iterable self  ) {
    return Iterable.iterableToShortString(self, "(", ")");
  }
  
}

/// 转换后的类: Iterator
class Iterator {
  Iterator();
  
static Iterator create(  ) {
    final instance = Iterator();
    ;
    return instance;
  }
  
}

/// 转换后的类: List
class List implements Iterable, _ListIterable {
  List();
  
}

/// 转换后的类: Map
class Map {
  Map();
  
}

/// 转换后的类: MapEntry
class MapEntry {
  late dynamic key;
  late dynamic value;
  
  MapEntry();
  
static MapEntry create__(dynamic key, dynamic value  ) {
    final instance = MapEntry();
    instance.key = key;
    instance.value = value;
    ;
    return instance;
  }
  
static String toString(MapEntry self  ) {
    return "MapEntry(" + self.key + ": " + self.value + ")";
  }
  
}

/// 转换后的类: Null
class Null {
  Null();
  
static int _identityHashCode(Null self  ) {
    return const IntConstant(2011);
  }
  
static int hashCode(Null self  ) {
    return const IntConstant(2011);
  }
  
static String toString(Null self  ) {
    return "null";
  }
  
}

/// 转换后的类: num
class num implements Comparable {
  num();
  
static num create(  ) {
    final instance = num();
    ;
    return instance;
  }
  
}

/// 转换后的类: Object
class Object {
  Object();
  
static Object create(  ) {
    final instance = Object();
    ;
    return instance;
  }
  
static int _identityHashCode(Object self  ) {
    return _getHash(self);
  }
  
static bool _instanceOf(Object self, dynamic instantiatorTypeArguments, dynamic functionTypeArguments, dynamic type  ) {
    // TODO: 实现方法体
  }
  
static bool _simpleInstanceOf(Object self, dynamic type  ) {
    // TODO: 实现方法体
  }
  
static bool _simpleInstanceOfTrue(Object self, dynamic type  ) {
    return true;
  }
  
static bool _simpleInstanceOfFalse(Object self, dynamic type  ) {
    return false;
  }
  
static int hashCode(Object self  ) {
    return _getHash(self);
  }
  
static String toString(Object self  ) {
    // TODO: 实现方法体
  }
  
static dynamic noSuchMethod(Object self, Invocation invocation  ) {
    {
      throw NoSuchMethodError.create__withInvocation(self, invocation);
    }
  }
  
static Type runtimeType(Object self  ) {
    // TODO: 实现方法体
  }
  
static bool equals(Object self, Object other  ) {
    // TODO: 实现方法体
  }
  
}

/// 转换后的类: Pattern
class Pattern {
  Pattern();
  
static Pattern create(  ) {
    final instance = Pattern();
    ;
    return instance;
  }
  
}

/// 转换后的类: Match
class Match {
  Match();
  
static Match create(  ) {
    final instance = Match();
    ;
    return instance;
  }
  
}

/// 转换后的类: Record
class Record {
  Record();
  
static Record create(  ) {
    final instance = Record();
    ;
    return instance;
  }
  
}

/// 转换后的类: RegExp
class RegExp implements Pattern {
  RegExp();
  
}

/// 转换后的类: RegExpMatch
class RegExpMatch implements Match {
  RegExpMatch();
  
static RegExpMatch create(  ) {
    final instance = RegExpMatch();
    ;
    return instance;
  }
  
}

/// 转换后的类: Set
class Set implements Iterable, _SetIterable {
  Set();
  
}

/// 转换后的类: Sink
class Sink {
  Sink();
  
static Sink create(  ) {
    final instance = Sink();
    ;
    return instance;
  }
  
}

/// 转换后的类: StackTrace
class StackTrace {
  StackTrace();
  
static StackTrace create(  ) {
    final instance = StackTrace();
    ;
    return instance;
  }
  
}

/// 转换后的类: Stopwatch
class Stopwatch {
  Stopwatch();
  
static Stopwatch create(  ) {
    final instance = Stopwatch();
    {
      self._frequency;
    }
    return instance;
  }
  
static int frequency(Stopwatch self  ) {
    return self._frequency;
  }
  
static dynamic start(Stopwatch self  ) {
    {
      int stop = self._stop;
if (!stop == null)       {
        self._start = +(self, subtract(self, stop));
        self._stop = null;
      }
    }
  }
  
static dynamic stop(Stopwatch self  ) {
    {
      self._stop == null ? self._stop = Stopwatch._now() : null;
    }
  }
  
static dynamic reset(Stopwatch self  ) {
    {
      self._start = let_expression;
    }
  }
  
static int elapsedTicks(Stopwatch self  ) {
    {
      return subtract(self, self._start);
    }
  }
  
static Duration elapsed(Stopwatch self  ) {
    {
      return Duration.create();
    }
  }
  
static int elapsedMicroseconds(Stopwatch self  ) {
    {
      int ticks = self.elapsedTicks;
if (self._frequency == 1000000000)       return ~/(self, 1000);
if (self._frequency == 1000000)       return ticks;
if (self._frequency == 1000)       return multiply(self, 1000);
if (lessThanOrEqual(self, ~/(self, 1000000)))       {
        return ~/(self, self._frequency);
      }
      int ticksPerSecond = ~/(self, self._frequency);
      int remainingTicks = unsafeCast(remainder(self, self._frequency));
      return +(self, ~/(self, self._frequency));
    }
  }
  
static int elapsedMilliseconds(Stopwatch self  ) {
    {
      int ticks = self.elapsedTicks;
if (self._frequency == 1000000000)       return ~/(self, 1000000);
if (self._frequency == 1000000)       return ~/(self, 1000);
if (self._frequency == 1000)       return ticks;
if (lessThanOrEqual(self, ~/(self, 1000)))       {
        return ~/(self, self._frequency);
      }
      int ticksPerSecond = ~/(self, self._frequency);
      int remainingTicks = unsafeCast(remainder(self, self._frequency));
      return +(self, ~/(self, self._frequency));
    }
  }
  
static bool isRunning(Stopwatch self  ) {
    return self._stop == null;
  }
  
}

/// 转换后的类: String
class String implements Comparable, Pattern {
  String();
  
}

/// 转换后的类: Runes
class Runes extends Iterable {
  late String string;
  
  Runes();
  
static Runes create(String string  ) {
    final instance = Runes();
    instance.string = string;
    ;
    return instance;
  }
  
static RuneIterator iterator(Runes self  ) {
    return RuneIterator.create(self.string);
  }
  
static int last(Runes self  ) {
    {
if (self.length == 0)       {
        throw StateError.create("No elements.");
      }
      int length = self.length;
      int code = codeUnitAt(self, subtract(self, 1));
if (_isTrailSurrogate(code) && greaterThan(self, 1))       {
        int previousCode = codeUnitAt(self, subtract(self, 2));
if (_isLeadSurrogate(previousCode))         {
          return _combineSurrogatePair(previousCode, code);
        }
      }
      return code;
    }
  }
  
}

/// 转换后的类: RuneIterator
class RuneIterator implements Iterator {
  late String string;
  
  RuneIterator();
  
static RuneIterator create(String string  ) {
    final instance = RuneIterator();
    instance.string = string;
    instance._position = 0;
    instance._nextPosition = 0;
    ;
    return instance;
  }
  
static RuneIterator create_at(String string, int index  ) {
    final instance = RuneIterator();
    instance.string = string;
    instance._position = index;
    instance._nextPosition = index;
    {
      RangeError.checkValueInInterval(index, 0, self.length);
      _checkSplitSurrogate(self, index);
    }
    return instance;
  }
  
static dynamic _checkSplitSurrogate(RuneIterator self, int index  ) {
    {
if (greaterThan(self, 0) && lessThan(self, self.length) && _isLeadSurrogate(codeUnitAt(self, subtract(self, 1))) && _isTrailSurrogate(codeUnitAt(self, index)))       {
        throw ArgumentError.create("Index inside surrogate pair: " + index);
      }
    }
  }
  
static int rawIndex(RuneIterator self  ) {
    return !self._position == self._nextPosition ? self._position : negate(self);
  }
  
static dynamic rawIndex(RuneIterator self, int rawIndex  ) {
    {
      IndexError.check(rawIndex, self.length);
      reset(self, rawIndex);
      moveNext(self);
    }
  }
  
static dynamic reset(RuneIterator self, int rawIndex  ) {
    {
      RangeError.checkValueInInterval(rawIndex, 0, self.length, "rawIndex");
      _checkSplitSurrogate(self, rawIndex);
      self._position = self._nextPosition = rawIndex;
      self._currentCodePoint = negate(self);
    }
  }
  
static int current(RuneIterator self  ) {
    return self._currentCodePoint;
  }
  
static int currentSize(RuneIterator self  ) {
    return subtract(self, self._position);
  }
  
static String currentAsString(RuneIterator self  ) {
    {
if (self._position == self._nextPosition)       return "";
if (add(self, 1) == self._nextPosition)       return getElement(self, self._position);
      return substring(self, self._position, self._nextPosition);
    }
  }
  
static bool moveNext(RuneIterator self  ) {
    {
      self._position = self._nextPosition;
if (self._position == self.length)       {
        self._currentCodePoint = negate(self);
        return false;
      }
      int codeUnit = codeUnitAt(self, self._position);
      int nextPosition = add(self, 1);
if (_isLeadSurrogate(codeUnit) && lessThan(self, self.length))       {
        int nextCodeUnit = codeUnitAt(self, nextPosition);
if (_isTrailSurrogate(nextCodeUnit))         {
          self._nextPosition = add(self, 1);
          self._currentCodePoint = _combineSurrogatePair(codeUnit, nextCodeUnit);
          return true;
        }
      }
      self._nextPosition = nextPosition;
      self._currentCodePoint = codeUnit;
      return true;
    }
  }
  
static bool movePrevious(RuneIterator self  ) {
    {
      self._nextPosition = self._position;
if (self._position == 0)       {
        self._currentCodePoint = negate(self);
        return false;
      }
      int position = subtract(self, 1);
      int codeUnit = codeUnitAt(self, position);
if (_isTrailSurrogate(codeUnit) && greaterThan(self, 0))       {
        int prevCodeUnit = codeUnitAt(self, subtract(self, 1));
if (_isLeadSurrogate(prevCodeUnit))         {
          self._position = subtract(self, 1);
          self._currentCodePoint = _combineSurrogatePair(prevCodeUnit, codeUnit);
          return true;
        }
      }
      self._position = position;
      self._currentCodePoint = codeUnit;
      return true;
    }
  }
  
}

/// 转换后的类: StringBuffer
class StringBuffer implements StringSink {
  StringBuffer();
  
static StringBuffer create(Object content  ) {
    final instance = StringBuffer();
    {
      write(self, content);
    }
    return instance;
  }
  
static dynamic _writeString(StringBuffer self, String str  ) {
    {
      _consumeBuffer(self, );
      _addPart(self, str);
    }
  }
  
static dynamic _ensureCapacity(StringBuffer self, int n  ) {
    {
      Uint16List localBuffer = self._buffer;
if (localBuffer == null)       {
        self._buffer = Uint16List.(const IntConstant(64));
      }
 else if (greaterThan(self, self.length))       {
        _consumeBuffer(self, );
      }
    }
  }
  
static dynamic _consumeBuffer(StringBuffer self  ) {
    {
if (self._bufferPosition == 0)       return Void;
      bool isLatin1 = lessThanOrEqual(self, 255);
      String str = StringBuffer._create(self._buffer!, self._bufferPosition, isLatin1);
      self._bufferPosition = self._bufferCodeUnitMagnitude = 0;
      _addPart(self, str);
    }
  }
  
static dynamic _addPart(StringBuffer self, String str  ) {
    {
      List localParts = self._parts;
      int length = self.length;
      self._partsCodeUnits = add(self, length);
      self._partsCodeUnitsSinceCompaction = add(self, length);
if (localParts == null)       {
        self._parts = let_expression;
      }
 else       {
        add(self, str);
        int partsSinceCompaction = subtract(self, self._partsCompactionIndex);
if (partsSinceCompaction == const IntConstant(128))         {
          _compact(self, );
        }
      }
    }
  }
  
static dynamic _compact(StringBuffer self  ) {
    {
      List localParts = self._parts!;
if (lessThan(self, const IntConstant(1024)))       {
        String compacted = _StringBase._concatRange(localParts, self._partsCompactionIndex, add(self, const IntConstant(128)));
        self.length = subtract(self, const IntConstant(128));
        add(self, compacted);
      }
      self._partsCodeUnitsSinceCompaction = 0;
      self._partsCompactionIndex = self.length;
    }
  }
  
static int length(StringBuffer self  ) {
    return add(self, self._bufferPosition);
  }
  
static bool isEmpty(StringBuffer self  ) {
    return self.length == 0;
  }
  
static bool isNotEmpty(StringBuffer self  ) {
    return !self.isEmpty;
  }
  
static dynamic write(StringBuffer self, Object obj  ) {
    {
      String str = toString(self, );
if (self.isEmpty)       return Void;
      _writeString(self, str);
    }
  }
  
static dynamic writeCharCode(StringBuffer self, int charCode  ) {
    {
if (lessThanOrEqual(self, 65535))       {
if (lessThan(self, 0))         {
          throw RangeError.create_range(charCode, 0, 1114111);
        }
        _ensureCapacity(self, 1);
        Uint16List localBuffer = self._buffer!;
        setElement(self, let_expression, charCode);
        self._bufferCodeUnitMagnitude = bitwiseOr(self, charCode);
      }
 else       {
if (greaterThan(self, 1114111))         {
          throw RangeError.create_range(charCode, 0, 1114111);
        }
        _ensureCapacity(self, 2);
        int bits = subtract(self, 65536);
        Uint16List localBuffer = self._buffer!;
        setElement(self, let_expression, bitwiseOr(self, rightShift(self, 10)));
        setElement(self, let_expression, bitwiseOr(self, bitwiseAnd(self, 1023)));
        self._bufferCodeUnitMagnitude = bitwiseOr(self, 65535);
      }
    }
  }
  
static dynamic writeAll(StringBuffer self, Iterable objects, String separator  ) {
    {
      Iterator iterator = self.iterator;
if (!moveNext(self))       return Void;
if (self.isEmpty)       {
do         {
          write(self, self.current);
        }
 while (moveNext(self));      }
 else       {
        write(self, self.current);
while (moveNext(self))         {
          write(self, separator);
          write(self, self.current);
        }
      }
    }
  }
  
static dynamic writeln(StringBuffer self, Object obj  ) {
    {
      write(self, obj);
      _writeString(self, "
");
    }
  }
  
static dynamic clear(StringBuffer self  ) {
    {
      self._parts = null;
      self._partsCodeUnits = self._bufferPosition = self._bufferCodeUnitMagnitude = 0;
    }
  }
  
static String toString(StringBuffer self  ) {
    {
      _consumeBuffer(self, );
      List localParts = self._parts;
      return self._partsCodeUnits == 0 || localParts == null ? "" : _StringBase._concatRange(localParts, 0, self.length);
    }
  }
  
}

/// 转换后的类: StringSink
class StringSink {
  StringSink();
  
static StringSink create(  ) {
    final instance = StringSink();
    ;
    return instance;
  }
  
}

/// 转换后的类: Symbol
class Symbol {
  Symbol();
  
}

/// 转换后的类: Type
class Type {
  Type();
  
static Type create(  ) {
    final instance = Type();
    ;
    return instance;
  }
  
}

/// 转换后的类: Uri
class Uri {
  Uri();
  
static bool hasScheme(Uri self  ) {
    return self.isNotEmpty;
  }
  
}

/// 转换后的类: UriData
class UriData {
  late String _text;
  late List _separatorIndices;
  
  UriData();
  
static UriData create__(String _text, List _separatorIndices, Uri _uriCache  ) {
    final instance = UriData();
    instance._text = _text;
    instance._separatorIndices = _separatorIndices;
    instance._uriCache = _uriCache;
    ;
    return instance;
  }
  
static Uri uri(UriData self  ) {
    {
      return let_expression;
    }
  }
  
static Uri _computeUri(UriData self  ) {
    {
      String path = self._text;
      String query;
      int colonIndex = getElement(self, 0);
      int queryIndex = indexOf(self, "?", add(self, 1));
      int end = self.length;
if (greaterThanOrEqual(self, 0))       {
        query = _Uri._normalizeOrSubstring(self._text, add(self, 1), end, const IntConstant(256));
        end = queryIndex;
      }
      path = _Uri._normalizeOrSubstring(self._text, add(self, 1), end, const IntConstant(128));
      return _DataUri.create(self, path, query);
    }
  }
  
static String mimeType(UriData self  ) {
    {
      int start = add(self, 1);
      int end = getElement(self, 1);
if (start == end)       return "text/plain";
      return _Uri._uriDecode(self._text, start, end, const InstanceConstant(const Utf8Codec{Utf8Codec._allowMalformed: false}), false);
    }
  }
  
static bool isMimeType(UriData self, String mimeType  ) {
    {
      int start = add(self, 1);
      int end = getElement(self, 1);
if (start == end)       {
        return self.isEmpty || identical(mimeType, "text/plain") || _caseInsensitiveEquals(mimeType, "text/plain");
      }
if (self.isEmpty)       mimeType = "text/plain";
      return self.length == subtract(self, start) && _caseInsensitiveStartsWith(mimeType, self._text, start);
    }
  }
  
static String charset(UriData self  ) {
    {
      int charsetIndex = _findCharsetIndex(self, );
if (greaterThanOrEqual(self, 0))       {
        int valueStart = add(self, 1);
        int valueEnd = getElement(self, add(self, 2));
        return _Uri._uriDecode(self._text, valueStart, valueEnd, const InstanceConstant(const Utf8Codec{Utf8Codec._allowMalformed: false}), false);
      }
      return "US-ASCII";
    }
  }
  
static int _findCharsetIndex(UriData self  ) {
    {
      List separatorIndices = self._separatorIndices;
for (int i = 3; lessThanOrEqual(self, self.length); i = add(self, 2))       {
        int keyStart = add(self, 1);
        int keyEnd = getElement(self, subtract(self, 1));
if (keyEnd == add(self, self.length) && _caseInsensitiveStartsWith("charset", self._text, keyStart))         {
          return subtract(self, 2);
        }
      }
      return negate(self);
    }
  }
  
static bool isCharset(UriData self, String charset  ) {
    {
      int charsetIndex = _findCharsetIndex(self, );
if (lessThan(self, 0))       {
        return self.isEmpty || _caseInsensitiveEquals(charset, "US-ASCII") || identical(Encoding.getByName(charset), const InstanceConstant(const AsciiCodec{AsciiCodec._allowInvalid: false}));
      }
if (self.isEmpty)       charset = "US-ASCII";
      int valueStart = add(self, 1);
      int valueEnd = getElement(self, add(self, 2));
      int length = subtract(self, valueStart);
if (self.length == length && _caseInsensitiveStartsWith(charset, self._text, valueStart))       {
        return true;
      }
      Encoding checkedEncoding = Encoding.getByName(charset);
      return !checkedEncoding == null && identical(checkedEncoding, Encoding.getByName(_Uri._uriDecode(self._text, valueStart, valueEnd, const InstanceConstant(const Utf8Codec{Utf8Codec._allowMalformed: false}), false)));
    }
  }
  
static bool isEncoding(UriData self, Encoding encoding  ) {
    {
      int charsetIndex = _findCharsetIndex(self, );
if (lessThan(self, 0))       {
        return identical(encoding, const InstanceConstant(const AsciiCodec{AsciiCodec._allowInvalid: false}));
      }
      int valueStart = add(self, 1);
      int valueEnd = getElement(self, add(self, 2));
      return identical(encoding, Encoding.getByName(_Uri._uriDecode(self._text, valueStart, valueEnd, const InstanceConstant(const Utf8Codec{Utf8Codec._allowMalformed: false}), false)));
    }
  }
  
static bool isBase64(UriData self  ) {
    return self.isOdd;
  }
  
static String contentText(UriData self  ) {
    return substring(self, add(self, 1));
  }
  
static Uint8List contentAsBytes(UriData self  ) {
    {
      String text = self._text;
      int start = add(self, 1);
if (self.isBase64)       {
        return convert(self, text, start);
      }
      int length = subtract(self, start);
for (int i = start; lessThan(self, self.length); i = add(self, 1))       {
        int codeUnit = codeUnitAt(self, i);
if (codeUnit == const IntConstant(37))         {
          i = add(self, 2);
          length = subtract(self, 2);
        }
      }
      Uint8List result = Uint8List.(length);
if (length == self.length)       {
        setRange(self, 0, length, self.codeUnits, start);
        return result;
      }
      int index = 0;
for (int i = start; lessThan(self, self.length); i = add(self, 1))       // TODO: 实现标签语句
      {
        int codeUnit = codeUnitAt(self, i);
if (!codeUnit == const IntConstant(37))         {
          setElement(self, let_expression, codeUnit);
        }
 else         {
if (lessThan(self, self.length))           {
            int byte = parseHexByte(text, add(self, 1));
if (greaterThanOrEqual(self, 0))             {
              setElement(self, let_expression, byte);
              i = add(self, 2);
              break;
            }
          }
          throw FormatException.create("Invalid percent escape", text, i);
        }
      }
assert(index == self.length      );
      return result;
    }
  }
  
static String contentAsString(UriData self, Encoding encoding  ) {
    {
if (encoding == null)       {
        String charset = self.charset;
        encoding = Encoding.getByName(charset);
if (encoding == null)         {
          throw UnsupportedError.create("Unknown charset: " + charset);
        }
      }
      String text = self._text;
      int start = add(self, 1);
if (self.isBase64)       {
        Converter converter = fuse(self, self.decoder);
        return convert(self, substring(self, start));
      }
      return _Uri._uriDecode(text, start, self.length, encoding, false);
    }
  }
  
static Map parameters(UriData self  ) {
    {
      Map result = {};
for (int i = 3; lessThan(self, self.length); i = add(self, 2))       {
        int start = add(self, 1);
        int equals = getElement(self, subtract(self, 1));
        int end = getElement(self, i);
        String key = _Uri._uriDecode(self._text, start, equals, const InstanceConstant(const Utf8Codec{Utf8Codec._allowMalformed: false}), false);
        String value = _Uri._uriDecode(self._text, add(self, 1), end, const InstanceConstant(const Utf8Codec{Utf8Codec._allowMalformed: false}), false);
        setElement(self, key, value);
      }
      return result;
    }
  }
  
static String toString(UriData self  ) {
    return getElement(self, 0) == const IntConstant(-1) ? "data:" + self._text : self._text;
  }
  
}

/// 转换后的类: Expando
class Expando {
  late String name;
  
  Expando();
  
static Expando create(String name  ) {
    final instance = Expando();
    instance.name = name;
    instance._data = _List.(const IntConstant(8));
    instance._used = 0;
    ;
    return instance;
  }
  
static dynamic _rehash(Expando self  ) {
    {
      int count = 0;
      List old_data = self._data;
      int len = self.length;
for (int i = 0; lessThan(self, len); i = add(self, 1))       {
        _WeakProperty entry = getElement(self, i);
if (!entry == null && !self.key == null)         {
          count = add(self, 1);
        }
      }
      int new_size = self._size;
if (lessThanOrEqual(self, rightShift(self, 2)))       {
        new_size = rightShift(self, 1);
      }
 else if (greaterThan(self, rightShift(self, 1)))       {
        new_size = leftShift(self, 1);
      }
      new_size = lessThan(self, const IntConstant(8)) ? const IntConstant(8) : new_size;
      self._data = _List.(new_size);
      self._used = 0;
for (int i = 0; lessThan(self, self.length); i = add(self, 1))       {
        _WeakProperty entry = getElement(self, i);
if (!entry == null)         {
          dynamic val = self.value;
          dynamic key = self.key;
if (!key == null)           {
            setElement(self, let_expression, val as dynamic);
          }
        }
      }
    }
  }
  
static int _size(Expando self  ) {
    return self.length;
  }
  
static int _limit(Expando self  ) {
    return *(self, ~/(self, 4));
  }
  
static String toString(Expando self  ) {
    return "Expando:" + self.name;
  }
  
static dynamic getElement(Expando self, Object object  ) {
    {
      checkValidWeakTarget(object, "object");
      int mask = subtract(self, 1);
      int idx = bitwiseAnd(self, mask);
      _WeakProperty wp = getElement(self, idx);
while (!wp == null)       {
if (identical(self.key, object))         {
          return unsafeCast(self.value);
        }
 else if (self.key == null)         {
          setElement(self, idx, self._deletedEntry);
        }
        idx = bitwiseAnd(self, mask);
        wp = getElement(self, idx);
      }
      return null;
    }
  }
  
static dynamic setElement(Expando self, Object objectdynamic value  ) {
    {
      checkValidWeakTarget(object, "object");
      int mask = subtract(self, 1);
      int idx = bitwiseAnd(self, mask);
      int empty_idx = negate(self);
      _WeakProperty wp = getElement(self, idx);
while (!wp == null)       {
if (identical(self.key, object))         {
if (!value == null)           {
            self.value = value;
          }
 else           {
            setElement(self, idx, self._deletedEntry);
          }
          return Void;
        }
 else if (lessThan(self, 0) && identical(wp, self._deletedEntry))         {
          empty_idx = idx;
        }
 else if (self.key == null)         {
          setElement(self, idx, self._deletedEntry);
if (lessThan(self, 0))           {
            empty_idx = idx;
          }
        }
        idx = bitwiseAnd(self, mask);
        wp = getElement(self, idx);
      }
if (value == null)       {
        return Void;
      }
if (greaterThanOrEqual(self, 0))       {
        self._used = subtract(self, 1);
        idx = empty_idx;
      }
if (lessThan(self, self._limit))       {
        _WeakProperty ephemeron = _WeakProperty.create();
        self.key = object;
        self.value = value;
        setElement(self, idx, ephemeron);
        self._used = add(self, 1);
        return Void;
      }
      _rehash(self, );
      setElement(self, object, value);
    }
  }
  
}

/// 转换后的类: WeakReference
class WeakReference {
  WeakReference();
  
}

/// 转换后的类: Finalizer
class Finalizer {
  Finalizer();
  
}

/// 转换后的类: HttpServer
class HttpServer implements Stream {
  HttpServer();
  
}

/// 转换后的类: HttpConnectionsInfo
class HttpConnectionsInfo {
  HttpConnectionsInfo();
  
static HttpConnectionsInfo create(  ) {
    final instance = HttpConnectionsInfo();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpHeaders
class HttpHeaders {
  HttpHeaders();
  
static HttpHeaders create(  ) {
    final instance = HttpHeaders();
    ;
    return instance;
  }
  
}

/// 转换后的类: HeaderValue
class HeaderValue {
  HeaderValue();
  
}

/// 转换后的类: HttpSession
class HttpSession implements Map {
  HttpSession();
  
static HttpSession create(  ) {
    final instance = HttpSession();
    ;
    return instance;
  }
  
}

/// 转换后的类: ContentType
class ContentType implements HeaderValue {
  ContentType();
  
}

/// 转换后的类: SameSite
class SameSite {
  late String name;
  
  SameSite();
  
static SameSite create__(String name  ) {
    final instance = SameSite();
    instance.name = name;
    ;
    return instance;
  }
  
static String toString(SameSite self  ) {
    return "SameSite=" + self.name;
  }
  
}

/// 转换后的类: Cookie
class Cookie {
  Cookie();
  
}

/// 转换后的类: HttpRequest
class HttpRequest implements Stream {
  HttpRequest();
  
static HttpRequest create(  ) {
    final instance = HttpRequest();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpResponse
class HttpResponse implements IOSink {
  HttpResponse();
  
static HttpResponse create(  ) {
    final instance = HttpResponse();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpClient
class HttpClient {
  HttpClient();
  
}

/// 转换后的类: HttpClientRequest
class HttpClientRequest implements IOSink {
  HttpClientRequest();
  
static HttpClientRequest create(  ) {
    final instance = HttpClientRequest();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpClientResponse
class HttpClientResponse implements Stream {
  HttpClientResponse();
  
static HttpClientResponse create(  ) {
    final instance = HttpClientResponse();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpClientResponseCompressionState
class HttpClientResponseCompressionState extends _Enum {
  HttpClientResponseCompressionState();
  
static HttpClientResponseCompressionState create(int _index, String _name  ) {
    final instance = HttpClientResponseCompressionState();
    ;
    return instance;
  }
  
static String _enumToString(HttpClientResponseCompressionState self  ) {
    return "HttpClientResponseCompressionState." + self._name;
  }
  
}

/// 转换后的类: HttpClientCredentials
class HttpClientCredentials {
  HttpClientCredentials();
  
static HttpClientCredentials create(  ) {
    final instance = HttpClientCredentials();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpClientBasicCredentials
class HttpClientBasicCredentials implements HttpClientCredentials {
  HttpClientBasicCredentials();
  
}

/// 转换后的类: HttpClientDigestCredentials
class HttpClientDigestCredentials implements HttpClientCredentials {
  HttpClientDigestCredentials();
  
}

/// 转换后的类: HttpConnectionInfo
class HttpConnectionInfo {
  HttpConnectionInfo();
  
static HttpConnectionInfo create(  ) {
    final instance = HttpConnectionInfo();
    ;
    return instance;
  }
  
}

/// 转换后的类: RedirectInfo
class RedirectInfo {
  RedirectInfo();
  
static RedirectInfo create(  ) {
    final instance = RedirectInfo();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpException
class HttpException implements IOException {
  late String message;
  late Uri uri;
  
  HttpException();
  
static HttpException create(String message, Uri uri  ) {
    final instance = HttpException();
    instance.message = message;
    instance.uri = uri;
    ;
    return instance;
  }
  
static String toString(HttpException self  ) {
    {
      StringBuffer b = let_expression;
      Uri uri = self.uri;
if (!uri == null)       {
        write(self, ", uri = " + uri);
      }
      return toString(self, );
    }
  }
  
}

/// 转换后的类: RedirectException
class RedirectException implements HttpException {
  late String message;
  late List redirects;
  
  RedirectException();
  
static RedirectException create(String message, List redirects  ) {
    final instance = RedirectException();
    instance.message = message;
    instance.redirects = redirects;
    ;
    return instance;
  }
  
static String toString(RedirectException self  ) {
    return "RedirectException: " + self.message;
  }
  
static Uri uri(RedirectException self  ) {
    return self.isEmpty ? null : self.location;
  }
  
}

/// 转换后的类: HttpDate
class HttpDate {
  HttpDate();
  
static HttpDate create(  ) {
    final instance = HttpDate();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpProfiler
class HttpProfiler {
  HttpProfiler();
  
static HttpProfiler create(  ) {
    final instance = HttpProfiler();
    ;
    return instance;
  }
  
}

/// 转换后的类: ServerSocketBase
class ServerSocketBase implements Stream {
  ServerSocketBase();
  
static ServerSocketBase create(  ) {
    final instance = ServerSocketBase();
    ;
    return instance;
  }
  
}

/// 转换后的类: HttpOverrides
class HttpOverrides {
  HttpOverrides();
  
static HttpOverrides create(  ) {
    final instance = HttpOverrides();
    ;
    return instance;
  }
  
static HttpClient createHttpClient(HttpOverrides self, SecurityContext context  ) {
    {
      return _HttpClient.create(context);
    }
  }
  
static String findProxyFromEnvironment(HttpOverrides self, Uri url, Map environment  ) {
    {
      return _HttpClient._findProxyFromEnvironment(url, environment);
    }
  }
  
}

/// 转换后的类: WebSocketStatus
class WebSocketStatus {
  WebSocketStatus();
  
static WebSocketStatus create(  ) {
    final instance = WebSocketStatus();
    ;
    return instance;
  }
  
}

/// 转换后的类: CompressionOptions
class CompressionOptions {
  late bool clientNoContextTakeover;
  late bool serverNoContextTakeover;
  late int clientMaxWindowBits;
  late int serverMaxWindowBits;
  late bool enabled;
  
  CompressionOptions();
  
static CompressionOptions create(bool clientNoContextTakeover, bool serverNoContextTakeover, int clientMaxWindowBits, int serverMaxWindowBits, bool enabled  ) {
    final instance = CompressionOptions();
    instance.clientNoContextTakeover = clientNoContextTakeover;
    instance.serverNoContextTakeover = serverNoContextTakeover;
    instance.clientMaxWindowBits = clientMaxWindowBits;
    instance.serverMaxWindowBits = serverMaxWindowBits;
    instance.enabled = enabled;
    ;
    return instance;
  }
  
static _CompressionMaxWindowBits _createServerResponseHeader(CompressionOptions self, HeaderValue requested  ) {
    {
      _CompressionMaxWindowBits info = _CompressionMaxWindowBits.create("", 0);
      String part = let_expression;
if (!part == null)       {
if (greaterThanOrEqual(self, 2) && startsWith(self, "0"))         {
          throw ArgumentError.create("Illegal 0 padding on value.");
        }
 else         {
          int mwb = let_expression;
          self.headerValue = "; server_max_window_bits=" + mwb;
          self.maxWindowBits = mwb;
        }
      }
 else       {
        self.headerValue = "";
        self.maxWindowBits = const IntConstant(15);
      }
      return info;
    }
  }
  
static String _createClientRequestHeader(CompressionOptions self, HeaderValue requested, int size  ) {
    {
      String info = "";
if (!requested == null)       {
        info = "; client_max_window_bits=" + size;
      }
 else       {
if (self.clientMaxWindowBits == null)         {
          info = "; client_max_window_bits";
        }
 else         {
          info = "; client_max_window_bits=" + self.clientMaxWindowBits;
        }
if (!self.serverMaxWindowBits == null)         {
          info = add(self, "; server_max_window_bits=" + self.serverMaxWindowBits);
        }
      }
      return info;
    }
  }
  
static _CompressionMaxWindowBits _createHeader(CompressionOptions self, HeaderValue requested  ) {
    {
      _CompressionMaxWindowBits info = _CompressionMaxWindowBits.create("", 0);
if (!self.enabled)       {
        return info;
      }
      self.headerValue = const StringConstant("permessage-deflate");
if (self.clientNoContextTakeover && requested == null || containsKey(self, const StringConstant("client_no_context_takeover")))       {
        let_expression;
      }
if (self.serverNoContextTakeover && requested == null || containsKey(self, const StringConstant("server_no_context_takeover")))       {
        let_expression;
      }
      _CompressionMaxWindowBits headerList = _createServerResponseHeader(self, requested);
      let_expression;
      self.maxWindowBits = self.maxWindowBits;
      let_expression;
      return info;
    }
  }
  
}

/// 转换后的类: WebSocketTransformer
class WebSocketTransformer implements StreamTransformer {
  WebSocketTransformer();
  
}

/// 转换后的类: WebSocket
class WebSocket implements Stream, StreamSink {
  WebSocket();
  
static WebSocket create(  ) {
    final instance = WebSocket();
    ;
    return instance;
  }
  
}

/// 转换后的类: WebSocketException
class WebSocketException implements IOException {
  late String message;
  late int httpStatusCode;
  
  WebSocketException();
  
static WebSocketException create(String message, int httpStatusCode  ) {
    final instance = WebSocketException();
    instance.message = message;
    instance.httpStatusCode = httpStatusCode;
    ;
    return instance;
  }
  
static String toString(WebSocketException self  ) {
    {
if (!self.httpStatusCode == null)       {
        return "WebSocketException: " + self.message + ", HTTP status code: " + self.httpStatusCode;
      }
      return "WebSocketException: " + self.message;
    }
  }
  
}

