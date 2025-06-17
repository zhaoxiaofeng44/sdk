#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct ClassInfoHeader ClassInfoHeader;
typedef struct  {
  const char* name;
  const ClassInfoHeader* super;
  const char** method_name;
  const void** method_vtbl;
} ClassInfoHeader;

typedef struct  {
  int _cy_gc_mark_;
  ClassInfoHeader* _cy_header_;
} _Cy_GC_;

typedef struct  {
  _Cy_GC_ _cy_super_;
  Random* _hashCodeRnd;
} Object;

String* Object_toString() {

}

void* Object_noSuchMethod(Invocation* invocation) {

}

typedef struct  {
  Object _cy_super_;
} Function;

typedef struct  {
  Object _cy_super_;
  WasmStructRef* context;
} _Closure;

bool _Closure_==(Object* other) {

}

String* _Closure_toString() {

}

typedef struct  {
  Object _cy_super_;
} Type;

typedef struct  {
  Type _cy_super_;
  bool isDeclaredNullable;
} _Type;

bool _Type__testID(WasmI32* value) {

}

void* _Type_as() {

}

bool _Type__checkInstance(Object* o) {

}

typedef struct  {
  _Type _cy_super_;
} _BottomType;

bool _BottomType__checkInstance(Object* o) {

}

String* _BottomType_toString() {

}

typedef struct  {
  _Type _cy_super_;
  int _kind;
} _TopType;

bool _TopType__checkInstance(Object* o) {

}

String* _TopType_toString() {

}

typedef struct  {
  _Type _cy_super_;
  int environmentIndex;
} _InterfaceTypeParameterType;

bool _InterfaceTypeParameterType__checkInstance(Object* o) {

}

String* _InterfaceTypeParameterType_toString() {

}

typedef struct  {
  _Type _cy_super_;
  int index;
} _FunctionTypeParameterType;

bool _FunctionTypeParameterType__checkInstance(Object* o) {

}

bool _FunctionTypeParameterType_==(Object* o) {

}

String* _FunctionTypeParameterType_toString() {

}

typedef struct  {
  _Type _cy_super_;
  _Type* typeArgument;
} _FutureOrType;

bool _FutureOrType__checkInstance(Object* o) {

}

bool _FutureOrType_==(Object* o) {

}

String* _FutureOrType_toString() {

}

typedef struct  {
  _Type _cy_super_;
  WasmI32* classId;
  WasmArray* typeArguments;
} _InterfaceType;

bool _InterfaceType__checkInstance(Object* o) {

}

bool _InterfaceType_==(Object* o) {

}

String* _InterfaceType_toString() {

}

typedef struct  {
  _Type _cy_super_;
} _AbstractFunctionType;

bool _AbstractFunctionType__checkInstance(Object* o) {

}

String* _AbstractFunctionType_toString() {

}

typedef struct  {
  _Type _cy_super_;
  int typeParameterOffset;
  WasmArray* typeParameterBounds;
  WasmArray* typeParameterDefaults;
  _Type* returnType;
  WasmArray* positionalParameters;
  int requiredParameterCount;
  WasmArray* namedParameters;
} _FunctionType;

bool _FunctionType__checkInstance(Object* o) {

}

bool _FunctionType_==(Object* o) {

}

String* _FunctionType_toString() {

}

typedef struct  {
  _Type _cy_super_;
} _AbstractRecordType;

bool _AbstractRecordType__checkInstance(Object* o) {

}

String* _AbstractRecordType_toString() {

}

typedef struct  {
  _Type _cy_super_;
  ImmutableWasmArray* names;
  WasmArray* fieldTypes;
} _RecordType;

bool _RecordType__checkInstance(Object* o) {

}

String* _RecordType_toString() {

}

bool _RecordType_==(Object* o) {

}

bool _RecordType__sameShape(_RecordType* other) {

}

typedef struct  {
  Object _cy_super_;
} Record;

bool Record__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
} Record_2;

void* Record_2_toString() {

}

bool Record_2_==(Object* other) {

}

bool Record_2__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
  void* $3;
} Record_3;

void* Record_3_toString() {

}

bool Record_3_==(Object* other) {

}

bool Record_3__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
  void* $3;
  void* $4;
} Record_4;

void* Record_4_toString() {

}

bool Record_4_==(Object* other) {

}

bool Record_4__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
} Record_5;

void* Record_5_toString() {

}

bool Record_5_==(Object* other) {

}

bool Record_5__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
} Record_6;

void* Record_6_toString() {

}

bool Record_6_==(Object* other) {

}

bool Record_6__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
  void* $7;
} Record_7;

void* Record_7_toString() {

}

bool Record_7_==(Object* other) {

}

bool Record_7__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
  void* $7;
  void* $8;
} Record_8;

void* Record_8_toString() {

}

bool Record_8_==(Object* other) {

}

bool Record_8__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Record _cy_super_;
  void* $1;
  void* $2;
  void* $3;
  void* $4;
  void* $5;
  void* $6;
  void* $7;
  void* $8;
  void* $9;
} Record_9;

void* Record_9_toString() {

}

bool Record_9_==(Object* other) {

}

bool Record_9__checkRecordType(WasmArray* types, ImmutableWasmArray* names) {

}

typedef struct  {
  Object _cy_super_;
} Comparable;

