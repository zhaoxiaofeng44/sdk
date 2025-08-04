import 'dart:core';
import 'dart:io';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 转换后的类: CppList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppList<E> extends CppIterable<E> implements List<E> {
  int _length;
  CppUserData _array;
  
  @pragma()
CppList.fromCppArray(CppUserData array) {    ;
  }
  
CppList(int length, int capacity) {    ;
  }
  
void ensureCapacity(int newLen  ) {
if (newLen > CppApi.cppGetPointerArrayLength(this._array))     CppUserData newArray = CppApi.cppCreatePointerArray(CppList._getSuggestCapacity(newLen));
for (int i = 0; i < CppApi.cppGetPointerArrayLength(this._array); i = i + 1)     CppApi.cppSetPointerArrayItem(newArray, i, CppApi.cppGetPointerArrayItem(this._array, i));
    this._array = newArray;
  }
  
void add(E value  ) {
    this.ensureCapacity(this._length + 1);
    CppApi.cppSetPointerArrayItem(this._array, unknown, value);
  }
  
void addAll(Iterable<E> iterable  ) {
    Iterator<E> _sync_for_iterator = iterable.iterator;
for (; _sync_for_iterator.moveNext(); )     E element = entry;
    this.add(element);
  }
  
bool any(Function test  ) {
for (int i = 0; i < this._length; i = i + 1) if (CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E))     return true;
    return false;
  }
  
Map<int, E> asMap(  ) {
    Map<int, E> map = {};
for (int i = 0; i < this._length; i = i + 1)     map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as E;
    return map;
  }
  
List<R> cast(  ) {
    return CppList.castFrom(this);
  }
  
void clear(  ) {
    this._length = 0;
  }
  
bool contains(Object element  ) {
for (int i = 0; i < this._length; i = i + 1) if (CppApi.cppGetPointerArrayItem(this._array, i) == element)     return true;
    return false;
  }
  
E elementAt(int index  ) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as E;
  }
  
bool every(Function test  ) {
for (int i = 0; i < this._length; i = i + 1) if (!CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E))     return false;
    return true;
  }
  
void fillRange(int start, int end, E fillValue = null  ) {
for (int i = start; i < end; i = i + 1)     CppApi.cppSetPointerArrayItem(this._array, i, unknown == null ? unknown as E : unknown);
  }
  
E firstWhere(Function test, {Function orElse = null}  ) {
for (int i = 0; i < this._length; i = i + 1) if (CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E))     return CppApi.cppGetPointerArrayItem(this._array, i) as E;
if (!orElse == null)     return CppList.functionInvocation();
    throw StateError("No element");
  }
  
T fold(T initialValue, Function combine  ) {
    T value = initialValue;
for (int i = 0; i < this._length; i = i + 1)     value = CppList.functionInvocation(value, CppApi.cppGetPointerArrayItem(this._array, i) as E);
    return value;
  }
  
void forEach(Function action  ) {
for (int i = 0; i < this._length; i = i + 1)     CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E);
  }
  
Iterable<E> getRange(int start, int end  ) {
    return CppList.from(Iterable.generate(end - start, (int i) { /* TODO: 实现匿名函数 */ return null as Object; }));
  }
  
int indexOf(E element, int start = 0  ) {
for (int i = start; i < this._length; i = i + 1) if (CppApi.cppGetPointerArrayItem(this._array, i) == element)     return i;
    return -1;
  }
  
int indexWhere(Function test, int start = 0  ) {
for (int i = start; i < this._length; i = i + 1) if (CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E))     return i;
    return -1;
  }
  
void insert(int index, E element  ) {
if (index < 0 || index > this._length)     throw IndexError(index, this);
    this.ensureCapacity(this._length + 1);
for (int i = this._length; i > index; i = i - 1)     CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i - 1));
    CppApi.cppSetPointerArrayItem(this._array, index, element);
    this._length = this._length + 1;
  }
  
void insertAll(int index, Iterable<E> iterable  ) {
if (index < 0 || index > this._length)     throw IndexError(index, this);
    List<E> elements = iterable.toList();
    int insertLength = elements.length;
if (insertLength == 0)     return Void;
    this.ensureCapacity(this._length + insertLength);
for (int i = this._length - 1; i >= index; i = i - 1)     CppApi.cppSetPointerArrayItem(this._array, i + insertLength, CppApi.cppGetPointerArrayItem(this._array, i));
for (int i = 0; i < insertLength; i = i + 1)     CppApi.cppSetPointerArrayItem(this._array, index + i, elements[i]);
    this._length = this._length + insertLength;
  }
  
String join(String separator = ''  ) {
if (this._length == 0)     return "";
    return CppApi.cppJoinListString(this._array, separator);
  }
  
int lastIndexOf(E element, int start = null  ) {
    int startIndex = unknown == null ? this._length - 1 : unknown;
for (int i = startIndex; i >= 0; i = i - 1) if (CppApi.cppGetPointerArrayItem(this._array, i) == element)     return i;
    return -1;
  }
  
