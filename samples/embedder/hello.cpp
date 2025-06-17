struct _Cy_GC_ {
  int _cy_gc_mark_;
};

struct Object : public _Cy_GC_ {
  Random* _hashCodeRnd;
  virtual bool operator ==(Object* other) {

  }

  virtual String* toString() {

  }

  virtual void* noSuchMethod(Invocation* invocation) {

  }
};

struct Function : public Object {
};

struct _Closure : public Object {
  WasmStructRef* context;
  virtual bool operator ==(Object* other) {

  }

  virtual String* toString() {

  }

  virtual int _instantiationClosureTypeHash() {

  }

  virtual bool _instantiationClosureTypeEquals(_Closure* other) {

  }
};

struct Type : public Object {
};

struct _Type : public Type {
  bool isDeclaredNullable;
  virtual bool _testID(WasmI32* value) {

  }

  virtual T as() {

  }

  virtual bool _checkInstance(Object* o) {

  }
};

struct _BottomType : public _Type {
  virtual bool _checkInstance(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _TopType : public _Type {
  int _kind;
  virtual bool _checkInstance(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _InterfaceTypeParameterType : public _Type {
  int environmentIndex;
  virtual bool _checkInstance(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _FunctionTypeParameterType : public _Type {
  int index;
  virtual bool _checkInstance(Object* o) {

  }

  virtual bool operator ==(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _FutureOrType : public _Type {
  _Type* typeArgument;
  virtual bool _checkInstance(Object* o) {

  }

  virtual bool operator ==(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _InterfaceType : public _Type {
  WasmI32* classId;
  WasmArray<_Type*>* typeArguments;
  virtual bool _checkInstance(Object* o) {

  }

  virtual bool operator ==(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _AbstractFunctionType : public _Type {
  virtual bool _checkInstance(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _FunctionType : public _Type {
  int typeParameterOffset;
  WasmArray<_Type*>* typeParameterBounds;
  WasmArray<_Type*>* typeParameterDefaults;
  _Type* returnType;
  WasmArray<_Type*>* positionalParameters;
  int requiredParameterCount;
  WasmArray<_NamedParameter*>* namedParameters;
  virtual bool _checkInstance(Object* o) {

  }

  virtual bool operator ==(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _AbstractRecordType : public _Type {
  virtual bool _checkInstance(Object* o) {

  }

  virtual String* toString() {

  }
};

struct _RecordType : public _Type {
  ImmutableWasmArray<String*>* names;
  WasmArray<_Type*>* fieldTypes;
  virtual bool _checkInstance(Object* o) {

  }

  virtual String* toString() {

  }

  virtual bool operator ==(Object* o) {

  }

  virtual bool _sameShape(_RecordType* other) {

  }
};

struct Record : public Object {
  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_2 : public Record {
  void* $1;
  void* $2;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_3 : public Record {
  void* $1;
  void* $2;
  void* $3;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_4 : public Record {
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_5 : public Record {
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_6 : public Record {
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_7 : public Record {
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
  void* $7;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_8 : public Record {
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
  void* $7;
  void* $8;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

struct Record_9 : public Record {
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
  void* $7;
  void* $8;
  void* $9;
  virtual void* toString() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool _checkRecordType(WasmArray<_Type*>* types, ImmutableWasmArray<String*>* names) {

  }
};

template<typename T>
struct Comparable : public Object {
  virtual int compareTo(T other) {

  }
};

struct Pattern : public Object {
  virtual Match* matchAsPrefix(String* string, int start) {

  }
};

struct String : public Object {
  virtual String* operator [](int index) {

  }

  virtual int codeUnitAt(int index) {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual int compareTo(String* other) {

  }

  virtual int indexOf(Pattern* pattern, int start) {

  }

  virtual String* operator +(String* other) {

  }
};

struct WasmStringBase : public String {
};

struct StringBase : public WasmStringBase {
  virtual int _computeHashCode() {

  }

  virtual String* operator [](int index) {

  }

  virtual String* operator +(String* other) {

  }

  virtual String* toString() {

  }

  virtual int compareTo(String* other) {

  }

  virtual bool _substringMatches(int start) {

  }

  virtual int indexOf(Pattern* pattern, int start) {

  }

  virtual Match* matchAsPrefix(String* string, int start) {

  }

  virtual int _copyIntoTwoByteString(TwoByteString* result, int offset) {

  }
};

struct OneByteString : public StringBase {
  WasmArray<WasmI8*>* _array;
  virtual int _computeHashCode() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual int _codeUnitAtUnchecked(int index) {

  }

  virtual int codeUnitAt(int index) {

  }

  virtual int _copyIntoTwoByteString(TwoByteString* result, int offset) {

  }

  virtual int indexOf(Pattern* pattern, int start) {

  }

  virtual void* _setAt(int index, int codePoint) {

  }
};

struct TwoByteString : public StringBase {
  WasmArray<WasmI16*>* _array;
  virtual int _computeHashCode() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual void* _setAt(int index, int codePoint) {

  }

  virtual int codeUnitAt(int index) {

  }

  virtual int _codeUnitAtUnchecked(int index) {

  }

  virtual int _copyIntoTwoByteString(TwoByteString* result, int offset) {

  }
};

struct StringUncheckedOperationsBase : public Object {
  virtual int _codeUnitAtUnchecked(int index) {

  }
};

struct JSStringImpl : public Object {
  WasmExternRef* _ref;
  virtual int codeUnitAt(int index) {

  }

  virtual int _codeUnitAtUnchecked(int index) {

  }

  virtual String* operator +(String* other) {

  }

  virtual int _computeHashCode() {

  }

  virtual String* operator [](int index) {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual int compareTo(String* other) {

  }

  virtual String* toString() {

  }
};

struct _HashFieldBase : public Object {
  WasmArray<WasmI32*>* _index;
  int _hashMask;
  WasmArray<Object*>* _data;
  int _usedData;
  int _deletedKeys;
};

struct _HashBase : public _HashFieldBase {
  virtual bool _isModifiedSince(WasmArray<Object*>* oldData, int oldCheckSum) {

  }
};

template<typename K,typename V>
struct _DefaultMap$_HashFieldBase$MapMixin : public _HashFieldBase {
  virtual String* toString() {

  }
};

template<typename K,typename V>
struct _DefaultMap$_HashFieldBase$MapMixin$_HashBase : public _DefaultMap$_HashFieldBase$MapMixin {
  virtual bool _isModifiedSince(WasmArray<Object*>* oldData, int oldCheckSum) {

  }
};

template<typename K,typename V>
struct _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode : public _DefaultMap$_HashFieldBase$MapMixin$_HashBase {
  virtual int _hashCode(Object* e) {

  }

  virtual bool _equals(Object* e1, Object* e2) {

  }
};

template<typename K,typename V>
struct _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin : public _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode {
  virtual void* _rehash() {

  }

  virtual void* _init(int size, int hashMask, WasmArray<Object*>* oldData, int oldUsed) {

  }

  virtual void* _insert(K key, V value, int fullHash, int hashPattern, int i) {

  }

  virtual int _findValueOrInsertPoint(K key, int fullHash, int hashPattern, int size, WasmArray<WasmI32*>* index) {

  }

  virtual void* operator_fx2(K key, V value) {

  }

  virtual void* _set(K key, V value, int fullHash) {

  }

  virtual void* forEach(void* action) {

  }
};

template<typename K,typename V>
struct _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin : public _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin {
  virtual void* _createIndex() {

  }
};

template<typename K,typename V>
struct DefaultMap : public _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin {
};

template<typename K,typename V>
struct __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin : public _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin {
};

template<typename K,typename V>
struct __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin$_ImmutableLinkedHashMapMixin : public __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin {
};

template<typename K,typename V>
struct _ConstMap : public __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin$_ImmutableLinkedHashMapMixin {
};

template<typename K,typename V>
struct _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode : public _DefaultMap$_HashFieldBase$MapMixin$_HashBase {
  virtual int _hashCode(Object* e) {

  }

  virtual bool _equals(Object* e1, Object* e2) {

  }
};

template<typename K,typename V>
struct _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin : public _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode {
  virtual void* _rehash() {

  }

  virtual void* _init(int size, int hashMask, WasmArray<Object*>* oldData, int oldUsed) {

  }

  virtual void* _insert(K key, V value, int fullHash, int hashPattern, int i) {

  }

  virtual int _findValueOrInsertPoint(K key, int fullHash, int hashPattern, int size, WasmArray<WasmI32*>* index) {

  }

  virtual void* operator_fx2(K key, V value) {

  }

  virtual void* _set(K key, V value, int fullHash) {

  }

  virtual void* forEach(void* action) {

  }
};

template<typename K,typename V>
struct CompactLinkedCustomHashMap : public _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin {
  void* _equality;
  void* _hasher;
};

template<typename E>
struct _DefaultSet$_HashFieldBase$SetMixin : public _HashFieldBase {
  virtual String* toString() {

  }
};

template<typename E>
struct _DefaultSet$_HashFieldBase$SetMixin$_HashBase : public _DefaultSet$_HashFieldBase$SetMixin {
  virtual bool _isModifiedSince(WasmArray<Object*>* oldData, int oldCheckSum) {

  }
};

template<typename E>
struct _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode : public _DefaultSet$_HashFieldBase$SetMixin$_HashBase {
  virtual int _hashCode(Object* e) {

  }

  virtual bool _equals(Object* e1, Object* e2) {

  }
};

template<typename E>
struct _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin : public _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode {
};

template<typename E>
struct _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_SetCreateIndexMixin : public _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin {
  virtual void* _createIndex() {

  }
};

template<typename E>
struct DefaultSet : public _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_SetCreateIndexMixin {
};

template<typename E>
struct __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin : public _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin {
};

template<typename E>
struct __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin : public __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin {
};

template<typename E>
struct __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin$_ImmutableLinkedHashSetMixin : public __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin {
};

template<typename E>
struct _ConstSet : public __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin$_ImmutableLinkedHashSetMixin {
};

template<typename K,typename V>
struct Map : public Object {
  virtual void* operator_fx2(K key, V value) {

  }

  virtual void* forEach(void* action) {

  }
};

template<typename K,typename V>
struct MapBase : public Object {
};

struct _EqualsAndHashCode : public Object {
  virtual int _hashCode(Object* e) {

  }

  virtual bool _equals(Object* e1, Object* e2) {

  }
};

struct _OperatorEqualsAndHashCode : public Object {
};

struct __LinkedHashMapMixin$_HashBase$_EqualsAndHashCode : public Object {
};

template<typename K,typename V>
struct _LinkedHashMapMixin : public __LinkedHashMapMixin$_HashBase$_EqualsAndHashCode {
  virtual void* _rehash() {

  }

  virtual void* _init(int size, int hashMask, WasmArray<Object*>* oldData, int oldUsed) {

  }

  virtual void* _insert(K key, V value, int fullHash, int hashPattern, int i) {

  }

  virtual int _findValueOrInsertPoint(K key, int fullHash, int hashPattern, int size, WasmArray<WasmI32*>* index) {

  }

  virtual void* _set(K key, V value, int fullHash) {

  }
};

template<typename E>
struct _LinkedHashSetMixin : public __LinkedHashMapMixin$_HashBase$_EqualsAndHashCode {
};

template<typename K,typename V>
struct __MapCreateIndexMixin$_LinkedHashMapMixin$_HashFieldBase : public Object {
};

template<typename K,typename V>
struct _MapCreateIndexMixin : public __MapCreateIndexMixin$_LinkedHashMapMixin$_HashFieldBase {
};

template<typename K,typename V>
struct _ImmutableLinkedHashMapMixin : public _MapCreateIndexMixin {
};

template<typename K,typename V>
struct LinkedHashMap : public Object {
};

template<typename K,typename V>
struct _UnmodifiableMapMixin : public Object {
};

template<typename K>
struct _CustomEqualsAndHashCode : public Object {
  virtual void* _get0__hasher() {

  }

  virtual void* _get0__equality() {

  }
};

template<typename E>
struct Iterable : public Object {
  virtual List<E>* toList() {

  }

  virtual E elementAt(int index) {

  }

  virtual String* toString() {

  }
};

template<typename T>
struct EfficientLengthIterable : public Iterable {
};

template<typename E>
struct ListIterable : public EfficientLengthIterable {
};

template<typename E>
struct SubListIterable : public ListIterable {
  Iterable<E>* _iterable;
  int _start;
  int _endOrLength;
  virtual E elementAt(int index) {

  }

  virtual List<E>* toList() {

  }
};

template<typename K,typename V>
struct _CompactEntriesIterable : public Iterable {
  _HashBase* _table;
};

template<typename T>
struct _SyncStarIterable : public Iterable {
  WasmStructRef* _context;
  void* _resume;
};

template<typename T>
struct HideEfficientLengthIterable : public Object {
};

template<typename E>
struct _SetIterable : public Object {
};

template<typename E>
struct Set : public Object {
};

template<typename E>
struct SetBase : public Object {
};

template<typename E>
struct __SetCreateIndexMixin$Set$_LinkedHashSetMixin : public Object {
};

template<typename E>
struct __SetCreateIndexMixin$Set$_LinkedHashSetMixin$_HashFieldBase : public Object {
};

template<typename E>
struct _SetCreateIndexMixin : public __SetCreateIndexMixin$Set$_LinkedHashSetMixin$_HashFieldBase {
};

template<typename E>
struct _ImmutableLinkedHashSetMixin : public _SetCreateIndexMixin {
};

template<typename E>
struct LinkedHashSet : public Object {
};

template<typename E>
struct _UnmodifiableSetMixin : public Object {
};

struct ByteBuffer : public Object {
};

struct TypedData : public Object {
};

struct ByteData : public Object {
};

template<typename E>
struct _ListIterable : public Object {
};

template<typename E>
struct List : public Object {
  virtual E operator [](int index) {

  }

  virtual void* operator_fx2(int index, E value) {

  }

  virtual void* add(E value) {

  }

  virtual void* sort(void* compare) {

  }

  virtual E removeLast() {

  }

  virtual void* setRange(int start, int end, Iterable<E>* iterable, int skipCount) {

  }

  virtual void* fillRange(int start, int end, E fillValue) {

  }
};

template<typename E>
struct TypedDataList : public Object {
};

struct _TypedIntList : public Object {
};

struct Uint8List : public Object {
  virtual Uint8List* sublist(int start, int end) {

  }
};

template<typename E>
struct ListBase : public Object {
  virtual void* sort(void* compare) {

  }

  virtual String* toString() {

  }
};

template<typename E>
struct WasmListBase : public ListBase {
  int _length;
  WasmArray<Object*>* _data;
  virtual E operator [](int index) {

  }
};

template<typename E>
struct _ModifiableList : public WasmListBase {
  virtual void* operator_fx2(int index, E value) {

  }
};

template<typename E>
struct GrowableList : public _ModifiableList {
  WasmArray<Object*>* _emptyData;
  virtual void* _set0_length(int newLength) {

  }

  virtual void* _setLength(int newLength) {

  }

  virtual void* add(E value) {

  }

  virtual E removeLast() {

  }

  virtual int _nextCapacity(int oldCapacity) {

  }

  virtual void* _grow(int newCapacity) {

  }

  virtual void* _growToNextCapacity() {

  }

  virtual void* _shrink(int newCapacity, int newLength) {

  }

  virtual ModifiableFixedLengthList<E>* _toModifiableFixedLengthList() {

  }

  virtual ImmutableList<E>* _toUnmodifiableList() {

  }
};

template<typename E>
struct _ModifiableFixedLengthList$_ModifiableList$FixedLengthListMixin : public _ModifiableList {
  virtual void* add(E value) {

  }
};

template<typename E>
struct ModifiableFixedLengthList : public _ModifiableFixedLengthList$_ModifiableList$FixedLengthListMixin {
};

template<typename E>
struct _ImmutableList$WasmListBase$UnmodifiableListMixin : public WasmListBase {
  virtual void* add(E value) {

  }
};

template<typename E>
struct ImmutableList : public _ImmutableList$WasmListBase$UnmodifiableListMixin {
};

template<typename E>
struct FixedLengthListMixin : public Object {
};

template<typename E>
struct UnmodifiableListMixin : public Object {
};

template<typename K,typename V>
struct _UnmodifiableMapMixin : public Object {
};

template<typename K,typename V>
struct MapView : public Object {
  Map<K,V>* _map;
  virtual void* forEach(void* action) {

  }

  virtual String* toString() {

  }
};

template<typename K,typename V>
struct _UnmodifiableMapView$MapView$_UnmodifiableMapMixin : public MapView {
};

template<typename K,typename V>
struct UnmodifiableMapView : public _UnmodifiableMapView$MapView$_UnmodifiableMapMixin {
};

struct Exception : public Object {
};

struct StringSink : public Object {
};

struct StringBuffer : public Object {
  WasmArray<String*>* _parts;
  int _partsWriteIndex;
  int _partsCodeUnits;
  int _partsCompactionIndex;
  int _partsCodeUnitsSinceCompaction;
  WasmArray<WasmI16*>* _buffer;
  int _bufferPosition;
  int _bufferCodeUnitMagnitude;
  virtual void* _writeString(String* str) {

  }

  virtual void* _consumeBuffer() {

  }

  virtual void* _addPart(String* str) {

  }

  virtual void* _compact() {

  }

  virtual void* write(Object* obj) {

  }

  virtual void* writeAll(Iterable<void*>* objects) {

  }

  virtual String* toString() {

  }
};

struct _NamedParameter : public Object {
  String* name;
  _Type* type;
  bool isRequired;
  virtual bool operator ==(Object* o) {

  }

  virtual String* toString() {

  }
};

struct Symbol : public Object {
  String* _name;
  virtual bool operator ==(Object* other) {

  }

  virtual String* toString() {

  }
};

struct StackTrace : public Object {
};

struct _StringStackTrace : public Object {
  String* _stackTrace;
  virtual String* toString() {

  }
};

struct Match : public Object {
};

struct Null : public Object {
  virtual String* toString() {

  }
};

template<typename K,typename V>
struct MapEntry : public Object {
  K key;
  V value;
  virtual String* toString() {

  }
};

struct Invocation : public Object {
};

struct _Invocation : public Object {
  Symbol* memberName;
  List<Object*>* _positional;
  Map<Symbol*,Object*>* _named;
};

struct Error : public Object {
  StackTrace* _stackTrace;
};

struct UnsupportedError : public Error {
  String* message;
  virtual String* toString() {

  }
};

struct _Error : public Error {
  String* _message;
  virtual String* toString() {

  }
};

struct _TypeError : public _Error {
};

struct TypeError : public Error {
};

struct _JavaScriptError : public Error {
  virtual String* toString() {

  }
};

struct _TypeCheckVerificationError : public Error {
  _Type* left;
  _Type* right;
  bool optimized;
  bool reference;
  String* location;
  virtual String* toString() {

  }
};

struct AssertionError : public Error {
  Object* message;
};

struct _AssertionErrorImpl : public AssertionError {
  String* _fileUri;
  int _line;
  int _column;
  String* _conditionSource;
  virtual String* toString() {

  }
};

struct ArgumentError : public Error {
  bool _hasValue;
  void* invalidValue;
  String* name;
  void* message;
  virtual String* toString() {

  }
};

struct RangeError : public ArgumentError {
  double start;
  double end;
};

struct IndexError : public ArgumentError {
  int length;
};

struct NoSuchMethodError : public Error {
  Object* _receiver;
  Symbol* _memberName;
  List<void*>* _arguments;
  Map<Symbol*,void*>* _namedArguments;
  List<void*>* _existingArgumentNames;
  virtual String* toString() {

  }
};

struct StateError : public Error {
  String* message;
  virtual String* toString() {

  }
};

struct ConcurrentModificationError : public Error {
  Object* modifiedObject;
  virtual String* toString() {

  }
};

struct IntegerDivisionByZeroException : public Object {
  virtual void* _set0__stackTrace(StackTrace* _$wc2$formal) {

  }

  virtual String* toString() {

  }
};

struct pragma : public Object {
  String* name;
  Object* options;
};

template<typename E>
struct Iterator : public Object {
  virtual bool moveNext() {

  }
};

template<typename T>
struct _SyncStarIterator : public Object {
  T _current;
  Iterable<T>* _yieldStarIterable;
  Iterator<T>* _yieldStarIterator;
  _SuspendState* _state;
  virtual bool _handleSyncStarMethodCompletion() {

  }

  virtual bool moveNext() {

  }
};

struct _SuspendState : public Object {
  void* _resume;
  _SuspendState* _parent;
  _SyncStarIterator<void*>* _iterator;
  WasmStructRef* _context;
  WasmI32* _targetIndex;
  Object* _currentException;
  StackTrace* _currentExceptionStackTrace;
};

struct _TypeUniverse : public Object {
};

struct _Environment : public Object {
  _Environment* parent;
  void* type;
  int depth;
  virtual _Environment* adjust(void* param) {

  }

  virtual _Type* lookupAdjusted(void* param) {

  }
};

struct _FfiStructLayout : public Object {
  List<Object*>* fieldTypes;
  int packing;
};

struct _FfiInlineArray : public Object {
  Type* elementType;
  int length;
  bool variableLength;
};

struct NativeType : public Object {
};

struct SizedNativeType : public Object {
};

template<typename T>
struct Pointer : public Object {
  WasmI32* _address;
  virtual bool operator ==(Object* other) {

  }
};

struct _Compound : public Object {
};

struct Struct : public _Compound {
};

struct Union : public _Compound {
};

template<typename E>
struct _CompactIterator : public Object {
  _HashBase* _table;
  WasmArray<Object*>* _data;
  int _len;
  int _offset;
  int _step;
  int _checkSum;
  E _current;
  virtual bool moveNext() {

  }
};

template<typename K,typename V>
struct _CompactEntriesIterator : public Object {
  _HashBase* _table;
  WasmArray<Object*>* _data;
  int _len;
  int _offset;
  int _checkSum;
  MapEntry<K,V>* _current;
  virtual bool moveNext() {

  }
};

struct Zone : public Object {
  _Zone* _current;
  virtual void* handleUncaughtError(Object* error, StackTrace* stackTrace) {

  }

  virtual R run(void* action) {

  }

  virtual R runUnary(void* action, T argument) {

  }

  virtual R runBinary(void* action, T1 argument1, T2 argument2) {

  }

  virtual void* registerCallback(void* callback) {

  }

  virtual void* registerUnaryCallback(void* callback) {

  }

  virtual void* registerBinaryCallback(void* callback) {

  }

  virtual void* bindCallback(void* callback) {

  }

  virtual void* bindCallbackGuarded(void* callback) {

  }

  virtual AsyncError* errorCallback() {

  }

  virtual void* scheduleMicrotask(void* callback) {

  }
};

struct _Zone : public Object {
  virtual bool inSameErrorZone(Zone* otherZone) {

  }
};

struct _RootZone : public _Zone {
  virtual void* runGuarded(void* f) {

  }

  virtual void* bindCallback(void* f) {

  }

  virtual void* bindCallbackGuarded(void* f) {

  }

  virtual void* handleUncaughtError(Object* error, StackTrace* stackTrace) {

  }

  virtual R run(void* f) {

  }

  virtual R runUnary(void* f, T arg) {

  }

  virtual R runBinary(void* f, T1 arg1, T2 arg2) {

  }

  virtual void* registerCallback(void* f) {

  }

  virtual void* registerUnaryCallback(void* f) {

  }

  virtual void* registerBinaryCallback(void* f) {

  }

  virtual AsyncError* errorCallback() {

  }

  virtual void* scheduleMicrotask(void* f) {

  }
};

template<typename E>
struct _CompactIteratorImmutable : public Object {
  WasmArray<Object*>* _data;
  int _len;
  int _offset;
  int _step;
  E _current;
  virtual bool moveNext() {

  }
};

struct ZoneDelegate : public Object {
};

template<typename T>
struct _ZoneFunction : public Object {
  _Zone* zone;
  void* function;
};

struct _AsyncRun : public Object {
};

struct _AsyncCallbackEntry : public Object {
  void* callback;
  _AsyncCallbackEntry* next;
};

template<typename T>
struct Future : public Object {
  virtual Future<R>* then(void* onValue, void* onError) {

  }
};

template<typename T>
struct _Future : public Object {
  int _state;
  _Zone* _zone;
  void* _resultOrListeners;
  virtual void* _setChained(_Future<void*>* source) {

  }

  virtual Future<R>* then(void* f, void* onError) {

  }

  virtual void* _setPendingComplete() {

  }

  virtual void* _clearPendingComplete() {

  }

  virtual void* _setValue(T value) {

  }

  virtual void* _setErrorObject(AsyncError* error) {

  }

  virtual void* _setError(Object* error, StackTrace* stackTrace) {

  }

  virtual void* _cloneResult(_Future<void*>* source) {

  }

  virtual void* _addListener(_FutureListener<void*,void*>* listener) {

  }

  virtual void* _prependListeners(_FutureListener<void*,void*>* listeners) {

  }

  virtual _FutureListener<void*,void*>* _removeListeners() {

  }

  virtual _FutureListener<void*,void*>* _reverseListeners(_FutureListener<void*,void*>* listeners) {

  }

  virtual void* _chainForeignFuture(Future<void*>* source) {

  }

  virtual void* _completeWithValue(T value) {

  }

  virtual void* _completeWithResultOf(_Future<Object*>* source) {

  }

  virtual void* _completeError(Object* error, StackTrace* stackTrace) {

  }

  virtual void* _asyncComplete(T> value) {

  }

  virtual void* _asyncCompleteWithValue(T value) {

  }

  virtual void* _chainFuture(Future<T>* value) {

  }

  virtual void* _asyncCompleteError(Object* error, StackTrace* stackTrace) {

  }

  virtual _Future<T>* _newFutureWithSameType() {

  }
};

template<typename S,typename T>
struct _FutureListener : public Object {
  _FutureListener<void*,void*>* _nextListener;
  _Future<T>* result;
  int state;
  void* callback;
  void* errorCallback;
  virtual void* _get0__onValue() {

  }

  virtual void* _get0__errorTest() {

  }

  virtual void* _get0__whenCompleteAction() {

  }

  virtual T> handleValue(S sourceResult) {

  }

  virtual bool matchesErrorTest(AsyncError* asyncError) {

  }

  virtual T> handleError(AsyncError* asyncError) {

  }

  virtual void* handleWhenComplete() {

  }

  virtual bool shouldChain(Future<void*>* value) {

  }
};

template<typename T>
struct Completer : public Object {
};

template<typename T>
struct _Completer : public Object {
  _Future<T>* future;
  virtual void* completeError(Object* error, StackTrace* stackTrace) {

  }

  virtual void* _completeError(Object* error, StackTrace* stackTrace) {

  }
};

template<typename T>
struct _AsyncCompleter : public _Completer {
  virtual void* complete(T> value) {

  }

  virtual void* _completeError(Object* error, StackTrace* stackTrace) {

  }
};

struct StringMatch : public Object {
};

struct AsyncError : public Object {
  Object* error;
  StackTrace* stackTrace;
  virtual String* toString() {

  }

  virtual void* _set0__stackTrace(StackTrace* value) {

  }
};

struct _JSEventLoop : public Object {
};

template<typename E>
struct _TypedListIterator : public Object {
  TypedDataList<E>* _array;
  int _length;
  int _position;
  E _current;
  virtual bool moveNext() {

  }
};

struct _IntListMixin : public Object {
};

template<typename SpawnedType>
struct _TypedIntListMixin : public _IntListMixin {
  virtual SpawnedType _createList(int length) {

  }
};

template<typename E>
struct _GrowableListIterator : public Object {
  GrowableList<E>* _list;
  int _length;
  int _index;
  E _current;
  virtual bool moveNext() {

  }
};

template<typename E>
struct _FixedSizeListIterator : public Object {
  WasmArray<Object*>* _data;
  int _index;
  E _current;
  virtual bool moveNext() {

  }
};

template<typename T>
struct JSArrayImplIterator : public Object {
  JSArrayImpl<T>* _array;
  int _length;
  int _index;
  virtual bool moveNext() {

  }
};

template<typename T>
struct JSArrayImpl : public Object {
  WasmExternRef* _ref;
  virtual void* add(T value) {

  }

  virtual String* toString() {

  }

  virtual T _getUnchecked(int index) {

  }

  virtual T operator [](int index) {

  }

  virtual void* _setUnchecked(int index, T value) {

  }

  virtual void* operator_fx2(int index, T value) {

  }
};

struct JSValue : public Object {
  WasmExternRef* _ref;
  virtual bool operator ==(Object* that) {

  }

  virtual String* toString() {

  }
};

struct Symbol : public Object {
  String* _name;
  virtual bool operator ==(Object* other) {

  }

  virtual String* toString() {

  }
};

struct Sort : public Object {
};

struct _AsyncSuspendState : public Object {
  void* _resume;
  WasmStructRef* _context;
  WasmI32* _targetIndex;
  _AsyncCompleter<void*>* _completer;
  Object* _currentException;
  StackTrace* _currentExceptionStackTrace;
  Object* _currentReturnValue;
};

struct _FfiAbiSpecificMapping : public Object {
  List<Type*>* nativeTypes;
};

struct IterableElementError : public Object {
};

template<typename E>
struct ListIterator : public Object {
  Iterable<E>* _iterable;
  int _length;
  int _index;
  E _current;
  virtual bool moveNext() {

  }
};

struct IndexErrorUtils : public Object {
};

struct RangeErrorUtils : public Object {
};

struct Lists : public Object {
};

struct WasmTypedDataBase : public Object {
};

struct ByteBufferBase : public WasmTypedDataBase {
};

struct _I8ByteBuffer : public ByteBufferBase {
  WasmArray<WasmI8*>* _data;
  virtual bool operator ==(Object* other) {

  }
};

struct _I16ByteBuffer : public ByteBufferBase {
};

struct _I32ByteBuffer : public ByteBufferBase {
};

struct _I64ByteBuffer : public ByteBufferBase {
};

struct WasmI8ArrayBase : public WasmTypedDataBase {
  WasmArray<WasmI8*>* _data;
  int _offsetInElements;
  int length;
};

struct _I8List$WasmI8ArrayBase$_IntListMixin : public WasmI8ArrayBase {
  virtual Iterable<int>* skip(int n) {

  }

  virtual int elementAt(int index) {

  }

  virtual void* add(int value) {

  }

  virtual void* fillRange(int start, int end, int fillValue) {

  }
};

struct _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin : public _I8List$WasmI8ArrayBase$_IntListMixin {
  virtual void* setRange(int start, int end, Iterable<int>* from, int skipCount) {

  }

  virtual U8List* sublist(int start, int end) {

  }
};

struct _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin$_TypedListCommonOperationsMixin : public _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin {
  virtual String* toString() {

  }
};

struct U8List : public _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin$_TypedListCommonOperationsMixin {
  virtual U8List* _createList(int length) {

  }

  virtual int operator [](int index) {

  }

  virtual void* operator_fx2(int index, int value) {

  }
};

struct _TypedListCommonOperationsMixin : public Object {
};

struct SystemHash : public Object {
};

struct SentinelValue : public Object {
  int id;
};

template<typename T>
struct TypeTest : public Object {
  virtual bool test(Object* v) {

  }
};

struct Random : public Object {
  virtual int nextInt(int max) {

  }
};

struct _Random : public Object {
  int _state;
  _Random* _prng;
  virtual void* _nextState() {

  }

  virtual int nextInt(int max) {

  }
};

struct ClassID : public Object {
};

struct MyTest : public Object {
  int aa;
  int bb;
  virtual void* _set0_cc(int value) {

  }

  virtual void* sum() {

  }

  virtual void* sum2(int aa, String* bb, String* cc) {

  }
};

struct _WasmBase : public Object {
};

struct WasmAnyRef : public _WasmBase {
};

struct WasmEqRef : public WasmAnyRef {
};

struct WasmStructRef : public WasmEqRef {
};

struct WasmArrayRef : public WasmEqRef {
};

template<typename T>
struct WasmArray : public WasmArrayRef {
  List<Object*>* _value;
};

template<typename T>
struct ImmutableWasmArray : public WasmArrayRef {
  List<Object*>* _value;
};

struct WasmExternRef : public _WasmBase {
};

struct WasmFuncRef : public _WasmBase {
};

template<typename F>
struct WasmFunction : public WasmFuncRef {
};

struct WasmI8 : public _WasmBase {
};

struct WasmI16 : public _WasmBase {
};

struct WasmI32 : public _WasmBase {
  int _value;
  virtual int toIntSigned() {

  }

  virtual int toIntUnsigned() {

  }

  virtual bool toBool() {

  }

  virtual WasmI32* operator_fx4() {

  }

  virtual bool operator <(WasmI32* other) {

  }

  virtual bool operator <=(WasmI32* other) {

  }

  virtual bool operator ==(WasmI32* other) {

  }

  virtual WasmI32* operator +(WasmI32* other) {

  }

  virtual bool geU(WasmI32* other) {

  }
};

struct WasmI64 : public _WasmBase {
  virtual int toInt() {

  }

  virtual bool leU(WasmI64* other) {

  }

  virtual bool ltU(WasmI64* other) {

  }

  virtual bool gtU(WasmI64* other) {

  }

  virtual WasmI64* shl(WasmI64* shift) {

  }

  virtual WasmI64* shrS(WasmI64* shift) {

  }

  virtual WasmI64* shrU(WasmI64* shift) {

  }

  virtual WasmI64* divS(WasmI64* divisor) {

  }
};

struct WasmF32 : public _WasmBase {
};

struct WasmF64 : public _WasmBase {
  virtual double toDouble() {

  }

  virtual WasmI64* truncSatS() {

  }

  virtual WasmF64* copysign(WasmF64* other) {

  }
};

struct WasmVoid : public _WasmBase {
};

template<typename T>
struct WasmTable : public _WasmBase {
  virtual F callIndirect(WasmI32* index) {

  }
};

struct BoxedBool : public _Cy_GC_ {
  bool value;
  virtual bool operator ==(Object* other) {

  }
};

struct BoxedDouble : public _Cy_GC_ {
  double value;
  List<void*>* _cache;
  int _cacheEvictIndex;
  virtual double operator +(double other) {

  }

  virtual double operator -(double other) {

  }

  virtual double operator *(double other) {

  }

  virtual double operator /(double other) {

  }

  virtual double operator %(double other) {

  }

  virtual double operator_fx4() {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual bool operator <(double other) {

  }

  virtual bool operator >(double other) {

  }

  virtual bool operator >=(double other) {

  }

  virtual double abs() {

  }

  virtual int floor() {

  }

  virtual int ceil() {

  }

  virtual double floorToDouble() {

  }

  virtual double ceilToDouble() {

  }

  virtual int toInt() {

  }

  virtual double toDouble() {

  }

  virtual String* toString() {

  }

  virtual int compareTo(double other) {

  }
};

struct BoxedInt : public _Cy_GC_ {
  int value;
  virtual double operator +(double other) {

  }

  virtual double operator -(double other) {

  }

  virtual double operator *(double other) {

  }

  virtual int operator_fx1(double other) {

  }

  virtual double operator %(double other) {

  }

  virtual double remainder(double other) {

  }

  virtual int operator_fx4() {

  }

  virtual int operator &(int other) {

  }

  virtual int operator |(int other) {

  }

  virtual int operator ^(int other) {

  }

  virtual int operator >>(int shift) {

  }

  virtual int operator_fx3(int shift) {

  }

  virtual int operator <<(int shift) {

  }

  virtual bool operator <(double other) {

  }

  virtual bool operator >(double other) {

  }

  virtual bool operator >=(double other) {

  }

  virtual bool operator <=(double other) {

  }

  virtual bool operator ==(Object* other) {

  }

  virtual int abs() {

  }

  virtual int compareTo(double other) {

  }

  virtual double clamp(double lowerLimit, double upperLimit) {

  }

  virtual double toDouble() {

  }

  virtual int operator ~() {

  }

  virtual String* toString() {

  }
};