int Comparable_compareTo(void* other) {

}

typedef struct  {
  Object _cy_super_;
} Pattern;

Match* Pattern_matchAsPrefix(String* string, int start) {

}

typedef struct  {
  Object _cy_super_;
} String;

String* String_[](int index) {

}

int String_codeUnitAt(int index) {

}

bool String_==(Object* other) {

}

int String_compareTo(String* other) {

}

int String_indexOf(Pattern* pattern, int start) {

}

String* String_+(String* other) {

}

typedef struct  {
  String _cy_super_;
} WasmStringBase;

typedef struct  {
  WasmStringBase _cy_super_;
} StringBase;

int StringBase__computeHashCode() {

}

String* StringBase_[](int index) {

}

String* StringBase_+(String* other) {

}

String* StringBase_toString() {

}

int StringBase_compareTo(String* other) {

}

bool StringBase__substringMatches(int start) {

}

int StringBase_indexOf(Pattern* pattern, int start) {

}

Match* StringBase_matchAsPrefix(String* string, int start) {

}

int StringBase__copyIntoTwoByteString(TwoByteString* result, int offset) {

}

typedef struct  {
  StringBase _cy_super_;
  WasmArray* _array;
} OneByteString;

int OneByteString__computeHashCode() {

}

bool OneByteString_==(Object* other) {

}

int OneByteString__codeUnitAtUnchecked(int index) {

}

int OneByteString_codeUnitAt(int index) {

}

int OneByteString__copyIntoTwoByteString(TwoByteString* result, int offset) {

}

int OneByteString_indexOf(Pattern* pattern, int start) {

}

void* OneByteString__setAt(int index, int codePoint) {

}

typedef struct  {
  StringBase _cy_super_;
  WasmArray* _array;
} TwoByteString;

int TwoByteString__computeHashCode() {

}

bool TwoByteString_==(Object* other) {

}

void* TwoByteString__setAt(int index, int codePoint) {

}

int TwoByteString_codeUnitAt(int index) {

}

int TwoByteString__codeUnitAtUnchecked(int index) {

}

int TwoByteString__copyIntoTwoByteString(TwoByteString* result, int offset) {

}

typedef struct  {
  Object _cy_super_;
} StringUncheckedOperationsBase;

int StringUncheckedOperationsBase__codeUnitAtUnchecked(int index) {

}

typedef struct  {
  Object _cy_super_;
  WasmExternRef* _ref;
} JSStringImpl;

int JSStringImpl_codeUnitAt(int index) {

}

int JSStringImpl__codeUnitAtUnchecked(int index) {

}

String* JSStringImpl_+(String* other) {

}

int JSStringImpl__computeHashCode() {

}

String* JSStringImpl_[](int index) {

}

bool JSStringImpl_==(Object* other) {

}

int JSStringImpl_compareTo(String* other) {

}

String* JSStringImpl_toString() {

}

typedef struct  {
  Object _cy_super_;
  WasmArray* _index;
  int _hashMask;
  WasmArray* _data;
  int _usedData;
  int _deletedKeys;
} _HashFieldBase;

typedef struct  {
  _HashFieldBase _cy_super_;
} _HashBase;

bool _HashBase__isModifiedSince(WasmArray* oldData, int oldCheckSum) {

}

typedef struct  {
  _HashFieldBase _cy_super_;
} _DefaultMap$_HashFieldBase$MapMixin;

String* _DefaultMap$_HashFieldBase$MapMixin_toString() {

}

typedef struct  {
  _DefaultMap$_HashFieldBase$MapMixin _cy_super_;
} _DefaultMap$_HashFieldBase$MapMixin$_HashBase;

bool _DefaultMap$_HashFieldBase$MapMixin$_HashBase__isModifiedSince(WasmArray* oldData, int oldCheckSum) {

}

typedef struct  {
  _DefaultMap$_HashFieldBase$MapMixin$_HashBase _cy_super_;
} _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode;

int _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode__hashCode(Object* e) {

}

bool _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode__equals(Object* e1, Object* e2) {

}

typedef struct  {
  _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode _cy_super_;
} _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin;

void* _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin__rehash() {

}

void* _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin__init(int size, int hashMask, WasmArray* oldData, int oldUsed) {

}

void* _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin__insert(void* key, void* value, int fullHash, int hashPattern, int i) {

}

int _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin__findValueOrInsertPoint(void* key, int fullHash, int hashPattern, int size, WasmArray* index) {

}

void* _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin_[]=(void* key, void* value) {

}

void* _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin__set(void* key, void* value, int fullHash) {

}

void* _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin_forEach(void* action) {

}

typedef struct  {
  _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin _cy_super_;
} _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin;

void* _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin__createIndex() {

}

typedef struct  {
  _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin _cy_super_;
} DefaultMap;

typedef struct  {
  _DefaultMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin _cy_super_;
} __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin;

typedef struct  {
  __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin _cy_super_;
} __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin$_ImmutableLinkedHashMapMixin;

typedef struct  {
  __ConstMap$_HashFieldBase$MapMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashMapMixin$_MapCreateIndexMixin$_UnmodifiableMapMixin$_ImmutableLinkedHashMapMixin _cy_super_;
} _ConstMap;

typedef struct  {
  _DefaultMap$_HashFieldBase$MapMixin$_HashBase _cy_super_;
} _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode;