int lastIndexWhere(Function test, int start = null  ) {
    int startIndex = unknown == null ? this._length - 1 : unknown;
for (int i = startIndex; i >= 0; i = i - 1) if (CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E))     return i;
    return -1;
  }
  
E lastWhere(Function test, {Function orElse = null}  ) {
for (int i = this._length - 1; i >= 0; i = i - 1) if (CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E))     return CppApi.cppGetPointerArrayItem(this._array, i) as E;
if (!orElse == null)     return CppList.functionInvocation();
    throw StateError("No element");
  }
  
E reduce(Function combine  ) {
if (this._length == 0)     throw StateError("No element");
    E value = CppApi.cppGetPointerArrayItem(this._array, 0) as E;
for (int i = 1; i < this._length; i = i + 1)     value = CppList.functionInvocation(value, CppApi.cppGetPointerArrayItem(this._array, i) as E);
    return value;
  }
  
bool remove(Object value  ) {
    int index = this.indexOf(value as E);
if (!index == -1)     this.removeAt(index);
    return true;
    return false;
  }
  
E removeAt(int index  ) {
if (index < 0 || index >= this._length)     throw IndexError(index, this);
    Object element = CppApi.cppGetPointerArrayItem(this._array, index);
for (int i = index; i < this._length - 1; i = i + 1)     CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i + 1));
    this._length = this._length - 1;
    return element as E;
  }
  
E removeLast(  ) {
if (this._length == 0)     throw StateError("No element");
    return this.removeAt(this._length - 1);
  }
  
void removeRange(int start, int end  ) {
if (start < 0 || start > this._length || end < start || end > this._length)     throw RangeError.range(start, 0, this._length);
    int length = end - start;
for (int i = start; i < this._length - length; i = i + 1)     CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i + length));
    this._length = this._length - length;
  }
  
void removeWhere(Function test  ) {
    int writeIndex = 0;
for (int readIndex = 0; readIndex < this._length; readIndex = readIndex + 1) if (!CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E)) if (!writeIndex == readIndex)     CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
    writeIndex = writeIndex + 1;
    this._length = writeIndex;
  }
  
void replaceRange(int start, int end, Iterable<E> replacements  ) {
if (start < 0 || start > this._length || end < start || end > this._length)     throw RangeError.range(start, 0, this._length);
    List<E> replacementList = replacements.toList();
    int replacementLength = replacementList.length;
    int rangeLength = end - start;
if (replacementLength > rangeLength)     this.ensureCapacity(this._length + replacementLength - rangeLength);
if (!replacementLength == rangeLength) for (int i = this._length - 1; i >= end; i = i - 1)     CppApi.cppSetPointerArrayItem(this._array, i + replacementLength - rangeLength, CppApi.cppGetPointerArrayItem(this._array, i));
for (int i = 0; i < replacementLength; i = i + 1)     CppApi.cppSetPointerArrayItem(this._array, start + i, replacementList[i]);
    this._length = this._length + replacementLength - rangeLength;
  }
  
void retainWhere(Function test  ) {
    int writeIndex = 0;
for (int readIndex = 0; readIndex < this._length; readIndex = readIndex + 1) if (CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E)) if (!writeIndex == readIndex)     CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
    writeIndex = writeIndex + 1;
    this._length = writeIndex;
  }
  
void setAll(int index, Iterable<E> iterable  ) {
if (index < 0 || index > this._length)     throw IndexError(index, this);
    int i = index;
    Iterator<E> _sync_for_iterator = iterable.iterator;
for (; _sync_for_iterator.moveNext(); )     E element = entry;
if (i >= this._length)     this.add(element);
 else     CppApi.cppSetPointerArrayItem(this._array, i, element);
    i = i + 1;
  }
  
void setRange(int start, int end, Iterable<E> iterable, int skipCount = 0  ) {
if (start < 0 || start > this._length || end < start || end > this._length)     throw RangeError.range(start, 0, this._length);
    Iterator<E> iterator = iterable.iterator;
for (int i = 0; i < skipCount; i = i + 1) if (!iterator.moveNext())     return Void;
    // TODO: 实现标签语句
for (int i = start; i < end; i = i + 1) if (!iterator.moveNext())     break;
    CppApi.cppSetPointerArrayItem(this._array, i, iterator.current);
  }
  
void shuffle(Random random = null  ) {
    random == null ? random = Random.() : null;
for (int i = this._length - 1; i > 0; i = i - 1)     int j = random.nextInt(i + 1);
    Object temp = CppApi.cppGetPointerArrayItem(this._array, i);
    CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
    CppApi.cppSetPointerArrayItem(this._array, j, temp);
  }
  
void sort(Function compare = null  ) {
if (this._length <= 1)     return Void;
    this._quickSort(0, this._length - 1, compare);
  }
  