int _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode__hashCode(Object* e) {

}

bool _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode__equals(Object* e1, Object* e2) {

}

typedef struct  {
  _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode _cy_super_;
} _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin;

void* _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin__rehash() {

}

void* _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin__init(int size, int hashMask, WasmArray* oldData, int oldUsed) {

}

void* _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin__insert(void* key, void* value, int fullHash, int hashPattern, int i) {

}

int _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin__findValueOrInsertPoint(void* key, int fullHash, int hashPattern, int size, WasmArray* index) {

}

void* _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin_[]=(void* key, void* value) {

}

void* _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin__set(void* key, void* value, int fullHash) {

}

void* _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin_forEach(void* action) {

}

typedef struct  {
  _CompactLinkedCustomHashMap$_HashFieldBase$MapMixin$_HashBase$_CustomEqualsAndHashCode$_LinkedHashMapMixin _cy_super_;
  void* _equality;
  void* _hasher;
} CompactLinkedCustomHashMap;

typedef struct  {
  _HashFieldBase _cy_super_;
} _DefaultSet$_HashFieldBase$SetMixin;

String* _DefaultSet$_HashFieldBase$SetMixin_toString() {

}

typedef struct  {
  _DefaultSet$_HashFieldBase$SetMixin _cy_super_;
} _DefaultSet$_HashFieldBase$SetMixin$_HashBase;

bool _DefaultSet$_HashFieldBase$SetMixin$_HashBase__isModifiedSince(WasmArray* oldData, int oldCheckSum) {

}

typedef struct  {
  _DefaultSet$_HashFieldBase$SetMixin$_HashBase _cy_super_;
} _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode;

int _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode__hashCode(Object* e) {

}

bool _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode__equals(Object* e1, Object* e2) {

}

typedef struct  {
  _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode _cy_super_;
} _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin;

typedef struct  {
  _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin _cy_super_;
} _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_SetCreateIndexMixin;

void* _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_SetCreateIndexMixin__createIndex() {

}

typedef struct  {
  _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_SetCreateIndexMixin _cy_super_;
} DefaultSet;

typedef struct  {
  _DefaultSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin _cy_super_;
} __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin;

typedef struct  {
  __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin _cy_super_;
} __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin;

typedef struct  {
  __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin _cy_super_;
} __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin$_ImmutableLinkedHashSetMixin;

typedef struct  {
  __ConstSet$_HashFieldBase$SetMixin$_HashBase$_OperatorEqualsAndHashCode$_LinkedHashSetMixin$_UnmodifiableSetMixin$_SetCreateIndexMixin$_ImmutableLinkedHashSetMixin _cy_super_;
} _ConstSet;

typedef struct  {
  Object _cy_super_;
} Map;

void* Map_[]=(void* key, void* value) {

}

void* Map_forEach(void* action) {

}

typedef struct  {
  Object _cy_super_;
} MapBase;

typedef struct  {
  Object _cy_super_;
} _EqualsAndHashCode;

int _EqualsAndHashCode__hashCode(Object* e) {

}

bool _EqualsAndHashCode__equals(Object* e1, Object* e2) {

}

typedef struct  {
  Object _cy_super_;
} _OperatorEqualsAndHashCode;

typedef struct  {
  Object _cy_super_;
} __LinkedHashMapMixin$_HashBase$_EqualsAndHashCode;

typedef struct  {
  __LinkedHashMapMixin$_HashBase$_EqualsAndHashCode _cy_super_;
} _LinkedHashMapMixin;

void* _LinkedHashMapMixin__rehash() {

}

void* _LinkedHashMapMixin__init(int size, int hashMask, WasmArray* oldData, int oldUsed) {

}

void* _LinkedHashMapMixin__insert(void* key, void* value, int fullHash, int hashPattern, int i) {

}

int _LinkedHashMapMixin__findValueOrInsertPoint(void* key, int fullHash, int hashPattern, int size, WasmArray* index) {

}

void* _LinkedHashMapMixin__set(void* key, void* value, int fullHash) {

}

typedef struct  {
  __LinkedHashMapMixin$_HashBase$_EqualsAndHashCode _cy_super_;
} _LinkedHashSetMixin;

typedef struct  {
  Object _cy_super_;
} __MapCreateIndexMixin$_LinkedHashMapMixin$_HashFieldBase;

typedef struct  {
  __MapCreateIndexMixin$_LinkedHashMapMixin$_HashFieldBase _cy_super_;
} _MapCreateIndexMixin;

typedef struct  {
  _MapCreateIndexMixin _cy_super_;
} _ImmutableLinkedHashMapMixin;

typedef struct  {
  Object _cy_super_;
} LinkedHashMap;

typedef struct  {
  Object _cy_super_;
} _UnmodifiableMapMixin;

typedef struct  {
  Object _cy_super_;
} _CustomEqualsAndHashCode;

typedef struct  {
  Object _cy_super_;
} Iterable;

List* Iterable_toList() {

}

void* Iterable_elementAt(int index) {

}

String* Iterable_toString() {

}

typedef struct  {
  Iterable _cy_super_;
} EfficientLengthIterable;

typedef struct  {
  EfficientLengthIterable _cy_super_;
} ListIterable;