void _quickSort(int low, int high, Function compare  ) {
if (low < high)     int pi = this._partition(low, high, compare);
    this._quickSort(low, pi - 1, compare);
    this._quickSort(pi + 1, high, compare);
  }
  
int _partition(int low, int high, Function compare  ) {
    E pivot = CppApi.cppGetPointerArrayItem(this._array, high) as E;
    int i = low - 1;
for (int j = low; j < high; j = j + 1)     E current = CppApi.cppGetPointerArrayItem(this._array, j) as E;
    bool shouldSwap;
if (!compare == null)     shouldSwap = CppList.functionInvocation(current, pivot) <= 0;
 else     shouldSwap = current as Comparable<dynamic>.compareTo(pivot) <= 0;
if (shouldSwap)     i = i + 1;
    this._swap(i, j);
    this._swap(i + 1, high);
    return i + 1;
  }
  
void _swap(int i, int j  ) {
    E temp = CppApi.cppGetPointerArrayItem(this._array, i) as E;
    CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
    CppApi.cppSetPointerArrayItem(this._array, j, temp);
  }
  
List<E> sublist(int start, int end = null  ) {
    int endIndex = unknown == null ? this._length : unknown;
if (start < 0 || start > this._length || endIndex < start || endIndex > this._length)     throw RangeError.range(start, 0, this._length);
    return CppList.from(Iterable.generate(endIndex - start, (int i) { /* TODO: 实现匿名函数 */ return null as Object; }));
  }
  
List<E> toList({bool growable = true}  ) {
    return CppList.from(this);
  }
  
Set<E> toSet(  ) {
    return CppSet.from(this);
  }
  
E singleWhere(Function test, {Function orElse = null}  ) {
    E result;
    bool found = false;
for (int i = 0; i < this._length; i = i + 1) if (CppList.functionInvocation(CppApi.cppGetPointerArrayItem(this._array, i) as E)) if (found)     throw StateError("Too many elements");
    result = CppApi.cppGetPointerArrayItem(this._array, i) as E;
    found = true;
if (found)     return result!;
if (!orElse == null)     return CppList.functionInvocation();
    throw StateError("No element");
  }
  
String toString(  ) {
if (this._length == 0)     return "[]";
    StringBuffer buffer = StringBuffer("[");
    buffer.write(CppApi.cppGetPointerArrayItem(this._array, 0));
for (int i = 1; i < this._length; i = i + 1)     buffer.write(", ");
    buffer.write(CppApi.cppGetPointerArrayItem(this._array, i));
    buffer.write("]");
    return buffer.toString();
  }
  
  int get length => null;
  
  set length(int value) {
    this.ensureCapacity(newLen);
    this._length = newLen;
  }
  
  E get first => null;
  
  set first(E value) {
if (this._length == 0)     throw StateError("No element");
    CppApi.cppSetPointerArrayItem(this._array, 0, value);
  }
  
  E get last => null;
  
  set last(E value) {
if (this._length == 0)     throw StateError("No element");
    CppApi.cppSetPointerArrayItem(this._array, this._length - 1, value);
  }
  
  E get single => null;
  
  bool get isEmpty => null;
  
  bool get isNotEmpty => null;
  
  Iterator<E> get iterator => null;
  
E operator [](int index  ) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as E;
  }
  
void operator []=(int index, E value  ) {
    return CppApi.cppSetPointerArrayItem(this._array, index, value);
  }
  
List<E> operator +(List<E> other  ) {
    CppList<E> result = CppList(0, this._length + other.length);
for (int i = 0; i < this._length; i = i + 1)     result.add(CppApi.cppGetPointerArrayItem(this._array, i) as E);
    Iterator<E> _sync_for_iterator = other.iterator;
for (; _sync_for_iterator.moveNext(); )     E element = entry;
    result.add(element);
    return result;
  }
  
}

/// 转换后的类: _CppListIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class _CppListIterator<E> implements Iterator<E> {
  final CppList<E> _list;
  int _index = -1;
  
_CppListIterator(CppList<E> _list) {    ;
  }
  
bool moveNext(  ) {
    this._index = this._index + 1;
    return this._index < this._list.length;
  }
  
  E get current => null;
  
}

/// 转换后的类: CppSet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppSet<E> extends CppIterable<E> implements Set<E> {
  final CppList<E> _list;
  
  @pragma()
CppSet.fromCppArray(CppUserData array) {    ;
  }
  
CppSet(int capacity = 4) {    ;
  }
  
bool add(E value  ) {
if (this.contains(value))     return false;
    this._list.add(value);
    return true;
  }
  
void addAll(Iterable<E> elements  ) {
    Iterator<E> _sync_for_iterator = elements.iterator;
for (; _sync_for_iterator.moveNext(); )     E element = entry;
    this.add(element);
  }
  
Set<R> cast(  ) {
    return CppSet.castFrom(this);
  }
  
void clear(  ) {
    this._list.clear();
  }
  
bool contains(Object element  ) {
for (int i = 0; i < this._list.length; i = i + 1) if (element == this._list[i])     return true;
    return false;
  }
  
bool containsAll(Iterable<Object> other  ) {
    Iterator<Object> _sync_for_iterator = other.iterator;
for (; _sync_for_iterator.moveNext(); )     Object element = entry;
if (!this.contains(element))     return false;
    return true;
  }
  
Set<E> difference(Set<Object> other  ) {
    CppSet<E> result = CppSet();
    Iterator<E> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     E element = entry;
if (!other.contains(element))     result.add(element);
    return result;
  }
  
E elementAt(int index  ) {
    return this._list.elementAt(index);
  }
  
Set<E> intersection(Set<Object> other  ) {
    CppSet<E> result = CppSet();
    Iterator<E> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     E element = entry;
if (other.contains(element))     result.add(element);
    return result;
  }
  
E lookup(Object element  ) {
for (int i = 0; i < this._list.length; i = i + 1) if (element == this._list[i])     return this._list[i];
    return null;
  }
  
bool remove(Object value  ) {
    return this._list.remove(value);
  }
  
void removeAll(Iterable<Object> elementsToRemove  ) {
    Iterator<Object> _sync_for_iterator = elementsToRemove.iterator;
for (; _sync_for_iterator.moveNext(); )     Object element = entry;
    this.remove(element);
  }
  
void removeWhere(Function test  ) {
    this._list.removeWhere(test);
  }
  
void retainAll(Iterable<Object> elementsToRetain  ) {
    CppSet<dynamic> retainSet = CppSet.from(elementsToRetain);
    this.removeWhere((E element) { /* TODO: 实现匿名函数 */ return null as bool; });
  }
  
void retainWhere(Function test  ) {
    this._list.retainWhere(test);
  }
  
Set<E> union(Set<E> other  ) {
    CppSet<E> result = CppSet();
    result.addAll(this);
    result.addAll(other);
    return result;
  }
  
String toString(  ) {
if (this._list.isEmpty)     return "{}";
    StringBuffer buffer = StringBuffer("{");
    Iterator<E> iterator = this._list.iterator;
if (iterator.moveNext())     buffer.write(iterator.current);
while (iterator.moveNext())     buffer.write(", ");
    buffer.write(iterator.current);
    buffer.write("}");
    return buffer.toString();
  }
  
  E get first => null;
  
  E get last => null;
  
  E get single => null;
  
  bool get isEmpty => null;
  
  bool get isNotEmpty => null;
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppMap<K, V> implements Map<K, V> {
  final CppList<MapEntry<K, V>> _list;
  
  @pragma()
CppMap.fromCppArray(CppUserData array) {    ;
  }
  
CppMap(int capacity = 4) {    ;
  }
  
void addAll(Map<K, V> other  ) {
    other.forEach((K k, V v) { /* TODO: 实现匿名函数 */ return null as void; });
  }
  
void addEntries(Iterable<MapEntry<K, V>> entries  ) {
    Iterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
for (; _sync_for_iterator.moveNext(); )     MapEntry<K, V> entry = entry;
    this[entry.key] = entry.value;
  }
  
Map<RK, RV> cast(  ) {
    return CppMap.castFrom(this);
  }
  
void clear(  ) {
    this._list.clear();
  }
  
bool containsKey(Object key  ) {
    Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     MapEntry<K, V> entry = entry;
if (entry.key == key)     return true;
    return false;
  }
  
bool containsValue(Object value  ) {
    Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     MapEntry<K, V> entry = entry;
if (entry.value == value)     return true;
    return false;
  }
  
void forEach(Function action  ) {
    Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     MapEntry<K, V> entry = entry;
    CppMap.functionInvocation(entry.key, entry.value);
  }
  
V putIfAbsent(K key, Function ifAbsent  ) {
    Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     MapEntry<K, V> entry = entry;
if (entry.key == key)     return entry.value;
    V v = CppMap.functionInvocation();
    this._list.add(MapEntry._(key, v));
    return v;
  }
  
V remove(Object key  ) {
for (int i = 0; i < this._list.length; i = i + 1) if (this._list[i].key == key)     V v = this._list[i].value;
for (int j = i; j < this._list.length - 1; j = j + 1)     this._list[j] = this._list[j + 1];
    this.length = this._list.length - 1;
    return v;
    return null;
  }
  
void removeWhere(Function test  ) {
    int i = 0;
while (i < this._list.length)     MapEntry<K, V> entry = this._list[i];
if (CppMap.functionInvocation(entry.key, entry.value))     this.remove(entry.key);
 else     i = i + 1;
  }
  
V update(K key, Function update, {Function ifAbsent = null}  ) {
for (int i = 0; i < this._list.length; i = i + 1) if (this._list[i].key == key)     V newValue = CppMap.functionInvocation(this._list[i].value);
    this._list[i] = MapEntry._(key, newValue);
    return newValue;
if (!ifAbsent == null)     V v = CppMap.functionInvocation();
    this._list.add(MapEntry._(key, v));
    return v;
    throw ArgumentError("Key not found");
  }
  
void updateAll(Function update  ) {
for (int i = 0; i < this._list.length; i = i + 1)     MapEntry<K, V> entry = this._list[i];
    this._list[i] = MapEntry._(entry.key, CppMap.functionInvocation(entry.key, entry.value));
  }
  
Map<K2, V2> map(Function transform  ) {
    CppMap<K2, V2> result = CppMap();
    Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     MapEntry<K, V> entry = entry;
    MapEntry<K2, V2> newEntry = CppMap.functionInvocation(entry.key, entry.value);
    result[newEntry.key] = newEntry.value;
    return result;
  }
  
String toString(  ) {
if (this._list.isEmpty)     return "{}";
    StringBuffer buffer = StringBuffer("{");
    Iterator<MapEntry<K, V>> iterator = this._list.iterator;
if (iterator.moveNext())     buffer.write(iterator.current.key + ": " + iterator.current.value);
while (iterator.moveNext())     buffer.write(", " + iterator.current.key + ": " + iterator.current.value);
    buffer.write("}");
    return buffer.toString();
  }
  
  Iterable<MapEntry<K, V>> get entries => null;
  
  bool get isEmpty => null;
  
  bool get isNotEmpty => null;
  
  Iterable<K> get keys => null;
  
  int get length => null;
  
  Iterable<V> get values => null;
  
V operator [](Object key  ) {
    Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
for (; _sync_for_iterator.moveNext(); )     MapEntry<K, V> entry = entry;
if (entry.key == key)     return entry.value;
    return null;
  }
  
void operator []=(K key, V value  ) {
for (int i = 0; i < this._list.length; i = i + 1) if (this._list[i].key == key)     this._list[i] = MapEntry._(key, value);
    return Void;
    this._list.add(MapEntry._(key, value));
  }
  
}