typedef struct  {
  ListIterable _cy_super_;
  Iterable* _iterable;
  int _start;
  int _endOrLength;
} SubListIterable;

void* SubListIterable_elementAt(int index) {

}

List* SubListIterable_toList() {

}

typedef struct  {
  Iterable _cy_super_;
  _HashBase* _table;
} _CompactEntriesIterable;

typedef struct  {
  Iterable _cy_super_;
  WasmStructRef* _context;
  void* _resume;
} _SyncStarIterable;

typedef struct  {
  Object _cy_super_;
} HideEfficientLengthIterable;

typedef struct  {
  Object _cy_super_;
} _SetIterable;

typedef struct  {
  Object _cy_super_;
} Set;

typedef struct  {
  Object _cy_super_;
} SetBase;

typedef struct  {
  Object _cy_super_;
} __SetCreateIndexMixin$Set$_LinkedHashSetMixin;

typedef struct  {
  Object _cy_super_;
} __SetCreateIndexMixin$Set$_LinkedHashSetMixin$_HashFieldBase;

typedef struct  {
  __SetCreateIndexMixin$Set$_LinkedHashSetMixin$_HashFieldBase _cy_super_;
} _SetCreateIndexMixin;

typedef struct  {
  _SetCreateIndexMixin _cy_super_;
} _ImmutableLinkedHashSetMixin;

typedef struct  {
  Object _cy_super_;
} LinkedHashSet;

typedef struct  {
  Object _cy_super_;
} _UnmodifiableSetMixin;

typedef struct  {
  Object _cy_super_;
} ByteBuffer;

typedef struct  {
  Object _cy_super_;
} TypedData;

typedef struct  {
  Object _cy_super_;
} ByteData;

typedef struct  {
  Object _cy_super_;
} _ListIterable;

typedef struct  {
  Object _cy_super_;
} List;

void* List_[](int index) {

}

void* List_[]=(int index, void* value) {

}

void* List_add(void* value) {

}

void* List_sort(void* compare) {

}

void* List_removeLast() {

}

void* List_setRange(int start, int end, Iterable* iterable, int skipCount) {

}

void* List_fillRange(int start, int end, void* fillValue) {

}

typedef struct  {
  Object _cy_super_;
} TypedDataList;

typedef struct  {
  Object _cy_super_;
} _TypedIntList;

typedef struct  {
  Object _cy_super_;
} Uint8List;

Uint8List* Uint8List_sublist(int start, int end) {

}

typedef struct  {
  Object _cy_super_;
} ListBase;

void* ListBase_sort(void* compare) {

}

String* ListBase_toString() {

}

typedef struct  {
  ListBase _cy_super_;
  int _length;
  WasmArray* _data;
} WasmListBase;

void* WasmListBase_[](int index) {

}

typedef struct  {
  WasmListBase _cy_super_;
} _ModifiableList;

void* _ModifiableList_[]=(int index, void* value) {

}

typedef struct  {
  _ModifiableList _cy_super_;
  WasmArray* _emptyData;
} GrowableList;

void* GrowableList__setLength(int newLength) {

}

void* GrowableList_add(void* value) {

}

void* GrowableList_removeLast() {

}

int GrowableList__nextCapacity(int oldCapacity) {

}

void* GrowableList__grow(int newCapacity) {

}

void* GrowableList__growToNextCapacity() {

}

void* GrowableList__shrink(int newCapacity, int newLength) {

}

ModifiableFixedLengthList* GrowableList__toModifiableFixedLengthList() {

}

ImmutableList* GrowableList__toUnmodifiableList() {

}

typedef struct  {
  _ModifiableList _cy_super_;
} _ModifiableFixedLengthList$_ModifiableList$FixedLengthListMixin;

void* _ModifiableFixedLengthList$_ModifiableList$FixedLengthListMixin_add(void* value) {

}

typedef struct  {
  _ModifiableFixedLengthList$_ModifiableList$FixedLengthListMixin _cy_super_;
} ModifiableFixedLengthList;

typedef struct  {
  WasmListBase _cy_super_;
} _ImmutableList$WasmListBase$UnmodifiableListMixin;

void* _ImmutableList$WasmListBase$UnmodifiableListMixin_add(void* value) {

}

typedef struct  {
  _ImmutableList$WasmListBase$UnmodifiableListMixin _cy_super_;
} ImmutableList;

typedef struct  {
  Object _cy_super_;
} FixedLengthListMixin;

typedef struct  {
  Object _cy_super_;
} UnmodifiableListMixin;

typedef struct  {
  Object _cy_super_;
} _UnmodifiableMapMixin;

typedef struct  {
  Object _cy_super_;
  Map* _map;
} MapView;

void* MapView_forEach(void* action) {

}

String* MapView_toString() {

}

typedef struct  {
  MapView _cy_super_;
} _UnmodifiableMapView$MapView$_UnmodifiableMapMixin;

typedef struct  {
  _UnmodifiableMapView$MapView$_UnmodifiableMapMixin _cy_super_;
} UnmodifiableMapView;

typedef struct  {
  Object _cy_super_;
} Exception;

typedef struct  {
  Object _cy_super_;
} StringSink;

typedef struct  {
  Object _cy_super_;
  WasmArray* _parts;
  int _partsWriteIndex;
  int _partsCodeUnits;
  int _partsCompactionIndex;
  int _partsCodeUnitsSinceCompaction;
  WasmArray* _buffer;
  int _bufferPosition;
  int _bufferCodeUnitMagnitude;
} StringBuffer;

void* StringBuffer__writeString(String* str) {

}

void* StringBuffer__consumeBuffer() {

}

void* StringBuffer__addPart(String* str) {

}

void* StringBuffer__compact() {

}

void* StringBuffer_write(Object* obj) {

}

void* StringBuffer_writeAll(Iterable* objects) {

}

String* StringBuffer_toString() {

}

typedef struct  {
  Object _cy_super_;
  String* name;
  _Type* type;
  bool isRequired;
} _NamedParameter;

bool _NamedParameter_==(Object* o) {

}

String* _NamedParameter_toString() {

}

typedef struct  {
  Object _cy_super_;
  String* _name;
} Symbol;

bool Symbol_==(Object* other) {

}

String* Symbol_toString() {

}

typedef struct  {
  Object _cy_super_;
} StackTrace;

typedef struct  {
  Object _cy_super_;
  String* _stackTrace;
} _StringStackTrace;

String* _StringStackTrace_toString() {

}

typedef struct  {
  Object _cy_super_;
} Match;

typedef struct  {
  Object _cy_super_;
} Null;

String* Null_toString() {

}

typedef struct  {
  Object _cy_super_;
  void* key;
  void* value;
} MapEntry;

String* MapEntry_toString() {

}

typedef struct  {
  Object _cy_super_;
} Invocation;

typedef struct  {
  Object _cy_super_;
  Symbol* memberName;
  List* _positional;
  Map* _named;
} _Invocation;

typedef struct  {
  Object _cy_super_;
  StackTrace* _stackTrace;
} Error;

typedef struct  {
  Error _cy_super_;
  String* message;
} UnsupportedError;

String* UnsupportedError_toString() {

}

typedef struct  {
  Error _cy_super_;
  String* _message;
} _Error;

String* _Error_toString() {

}

typedef struct  {
  _Error _cy_super_;
} _TypeError;

typedef struct  {
  Error _cy_super_;
} TypeError;

typedef struct  {
  Error _cy_super_;
} _JavaScriptError;

String* _JavaScriptError_toString() {

}

typedef struct  {
  Error _cy_super_;
  _Type* left;
  _Type* right;
  bool optimized;
  bool reference;
  String* location;
} _TypeCheckVerificationError;

String* _TypeCheckVerificationError_toString() {

}

typedef struct  {
  Error _cy_super_;
  Object* message;
} AssertionError;

typedef struct  {
  AssertionError _cy_super_;
  String* _fileUri;
  int _line;
  int _column;
  String* _conditionSource;
} _AssertionErrorImpl;

String* _AssertionErrorImpl_toString() {

}

typedef struct  {
  Error _cy_super_;
  bool _hasValue;
  void* invalidValue;
  String* name;
  void* message;
} ArgumentError;

String* ArgumentError_toString() {

}

typedef struct  {
  ArgumentError _cy_super_;
  double start;
  double end;
} RangeError;

typedef struct  {
  ArgumentError _cy_super_;
  int length;
} IndexError;

typedef struct  {
  Error _cy_super_;
  Object* _receiver;
  Symbol* _memberName;
  List* _arguments;
  Map* _namedArguments;
  List* _existingArgumentNames;
} NoSuchMethodError;

String* NoSuchMethodError_toString() {

}

typedef struct  {
  Error _cy_super_;
  String* message;
} StateError;

String* StateError_toString() {

}

typedef struct  {
  Error _cy_super_;
  Object* modifiedObject;
} ConcurrentModificationError;

String* ConcurrentModificationError_toString() {

}

typedef struct  {
  Object _cy_super_;
} IntegerDivisionByZeroException;

String* IntegerDivisionByZeroException_toString() {

}

typedef struct  {
  Object _cy_super_;
  String* name;
  Object* options;
} pragma;

typedef struct  {
  Object _cy_super_;
} Iterator;

bool Iterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
  void* _current;
  Iterable* _yieldStarIterable;
  Iterator* _yieldStarIterator;
  _SuspendState* _state;
} _SyncStarIterator;

bool _SyncStarIterator__handleSyncStarMethodCompletion() {

}

bool _SyncStarIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
  void* _resume;
  _SuspendState* _parent;
  _SyncStarIterator* _iterator;
  WasmStructRef* _context;
  WasmI32* _targetIndex;
  Object* _currentException;
  StackTrace* _currentExceptionStackTrace;
} _SuspendState;

typedef struct  {
  Object _cy_super_;
} _TypeUniverse;

typedef struct  {
  Object _cy_super_;
  _Environment* parent;
  void* type;
  int depth;
} _Environment;

_Environment* _Environment_adjust(void* param) {

}

_Type* _Environment_lookupAdjusted(void* param) {

}

typedef struct  {
  Object _cy_super_;
  List* fieldTypes;
  int packing;
} _FfiStructLayout;

typedef struct  {
  Object _cy_super_;
  Type* elementType;
  int length;
  bool variableLength;
} _FfiInlineArray;

typedef struct  {
  Object _cy_super_;
} NativeType;

typedef struct  {
  Object _cy_super_;
} SizedNativeType;