/// 转换后的类: CppIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppIterator<E> implements Iterator<E> {
CppIterator() {    ;
  }
  
}

/// 转换后的类: CppIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppIterable<E> implements Iterable<E> {
CppIterable() {    ;
  }
  
E elementAt(int index  ) {
if (index < 0)     throw ArgumentError("Index cannot be negative");
    Iterator<E> it = this.iterator;
for (int i = 0; i <= index; i = i + 1) if (!it.moveNext())     throw IndexError(index, this);
if (i == index)     return it.current;
    throw IndexError(index, this);
  }
  
bool contains(Object element  ) {
    Iterator<E> it = this.iterator;
while (it.moveNext()) if (it.current == element)     return true;
    return false;
  }
  
void forEach(Function action  ) {
    Iterator<E> it = this.iterator;
while (it.moveNext())     CppIterable.functionInvocation(it.current);
  }
  
Iterable<T> map(Function toElement  ) {
    return CppMappedIterable(this, toElement);
  }
  
Iterable<E> where(Function test  ) {
    return CppWhereIterable(this, test);
  }
  
Iterable<T> whereType(  ) {
    return CppWhereTypeIterable(this);
  }
  
Iterable<T> expand(Function toElements  ) {
    return CppExpandIterable(this, toElements);
  }
  
bool any(Function test  ) {
    Iterator<E> it = this.iterator;
while (it.moveNext()) if (CppIterable.functionInvocation(it.current))     return true;
    return false;
  }
  
bool every(Function test  ) {
    Iterator<E> it = this.iterator;
while (it.moveNext()) if (!CppIterable.functionInvocation(it.current))     return false;
    return true;
  }
  
E firstWhere(Function test, {Function orElse = null}  ) {
    Iterator<E> it = this.iterator;
while (it.moveNext()) if (CppIterable.functionInvocation(it.current))     return it.current;
if (!orElse == null)     return CppIterable.functionInvocation();
    throw StateError("No element");
  }
  
E lastWhere(Function test, {Function orElse = null}  ) {
    Iterator<E> it = this.iterator;
    E result;
    bool found = false;
while (it.moveNext()) if (CppIterable.functionInvocation(it.current))     result = it.current;
    found = true;
if (found)     return unknown == null ? unknown as E : unknown;
if (!orElse == null)     return CppIterable.functionInvocation();
    throw StateError("No element");
  }
  
E singleWhere(Function test, {Function orElse = null}  ) {
    Iterator<E> it = this.iterator;
    E result;
    bool found = false;
while (it.moveNext()) if (CppIterable.functionInvocation(it.current)) if (found)     throw StateError("Too many elements");
    result = it.current;
    found = true;
if (found)     return unknown == null ? unknown as E : unknown;
if (!orElse == null)     return CppIterable.functionInvocation();
    throw StateError("No element");
  }
  