typedef struct  {
  Object _cy_super_;
  WasmI32* _address;
} Pointer;

bool Pointer_==(Object* other) {

}

typedef struct  {
  Object _cy_super_;
} _Compound;

typedef struct  {
  _Compound _cy_super_;
} Struct;

typedef struct  {
  _Compound _cy_super_;
} Union;

typedef struct  {
  Object _cy_super_;
  _HashBase* _table;
  WasmArray* _data;
  int _len;
  int _offset;
  int _step;
  int _checkSum;
  void* _current;
} _CompactIterator;

bool _CompactIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
  _HashBase* _table;
  WasmArray* _data;
  int _len;
  int _offset;
  int _checkSum;
  MapEntry* _current;
} _CompactEntriesIterator;

bool _CompactEntriesIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
  _Zone* _current;
} Zone;

void* Zone_handleUncaughtError(Object* error, StackTrace* stackTrace) {

}

void* Zone_run(void* action) {

}

void* Zone_runUnary(void* action, void* argument) {

}

void* Zone_runBinary(void* action, void* argument1, void* argument2) {

}

void* Zone_registerCallback(void* callback) {

}

void* Zone_registerUnaryCallback(void* callback) {

}

void* Zone_registerBinaryCallback(void* callback) {

}

void* Zone_bindCallback(void* callback) {

}

void* Zone_bindCallbackGuarded(void* callback) {

}

AsyncError* Zone_errorCallback() {

}

void* Zone_scheduleMicrotask(void* callback) {

}

typedef struct  {
  Object _cy_super_;
} _Zone;

bool _Zone_inSameErrorZone(Zone* otherZone) {

}

typedef struct  {
  _Zone _cy_super_;
} _RootZone;

void* _RootZone_runGuarded(void* f) {

}

void* _RootZone_bindCallback(void* f) {

}

void* _RootZone_bindCallbackGuarded(void* f) {

}

void* _RootZone_handleUncaughtError(Object* error, StackTrace* stackTrace) {

}

void* _RootZone_run(void* f) {

}

void* _RootZone_runUnary(void* f, void* arg) {

}

void* _RootZone_runBinary(void* f, void* arg1, void* arg2) {

}

void* _RootZone_registerCallback(void* f) {

}

void* _RootZone_registerUnaryCallback(void* f) {

}

void* _RootZone_registerBinaryCallback(void* f) {

}

AsyncError* _RootZone_errorCallback() {

}

void* _RootZone_scheduleMicrotask(void* f) {

}

typedef struct  {
  Object _cy_super_;
  WasmArray* _data;
  int _len;
  int _offset;
  int _step;
  void* _current;
} _CompactIteratorImmutable;

bool _CompactIteratorImmutable_moveNext() {

}

typedef struct  {
  Object _cy_super_;
} ZoneDelegate;

typedef struct  {
  Object _cy_super_;
  _Zone* zone;
  void* function;
} _ZoneFunction;

typedef struct  {
  Object _cy_super_;
} _AsyncRun;

typedef struct  {
  Object _cy_super_;
  void* callback;
  _AsyncCallbackEntry* next;
} _AsyncCallbackEntry;

typedef struct  {
  Object _cy_super_;
} Future;

Future* Future_then(FutureOr* onValue, void* onError) {

}

typedef struct  {
  Object _cy_super_;
  int _state;
  _Zone* _zone;
  void* _resultOrListeners;
} _Future;

void* _Future__setChained(_Future* source) {

}

Future* _Future_then(FutureOr* f, void* onError) {

}

void* _Future__setPendingComplete() {

}

void* _Future__clearPendingComplete() {

}

void* _Future__setValue(void* value) {

}

void* _Future__setErrorObject(AsyncError* error) {

}

void* _Future__setError(Object* error, StackTrace* stackTrace) {

}

void* _Future__cloneResult(_Future* source) {

}

void* _Future__addListener(_FutureListener* listener) {

}

void* _Future__prependListeners(_FutureListener* listeners) {

}

_FutureListener* _Future__removeListeners() {

}

_FutureListener* _Future__reverseListeners(_FutureListener* listeners) {

}

void* _Future__chainForeignFuture(Future* source) {

}

void* _Future__completeWithValue(void* value) {

}

void* _Future__completeWithResultOf(_Future* source) {

}

void* _Future__completeError(Object* error, StackTrace* stackTrace) {

}

void* _Future__asyncComplete(FutureOr* value) {

}

void* _Future__asyncCompleteWithValue(void* value) {

}

void* _Future__chainFuture(Future* value) {

}

void* _Future__asyncCompleteError(Object* error, StackTrace* stackTrace) {

}

_Future* _Future__newFutureWithSameType() {

}

typedef struct  {
  Object _cy_super_;
  _FutureListener* _nextListener;
  _Future* result;
  int state;
  void* callback;
  void* errorCallback;
} _FutureListener;

FutureOr* _FutureListener_handleValue(void* sourceResult) {

}

bool _FutureListener_matchesErrorTest(AsyncError* asyncError) {

}

FutureOr* _FutureListener_handleError(AsyncError* asyncError) {

}

void* _FutureListener_handleWhenComplete() {

}

bool _FutureListener_shouldChain(Future* value) {

}

typedef struct  {
  Object _cy_super_;
} Completer;

typedef struct  {
  Object _cy_super_;
  _Future* future;
} _Completer;

void* _Completer_completeError(Object* error, StackTrace* stackTrace) {

}

void* _Completer__completeError(Object* error, StackTrace* stackTrace) {

}

typedef struct  {
  _Completer _cy_super_;
} _AsyncCompleter;

void* _AsyncCompleter_complete(FutureOr* value) {

}

void* _AsyncCompleter__completeError(Object* error, StackTrace* stackTrace) {

}

typedef struct  {
  Object _cy_super_;
} StringMatch;

typedef struct  {
  Object _cy_super_;
  Object* error;
  StackTrace* stackTrace;
} AsyncError;

String* AsyncError_toString() {

}

typedef struct  {
  Object _cy_super_;
} _JSEventLoop;

typedef struct  {
  Object _cy_super_;
  TypedDataList* _array;
  int _length;
  int _position;
  void* _current;
} _TypedListIterator;

bool _TypedListIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
} _IntListMixin;

typedef struct  {
  _IntListMixin _cy_super_;
} _TypedIntListMixin;

void* _TypedIntListMixin__createList(int length) {

}

typedef struct  {
  Object _cy_super_;
  GrowableList* _list;
  int _length;
  int _index;
  void* _current;
} _GrowableListIterator;

bool _GrowableListIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
  WasmArray* _data;
  int _index;
  void* _current;
} _FixedSizeListIterator;

bool _FixedSizeListIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
  JSArrayImpl* _array;
  int _length;
  int _index;
} JSArrayImplIterator;

bool JSArrayImplIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
  WasmExternRef* _ref;
} JSArrayImpl;

void* JSArrayImpl_add(void* value) {

}

String* JSArrayImpl_toString() {

}

void* JSArrayImpl__getUnchecked(int index) {

}

void* JSArrayImpl_[](int index) {

}

void* JSArrayImpl__setUnchecked(int index, void* value) {

}

void* JSArrayImpl_[]=(int index, void* value) {

}

typedef struct  {
  Object _cy_super_;
  WasmExternRef* _ref;
} JSValue;

bool JSValue_==(Object* that) {

}

String* JSValue_toString() {

}

typedef struct  {
  Object _cy_super_;
  String* _name;
} Symbol;

bool Symbol_==(Object* other) {

}

String* Symbol_toString() {

}

typedef struct  {
  Object _cy_super_;
} Sort;

typedef struct  {
  Object _cy_super_;
  void* _resume;
  WasmStructRef* _context;
  WasmI32* _targetIndex;
  _AsyncCompleter* _completer;
  Object* _currentException;
  StackTrace* _currentExceptionStackTrace;
  Object* _currentReturnValue;
} _AsyncSuspendState;

typedef struct  {
  Object _cy_super_;
  List* nativeTypes;
} _FfiAbiSpecificMapping;

typedef struct  {
  Object _cy_super_;
} IterableElementError;

typedef struct  {
  Object _cy_super_;
  Iterable* _iterable;
  int _length;
  int _index;
  void* _current;
} ListIterator;

bool ListIterator_moveNext() {

}

typedef struct  {
  Object _cy_super_;
} IndexErrorUtils;

typedef struct  {
  Object _cy_super_;
} RangeErrorUtils;

typedef struct  {
  Object _cy_super_;
} Lists;

typedef struct  {
  Object _cy_super_;
} WasmTypedDataBase;

typedef struct  {
  WasmTypedDataBase _cy_super_;
} ByteBufferBase;

typedef struct  {
  ByteBufferBase _cy_super_;
  WasmArray* _data;
} _I8ByteBuffer;

bool _I8ByteBuffer_==(Object* other) {

}

typedef struct  {
  ByteBufferBase _cy_super_;
} _I16ByteBuffer;

typedef struct  {
  ByteBufferBase _cy_super_;
} _I32ByteBuffer;

typedef struct  {
  ByteBufferBase _cy_super_;
} _I64ByteBuffer;

typedef struct  {
  WasmTypedDataBase _cy_super_;
  WasmArray* _data;
  int _offsetInElements;
  int length;
} WasmI8ArrayBase;

typedef struct  {
  WasmI8ArrayBase _cy_super_;
} _I8List$WasmI8ArrayBase$_IntListMixin;

Iterable* _I8List$WasmI8ArrayBase$_IntListMixin_skip(int n) {

}

int _I8List$WasmI8ArrayBase$_IntListMixin_elementAt(int index) {

}

void* _I8List$WasmI8ArrayBase$_IntListMixin_add(int value) {

}

void* _I8List$WasmI8ArrayBase$_IntListMixin_fillRange(int start, int end, int fillValue) {

}

typedef struct  {
  _I8List$WasmI8ArrayBase$_IntListMixin _cy_super_;
} _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin;

void* _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin_setRange(int start, int end, Iterable* from, int skipCount) {

}

U8List* _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin_sublist(int start, int end) {

}

typedef struct  {
  _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin _cy_super_;
} _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin$_TypedListCommonOperationsMixin;

String* _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin$_TypedListCommonOperationsMixin_toString() {

}

typedef struct  {
  _U8List$WasmI8ArrayBase$_IntListMixin$_TypedIntListMixin$_TypedListCommonOperationsMixin _cy_super_;
} U8List;