E reduce(Function combine  ) {
    Iterator<E> it = this.iterator;
if (!it.moveNext())     throw StateError("No element");
    E value = it.current;
while (it.moveNext())     value = CppIterable.functionInvocation(value, it.current);
    return value;
  }
  
T fold(T initialValue, Function combine  ) {
    T value = initialValue;
    Iterator<E> it = this.iterator;
while (it.moveNext())     value = CppIterable.functionInvocation(value, it.current);
    return value;
  }
  
String join(String separator = ''  ) {
    Iterator<E> it = this.iterator;
if (!it.moveNext())     return "";
    StringBuffer buffer = StringBuffer(it.current.toString());
while (it.moveNext())     buffer.write(separator);
    buffer.write(it.current.toString());
    return buffer.toString();
  }
  
Iterable<E> take(int count  ) {
    return CppTakeIterable(this, count);
  }
  
Iterable<E> takeWhile(Function test  ) {
    return CppTakeWhileIterable(this, test);
  }
  
Iterable<E> skip(int count  ) {
    return CppSkipIterable(this, count);
  }
  
Iterable<E> skipWhile(Function test  ) {
    return CppSkipWhileIterable(this, test);
  }
  
Iterable<E> followedBy(Iterable<E> other  ) {
    return CppFollowedByIterable(this, other);
  }
  
List<E> toList({bool growable = true}  ) {
    return CppList.from(this);
  }
  
Set<E> toSet(  ) {
    return CppSet.from(this);
  }
  
Iterable<T> cast(  ) {
    return CppCastIterable(this);
  }
  
  bool get isEmpty => null;
  
  bool get isNotEmpty => null;
  
  E get first => null;
  
  E get last => null;
  
  E get single => null;
  
  Iterable<E> get reversed => null;
  
}

/// 转换后的类: CppMappedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppMappedIterable<S, T> extends CppIterable<S, T> {
  final Iterable<S> _source;
  final Function _f;
  
CppMappedIterable(Iterable<S> _source, Function _f) {    ;
  }
  
  Iterator<T> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppMappedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppMappedIterator<S, T> extends CppIterator<S, T> {
  final Iterator<S> _iterator;
  final Function _f;
  T _current = null;
  
CppMappedIterator(Iterator<S> _iterator, Function _f) {    ;
  }
  
bool moveNext(  ) {
if (this._iterator.moveNext())     this._current = CppMappedIterator.functionInvocation(unknown);
    return true;
    return false;
  }
  
  T get current => null;
  
}

/// 转换后的类: CppWhereIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereIterable<E> extends CppIterable<E> {
  final Iterable<E> _source;
  final Function _test;
  
CppWhereIterable(Iterable<E> _source, Function _test) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppWhereIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereIterator<E> extends CppIterator<E> {
  final Iterator<E> _iterator;
  final Function _test;
  
CppWhereIterator(Iterator<E> _iterator, Function _test) {    ;
  }
  
bool moveNext(  ) {
while (this._iterator.moveNext()) if (CppWhereIterator.functionInvocation(unknown))     return true;
    return false;
  }
  
  E get current => null;
  
}

/// 转换后的类: CppWhereTypeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereTypeIterable<T> extends CppIterable<T> {
  final Iterable<dynamic> _source;
  
CppWhereTypeIterable(Iterable<dynamic> _source) {    ;
  }
  
  Iterator<T> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppWhereTypeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereTypeIterator<T> extends CppIterator<T> {
  final Iterator<dynamic> _iterator;
  
CppWhereTypeIterator(Iterator<dynamic> _iterator) {    ;
  }
  
bool moveNext(  ) {
while (this._iterator.moveNext()) if (this._iterator.current is T)     return true;
    return false;
  }
  
  T get current => null;
  
}

/// 转换后的类: CppExpandIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppExpandIterable<S, T> extends CppIterable<S, T> {
  final Iterable<S> _source;
  final Function _f;
  
CppExpandIterable(Iterable<S> _source, Function _f) {    ;
  }
  
  Iterator<T> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppExpandIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppExpandIterator<S, T> extends CppIterator<S, T> {
  final Iterator<S> _iterator;
  final Function _f;
  Iterator<T> _currentIterator = null;
  
CppExpandIterator(Iterator<S> _iterator, Function _f) {    ;
  }
  
bool moveNext(  ) {
while (true) if (!this._currentIterator == null && this._currentIterator!.moveNext())     return true;
if (!this._iterator.moveNext())     return false;
    this._currentIterator = CppExpandIterator.functionInvocation(unknown).iterator;
  }
  
  T get current => null;
  
}

/// 转换后的类: CppTakeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeIterable<E> extends CppIterable<E> {
  final Iterable<E> _source;
  final int _count;
  