U8List* U8List__createList(int length) {

}

int U8List_[](int index) {

}

void* U8List_[]=(int index, int value) {

}

typedef struct  {
  Object _cy_super_;
} _TypedListCommonOperationsMixin;

typedef struct  {
  Object _cy_super_;
} SystemHash;

typedef struct  {
  Object _cy_super_;
  int id;
} SentinelValue;

typedef struct  {
  Object _cy_super_;
} TypeTest;

bool TypeTest_test(Object* v) {

}

typedef struct  {
  Object _cy_super_;
} Random;

int Random_nextInt(int max) {

}

typedef struct  {
  Object _cy_super_;
  int _state;
  _Random* _prng;
} _Random;

void* _Random__nextState() {

}

int _Random_nextInt(int max) {

}

typedef struct  {
  Object _cy_super_;
} ClassID;

typedef struct  {
  Object _cy_super_;
  int aa;
  int bb;
} MyTest;

void* MyTest_sum() {

}

void* MyTest_sum2(int aa, String* bb, String* cc) {

}

typedef struct  {
  Object _cy_super_;
} _WasmBase;

typedef struct  {
  _WasmBase _cy_super_;
} WasmAnyRef;

typedef struct  {
  WasmAnyRef _cy_super_;
} WasmEqRef;

typedef struct  {
  WasmEqRef _cy_super_;
} WasmStructRef;

typedef struct  {
  WasmEqRef _cy_super_;
} WasmArrayRef;

typedef struct  {
  WasmArrayRef _cy_super_;
  List* _value;
} WasmArray;

typedef struct  {
  WasmArrayRef _cy_super_;
  List* _value;
} ImmutableWasmArray;

typedef struct  {
  _WasmBase _cy_super_;
} WasmExternRef;

typedef struct  {
  _WasmBase _cy_super_;
} WasmFuncRef;

typedef struct  {
  WasmFuncRef _cy_super_;
} WasmFunction;

typedef struct  {
  _WasmBase _cy_super_;
} WasmI8;

typedef struct  {
  _WasmBase _cy_super_;
} WasmI16;

typedef struct  {
  _WasmBase _cy_super_;
  int _value;
} WasmI32;

typedef struct  {
  _WasmBase _cy_super_;
} WasmI64;

typedef struct  {
  _WasmBase _cy_super_;
} WasmF32;

typedef struct  {
  _WasmBase _cy_super_;
} WasmF64;

typedef struct  {
  _WasmBase _cy_super_;
} WasmVoid;

typedef struct  {
  _WasmBase _cy_super_;
} WasmTable;

typedef struct  {
  bool _cy_super_;
  bool value;
} BoxedBool;

bool BoxedBool_==(Object* other) {

}

typedef struct  {
  _Cy_GC_ _cy_super_;
  double value;
  List* _cache;
  int _cacheEvictIndex;
} BoxedDouble;

double BoxedDouble_+(double other) {

}

double BoxedDouble_-(double other) {

}

double BoxedDouble_*(double other) {

}

double BoxedDouble_/(double other) {

}

double BoxedDouble_%(double other) {

}

bool BoxedDouble_==(Object* other) {

}

bool BoxedDouble_<(double other) {

}

bool BoxedDouble_>(double other) {

}

bool BoxedDouble_>=(double other) {

}

double BoxedDouble_abs() {

}

int BoxedDouble_floor() {

}

int BoxedDouble_ceil() {

}

int BoxedDouble_toInt() {

}

double BoxedDouble_toDouble() {

}

String* BoxedDouble_toString() {

}

int BoxedDouble_compareTo(double other) {

}

typedef struct  {
  _Cy_GC_ _cy_super_;
  int value;
} BoxedInt;

int BoxedInt_~/(double other) {

}

double BoxedInt_%(double other) {

}

double BoxedInt_remainder(double other) {

}

int BoxedInt_>>(int shift) {

}

int BoxedInt_>>>(int shift) {

}

int BoxedInt_<<(int shift) {

}

bool BoxedInt_==(Object* other) {

}

int BoxedInt_abs() {

}

int BoxedInt_compareTo(double other) {

}

double BoxedInt_clamp(double lowerLimit, double upperLimit) {

}

String* BoxedInt_toString() {

}




// void Object_0GcMark(Object* obj, int mark) {
//   obj->mark= mark;
// }

// void Object_0GcDestory(Object* obj) {
//   free(obj);
// }


// ClassInfoHeader object_class_info = {
//   .name = "Object",
//   .super = NULL,
//   .method_name = {
//     "mark",
//     "destroy"
//   },
//   .method_vtbl = {
//     Object_0GcMark,
//     Object_0GcDestory
//   }
// };


// typedef struct  {
//   Object object;
// } Shape;


// double Shape_getArea(const Shape* shape) {
//   return 0;
// }

// void Shape_printInfo(const Shape* shape) {
//   printf("Shape info\n");
// }


// ClassInfoHeader shape_class_info = {
//   .name = "Shape",
//   .super = &object_class_info,
//   .method_name = {
//     "mark",
//     "destroy",
//     "getArea",
//     "printInfo"
//   },
//   .method_vtbl = {
//     Object_0GcMark,
//     Object_0GcDestory,
//     Shape_getArea,
//     Shape_printInfo
//   }
// };