CppTakeIterable(Iterable<E> _source, int _count) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppTakeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeIterator<E> extends CppIterator<E> {
  final Iterator<E> _iterator;
  final int _count;
  int _remaining;
  
CppTakeIterator(Iterator<E> _iterator, int _count) {    ;
  }
  
bool moveNext(  ) {
if (this._remaining <= 0)     return false;
if (this._iterator.moveNext())     this._remaining = this._remaining - 1;
    return true;
    return false;
  }
  
  E get current => null;
  
}

/// 转换后的类: CppTakeWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeWhileIterable<E> extends CppIterable<E> {
  final Iterable<E> _source;
  final Function _test;
  
CppTakeWhileIterable(Iterable<E> _source, Function _test) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppTakeWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeWhileIterator<E> extends CppIterator<E> {
  final Iterator<E> _iterator;
  final Function _test;
  bool _finished = false;
  
CppTakeWhileIterator(Iterator<E> _iterator, Function _test) {    ;
  }
  
bool moveNext(  ) {
if (this._finished)     return false;
if (this._iterator.moveNext()) if (CppTakeWhileIterator.functionInvocation(unknown))     return true;
    this._finished = true;
    return false;
  }
  
  E get current => null;
  
}

/// 转换后的类: CppSkipIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipIterable<E> extends CppIterable<E> {
  final Iterable<E> _source;
  final int _count;
  
CppSkipIterable(Iterable<E> _source, int _count) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppSkipIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipIterator<E> extends CppIterator<E> {
  final Iterator<E> _iterator;
  final int _count;
  bool _skipped = false;
  
CppSkipIterator(Iterator<E> _iterator, int _count) {    ;
  }
  
bool moveNext(  ) {
if (!this._skipped) for (int i = 0; i < this._count; i = i + 1) if (!this._iterator.moveNext())     return false;
    this._skipped = true;
    return this._iterator.moveNext();
  }
  
  E get current => null;
  
}

/// 转换后的类: CppSkipWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipWhileIterable<E> extends CppIterable<E> {
  final Iterable<E> _source;
  final Function _test;
  
CppSkipWhileIterable(Iterable<E> _source, Function _test) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppSkipWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipWhileIterator<E> extends CppIterator<E> {
  final Iterator<E> _iterator;
  final Function _test;
  bool _skipped = false;
  
CppSkipWhileIterator(Iterator<E> _iterator, Function _test) {    ;
  }
  
bool moveNext(  ) {
if (!this._skipped) while (this._iterator.moveNext()) if (!CppSkipWhileIterator.functionInvocation(unknown))     this._skipped = true;
    return true;
    return false;
    return this._iterator.moveNext();
  }
  
  E get current => null;
  
}

/// 转换后的类: CppReversedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppReversedIterable<E> extends CppIterable<E> {
  final Iterable<E> _source;
  
CppReversedIterable(Iterable<E> _source) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppReversedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppReversedIterator<E> extends CppIterator<E> {
  final CppList<E> _elements;
  int _index;
  
CppReversedIterator(Iterable<E> source) {    ;
  }
  
bool moveNext(  ) {
if (this._index > 0)     this._index = this._index - 1;
    return true;
    return false;
  }
  
  E get current => null;
  
}

/// 转换后的类: CppFollowedByIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppFollowedByIterable<E> extends CppIterable<E> {
  final Iterable<E> _first;
  final Iterable<E> _second;
  
CppFollowedByIterable(Iterable<E> _first, Iterable<E> _second) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppFollowedByIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppFollowedByIterator<E> extends CppIterator<E> {
  final Iterator<E> _first;
  final Iterator<E> _second;
  bool _usingFirst = true;
  
CppFollowedByIterator(Iterator<E> _first, Iterator<E> _second) {    ;
  }
  
bool moveNext(  ) {
if (this._usingFirst) if (this._first.moveNext())     return true;
    this._usingFirst = false;
    return this._second.moveNext();
  }
  
  E get current => null;
  
}

/// 转换后的类: CppCastIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppCastIterable<S, T> extends CppIterable<S, T> {
  final Iterable<S> _source;
  
CppCastIterable(Iterable<S> _source) {    ;
  }
  
  Iterator<T> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: CppCastIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppCastIterator<S, T> extends CppIterator<S, T> {
  final Iterator<S> _iterator;
  
CppCastIterator(Iterator<S> _iterator) {    ;
  }
  
bool moveNext(  ) {
    return this._iterator.moveNext();
  }
  
  T get current => null;
  
}

/// 转换后的类: _CppEmptyIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppEmptyIterable<E> extends CppIterable<E> {
_CppEmptyIterable() {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: _CppEmptyIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppEmptyIterator<E> extends CppIterator<E> {
_CppEmptyIterator() {    ;
  }
  
bool moveNext(  ) {
    return false;
  }
  
  E get current => null;
  
}

/// 转换后的类: _CppGenerateIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppGenerateIterable<E> extends CppIterable<E> {
  final int _count;
  final Function _generator;
  
_CppGenerateIterable(int _count, Function _generator) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: _CppGenerateIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppGenerateIterator<E> extends CppIterator<E> {
  final int _count;
  final Function _generator;
  int _index = 0;
  E _current = null;
  
_CppGenerateIterator(int _count, Function _generator) {    ;
  }
  
bool moveNext(  ) {
if (this._index < this._count)     this._current = _CppGenerateIterator.functionInvocation(unknown);
    return true;
    return false;
  }
  
  E get current => null;
  
}

/// 转换后的类: _CppUnmodifiableIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppUnmodifiableIterable<E> extends CppIterable<E> {
  final List<E> _elements;
  
_CppUnmodifiableIterable(List<E> _elements) {    ;
  }
  
  Iterator<E> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: _CppCastFromIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppCastFromIterable<S, R> extends CppIterable<S, R> {
  final Iterable<S> _source;
  
_CppCastFromIterable(Iterable<S> _source) {    ;
  }
  
  Iterator<R> get iterator => null;
  
  int get length => null;
  
}

/// 转换后的类: _CppCastFromIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppCastFromIterator<S, R> extends CppIterator<S, R> {
  final Iterator<S> _iterator;
  
_CppCastFromIterator(Iterator<S> _iterator) {    ;
  }
  
bool moveNext(  ) {
    return this._iterator.moveNext();
  }
  
  R get current => null;
  
}

/// 转换后的类: CppError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppError implements Error {
CppError() {    ;
  }
  
  StackTrace get stackTrace => null;
  
  StackTrace get _stackTrace => null;
  
  set _stackTrace(StackTrace value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_stackTrace=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
}

/// 转换后的类: CppStackTrace
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppStackTrace implements StackTrace {
  static CppStackTrace _current = CppStackTrace();
  
CppStackTrace() {    ;
  }
  
String toString(  ) {
    return CppApi.getCurrentStackTrace();
  }
  
}

/// 转换后的类: CppStringBuffer
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringBuffer implements StringBuffer {
  final CppList<String> _parts;
  
CppStringBuffer(Object content = '') {    ;
  }
  
void write(Object obj  ) {
    this._parts.add(obj.toString());
  }
  
void writeAll(Iterable<dynamic> objects, String separator = ''  ) {
    Iterator<dynamic> iterator = objects.iterator;
if (iterator.moveNext())     this._parts.add(iterator.current.toString());
while (iterator.moveNext()) if (separator.isNotEmpty)     this._parts.add(separator);
    this._parts.add(iterator.current.toString());
  }
  
void writeCharCode(int charCode  ) {
    this._parts.add(String.fromCharCode(charCode));
  }
  
void writeln(Object obj = ''  ) {
    this._parts.add(obj.toString());
    this._parts.add("
");
  }
  
void clear(  ) {
    this._parts.clear();
  }
  
String toString(  ) {
    return this._parts.join("");
  }
  
void _writeString(String str  ) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_writeString), 0, const [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable(const {})));
  }
  
void _ensureCapacity(int n  ) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_ensureCapacity), 0, const [], List.unmodifiable(_GrowableList._literal1(n)), Map.unmodifiable(const {})));
  }
  
void _consumeBuffer(  ) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_consumeBuffer), 0, const [], const [], Map.unmodifiable(const {})));
  }
  
void _addPart(String str  ) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_addPart), 0, const [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable(const {})));
  }
  
void _compact(  ) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_compact), 0, const [], const [], Map.unmodifiable(const {})));
  }
  
  int get length => null;
  
  bool get isEmpty => null;
  
  bool get isNotEmpty => null;
  
  List<String> get _parts => null;
  
  set _parts(List<String> value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_parts=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
  int get _partsCodeUnits => null;
  
  set _partsCodeUnits(int value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_partsCodeUnits=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
  int get _partsCompactionIndex => null;
  
  set _partsCompactionIndex(int value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_partsCompactionIndex=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
  int get _partsCodeUnitsSinceCompaction => null;
  
  set _partsCodeUnitsSinceCompaction(int value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_partsCodeUnitsSinceCompaction=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
  Uint16List get _buffer => null;
  
  set _buffer(Uint16List value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_buffer=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
  int get _bufferPosition => null;
  
  set _bufferPosition(int value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_bufferPosition=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
  int get _bufferCodeUnitMagnitude => null;
  
  set _bufferCodeUnitMagnitude(int value) {
    return throw NoSuchMethodError.withInvocation(this, _InvocationMirror._withType(SymbolConstant(#_bufferCodeUnitMagnitude=), 2, const [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable(const {})));
  }
  
}

/// 转换后的类: CppUserData
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

class CppUserData {
CppUserData() {    ;
  }
  
}

/// 转换后的类: CppApi
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

class CppApi {
CppApi() {    ;
  }
  
}

