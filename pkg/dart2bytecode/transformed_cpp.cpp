// Generated C++ header
#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <memory>
#include <any>
#include <functional>
#include <stdint.h>

namespace dart_cpp {

// Forward declarations
class CppAny;
class CppIterator;
class CppIterable;
class CppMappedIterable;
class CppMappedIterator;
class CppWhereIterable;
class CppWhereIterator;
class CppWhereTypeIterable;
class CppWhereTypeIterator;
class CppExpandIterable;
class CppExpandIterator;
class CppTakeIterable;
class CppTakeIterator;
class CppTakeWhileIterable;
class CppTakeWhileIterator;
class CppSkipIterable;
class CppSkipIterator;
class CppSkipWhileIterable;
class CppSkipWhileIterator;
class CppReversedIterable;
class CppReversedIterator;
class CppFollowedByIterable;
class CppFollowedByIterator;
class CppCastIterable;
class CppCastIterator;
class _CppEmptyIterable;
class _CppEmptyIterator;
class _CppGenerateIterable;
class _CppGenerateIterator;
class _CppUnmodifiableIterable;
class _CppCastFromIterable;
class _CppCastFromIterator;
class CppStringPool;
class CppStringPoolStats;
class CppStringBuffer;
class CppString;
class CppStringMatch;
class _CppStringAllMatchesIterable;
class _CppStringAllMatchesIterator;
class CppList;
class CppArrayList;
class _CppListIterator;
class CppSet;
class CppArraySet;
class CppMapEntry;
class CppMap;
class CppArrayMap;
class CppStackTrace;
class CppError;
class CppStateError;
class CppRangeError;
class CppIndexError;
class BoxInt;
class BoxDouble;
class BoxBool;
class BoxString;

// Boxing classes for primitive types
class BoxInt : public CppAny {
public:
    public:
        int64_t value;
        BoxInt(int64_t val = 0) : value(val) {}
};

class BoxBool : public CppAny {
public:
    public:
        bool value;
        BoxBool(bool val = false) : value(val) {}
};

class BoxDouble : public CppAny {
public:
    public:
        double value;
        BoxDouble(double val = 0.0) : value(val) {}
};

class BoxString : public CppAny {
public:
    public:
        std::string value;
        BoxString(std::string val = "") : value(val) {}
};

// Class: CppAny
class CppAny {
public:
        CppAny();
        virtual ~CppAny();
    
        DartObject* toCppString();
};

// Class: CppIterator
class CppIterator : public CppAny {
public:
        CppIterator();
        virtual ~CppIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppIterable
class CppIterable : public CppAny {
public:
        CppIterable();
        virtual ~CppIterable();
    
        DartObject* iterator();
        int64_t length();
        bool isEmpty();
        bool isNotEmpty();
        std::any first();
        std::any last();
        std::any single();
        std::any elementAt(int64_t index);
        bool contains(DartObject* element);
        void forEach(std::any action);
        DartObject* map(std::any toElement);
        DartObject* where(std::any test);
        DartObject* whereType();
        DartObject* expand(std::any toElements);
        bool any(std::any test);
        bool every(std::any test);
        std::any firstWhere(std::any test);
        std::any lastWhere(std::any test);
        std::any singleWhere(std::any test);
        std::any reduce(std::any combine);
        std::any fold(std::any initialValue, std::any combine);
        DartObject* join(DartObject* separator);
        DartObject* take(int64_t count);
        DartObject* takeWhile(std::any test);
        DartObject* skip(int64_t count);
        DartObject* skipWhile(std::any test);
        DartObject* reversed();
        DartObject* followedBy(DartObject* other);
        DartObject* toList();
        DartObject* toSet();
        DartObject* cast();
        // Static methods
        static DartObject* empty();
        static DartObject* generate(int64_t count, std::any generator);
        static DartObject* unmodifiable(DartObject* elements);
        static DartObject* castFrom(DartObject* source);
};

// Class: CppMappedIterable
class CppMappedIterable : public CppAny {
public:
    private:
        DartObject* _source;
        std::any _f;
    
    public:
        CppMappedIterable(DartObject* _source, std::any _f);
        virtual ~CppMappedIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppMappedIterator
class CppMappedIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
        std::any _f;
        std::any _current;
    
    public:
        CppMappedIterator(DartObject* _iterator, std::any _f);
        virtual ~CppMappedIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppWhereIterable
class CppWhereIterable : public CppAny {
public:
    private:
        DartObject* _source;
        std::any _test;
    
    public:
        CppWhereIterable(DartObject* _source, std::any _test);
        virtual ~CppWhereIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppWhereIterator
class CppWhereIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
        std::any _test;
    
    public:
        CppWhereIterator(DartObject* _iterator, std::any _test);
        virtual ~CppWhereIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppWhereTypeIterable
class CppWhereTypeIterable : public CppAny {
public:
    private:
        DartObject* _source;
    
    public:
        CppWhereTypeIterable(DartObject* _source);
        virtual ~CppWhereTypeIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppWhereTypeIterator
class CppWhereTypeIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
    
    public:
        CppWhereTypeIterator(DartObject* _iterator);
        virtual ~CppWhereTypeIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppExpandIterable
class CppExpandIterable : public CppAny {
public:
    private:
        DartObject* _source;
        std::any _f;
    
    public:
        CppExpandIterable(DartObject* _source, std::any _f);
        virtual ~CppExpandIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppExpandIterator
class CppExpandIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
        std::any _f;
        DartObject* _currentIterator;
    
    public:
        CppExpandIterator(DartObject* _iterator, std::any _f);
        virtual ~CppExpandIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppTakeIterable
class CppTakeIterable : public CppAny {
public:
    private:
        DartObject* _source;
        int64_t _count;
    
    public:
        CppTakeIterable(DartObject* _source, int64_t _count);
        virtual ~CppTakeIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppTakeIterator
class CppTakeIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
        int64_t _count;
        int64_t _remaining;
    
    public:
        CppTakeIterator(DartObject* _iterator, int64_t _count);
        virtual ~CppTakeIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppTakeWhileIterable
class CppTakeWhileIterable : public CppAny {
public:
    private:
        DartObject* _source;
        std::any _test;
    
    public:
        CppTakeWhileIterable(DartObject* _source, std::any _test);
        virtual ~CppTakeWhileIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppTakeWhileIterator
class CppTakeWhileIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
        std::any _test;
        bool _finished;
    
    public:
        CppTakeWhileIterator(DartObject* _iterator, std::any _test);
        virtual ~CppTakeWhileIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppSkipIterable
class CppSkipIterable : public CppAny {
public:
    private:
        DartObject* _source;
        int64_t _count;
    
    public:
        CppSkipIterable(DartObject* _source, int64_t _count);
        virtual ~CppSkipIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppSkipIterator
class CppSkipIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
        int64_t _count;
        bool _skipped;
    
    public:
        CppSkipIterator(DartObject* _iterator, int64_t _count);
        virtual ~CppSkipIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppSkipWhileIterable
class CppSkipWhileIterable : public CppAny {
public:
    private:
        DartObject* _source;
        std::any _test;
    
    public:
        CppSkipWhileIterable(DartObject* _source, std::any _test);
        virtual ~CppSkipWhileIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppSkipWhileIterator
class CppSkipWhileIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
        std::any _test;
        bool _skipped;
    
    public:
        CppSkipWhileIterator(DartObject* _iterator, std::any _test);
        virtual ~CppSkipWhileIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppReversedIterable
class CppReversedIterable : public CppAny {
public:
    private:
        DartObject* _source;
    
    public:
        CppReversedIterable(DartObject* _source);
        virtual ~CppReversedIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppReversedIterator
class CppReversedIterator : public CppAny {
public:
    private:
        DartObject* _elements;
        int64_t _index;
    
    public:
        CppReversedIterator(DartObject* source);
        virtual ~CppReversedIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppFollowedByIterable
class CppFollowedByIterable : public CppAny {
public:
    private:
        DartObject* _first;
        DartObject* _second;
    
    public:
        CppFollowedByIterable(DartObject* _first, DartObject* _second);
        virtual ~CppFollowedByIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppFollowedByIterator
class CppFollowedByIterator : public CppAny {
public:
    private:
        DartObject* _first;
        DartObject* _second;
        bool _usingFirst;
    
    public:
        CppFollowedByIterator(DartObject* _first, DartObject* _second);
        virtual ~CppFollowedByIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppCastIterable
class CppCastIterable : public CppAny {
public:
    private:
        DartObject* _source;
    
    public:
        CppCastIterable(DartObject* _source);
        virtual ~CppCastIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: CppCastIterator
class CppCastIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
    
    public:
        CppCastIterator(DartObject* _iterator);
        virtual ~CppCastIterator();
    
        std::any current();
        bool moveNext();
};

// Class: _CppEmptyIterable
class _CppEmptyIterable : public CppAny {
public:
        _CppEmptyIterable();
        virtual ~_CppEmptyIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: _CppEmptyIterator
class _CppEmptyIterator : public CppAny {
public:
        _CppEmptyIterator();
        virtual ~_CppEmptyIterator();
    
        std::any current();
        bool moveNext();
};

// Class: _CppGenerateIterable
class _CppGenerateIterable : public CppAny {
public:
    private:
        int64_t _count;
        std::any _generator;
    
    public:
        _CppGenerateIterable(int64_t _count, std::any _generator);
        virtual ~_CppGenerateIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: _CppGenerateIterator
class _CppGenerateIterator : public CppAny {
public:
    private:
        int64_t _count;
        std::any _generator;
        int64_t _index;
        std::any _current;
    
    public:
        _CppGenerateIterator(int64_t _count, std::any _generator);
        virtual ~_CppGenerateIterator();
    
        std::any current();
        bool moveNext();
};

// Class: _CppUnmodifiableIterable
class _CppUnmodifiableIterable : public CppAny {
public:
    private:
        DartObject* _elements;
    
    public:
        _CppUnmodifiableIterable(DartObject* _elements);
        virtual ~_CppUnmodifiableIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: _CppCastFromIterable
class _CppCastFromIterable : public CppAny {
public:
    private:
        DartObject* _source;
    
    public:
        _CppCastFromIterable(DartObject* _source);
        virtual ~_CppCastFromIterable();
    
        DartObject* iterator();
        int64_t length();
};

// Class: _CppCastFromIterator
class _CppCastFromIterator : public CppAny {
public:
    private:
        DartObject* _iterator;
    
    public:
        _CppCastFromIterator(DartObject* _iterator);
        virtual ~_CppCastFromIterator();
    
        std::any current();
        bool moveNext();
};

// Native class: CppUserData
// C++ implementation should be provided externally
class CppUserData;

// Class: CppStringPool
class CppStringPool : public CppAny {
public:
    private:
        DartObject* _instance;
        DartObject* _pool;
    
    public:
        CppStringPool();
        virtual ~CppStringPool();
    
        DartObject* getOrCreateFromCodeUnits(DartObject* codeUnits);
        DartObject* getOrCreateFromUserData(DartObject* userData);
        bool _compareUserData(DartObject* userData, DartObject* codeUnits);
        void clear();
        DartObject* getStats();
        // Static methods
        static DartObject* instance();
};

// Class: CppStringPoolStats
class CppStringPoolStats : public CppAny {
public:
    private:
        int64_t totalStrings;
        int64_t totalMemory;
    
    public:
        CppStringPoolStats();
        virtual ~CppStringPoolStats();
    
        std::string toString();
};

// Class: CppStringBuffer
class CppStringBuffer : public CppAny {
public:
    private:
        DartObject* _parts;
    
    public:
        CppStringBuffer(DartObject* content);
        virtual ~CppStringBuffer();
    
        void write(DartObject* obj);
        void writeAll(DartObject* objects, DartObject* separator);
        void writeCharCode(int64_t charCode);
        void writeln(DartObject* obj);
        void clear();
        DartObject* toCppString();
        int64_t length();
        bool isEmpty();
        bool isNotEmpty();
        // Static methods
        static DartObject* _convertStringToUserData(DartObject* obj);
        static DartObject* _convertStringToCodeUnits(std::string str);
};

// Class: CppString
class CppString : public CppAny {
public:
    private:
        DartObject* Empty;
        DartObject* _codeUnits;
    
    public:
        CppString(DartObject* userData);
        CppString(DartObject* codeUnits);
        CppString(int64_t charCode);
        CppString(DartObject* charCodes, int64_t start, int64_t end);
        virtual ~CppString();
    
        std::string _toExternalString();
        bool _equalCodeUnits(DartObject* other);
        DartObject* __(int64_t index);
        int64_t length();
        bool isEmpty();
        bool isNotEmpty();
        int64_t hashCode();
        bool __(DartObject* other);
        DartObject* _(DartObject* other);
        DartObject* _(int64_t times);
        int64_t codeUnitAt(int64_t index);
        DartObject* codeUnits();
        DartObject* runes();
        int64_t compareTo(DartObject* other);
        bool startsWith(DartObject* pattern, int64_t index);
        bool endsWith(DartObject* other);
        int64_t indexOf(DartObject* pattern, int64_t start);
        int64_t lastIndexOf(DartObject* pattern, int64_t start);
        bool contains(DartObject* other, int64_t startIndex);
        DartObject* substring(int64_t start, int64_t end);
        DartObject* trim();
        DartObject* trimLeft();
        DartObject* trimRight();
        bool _isWhitespace(int64_t codeUnit);
        DartObject* padLeft(int64_t width, DartObject* padding);
        DartObject* padRight(int64_t width, DartObject* padding);
        DartObject* replaceFirst(DartObject* from, DartObject* to, int64_t startIndex);
        DartObject* replaceAll(DartObject* from, DartObject* replace);
        DartObject* replaceRange(int64_t start, int64_t end, DartObject* replacement);
        DartObject* split(DartObject* separator);
        DartObject* toLowerCase();
        DartObject* toUpperCase();
        DartObject* allMatches(DartObject* string, int64_t start);
        DartObject* matchAsPrefix(DartObject* string, int64_t start);
        DartObject* toCppString();
        std::string toStandardString();
        void dispose();
        bool sharesDataWith(DartObject* other);
        int64_t dataHashCode();
        // Static methods
        static DartObject* convertString(DartObject* obj);
        static DartObject* fromString(std::string source);
        static DartObject* join(DartObject* strings, DartObject* separator);
};

// Class: CppStringMatch
class CppStringMatch : public CppAny {
public:
    private:
        int64_t start;
        DartObject* input;
        DartObject* pattern;
    
    public:
        CppStringMatch(int64_t start, DartObject* input, DartObject* pattern);
        virtual ~CppStringMatch();
    
        int64_t end();
        DartObject* group(int64_t group);
        DartObject* __(int64_t group);
        int64_t groupCount();
};

// Class: _CppStringAllMatchesIterable
class _CppStringAllMatchesIterable : public CppAny {
public:
    private:
        DartObject* _input;
        DartObject* _pattern;
        int64_t _index;
    
    public:
        _CppStringAllMatchesIterable(DartObject* _input, DartObject* _pattern, int64_t _index);
        virtual ~_CppStringAllMatchesIterable();
    
        DartObject* iterator();
        int64_t length();
        DartObject* first();
};

// Class: _CppStringAllMatchesIterator
class _CppStringAllMatchesIterator : public CppAny {
public:
    private:
        DartObject* _input;
        DartObject* _pattern;
        int64_t _index;
        DartObject* _current;
    
    public:
        _CppStringAllMatchesIterator(DartObject* _input, DartObject* _pattern, int64_t _index);
        virtual ~_CppStringAllMatchesIterator();
    
        bool moveNext();
        DartObject* current();
};

// Class: CppList
class CppList : public CppAny {
public:
        CppList();
        virtual ~CppList();
    
        int64_t length();
        void length(int64_t newLen);
        std::any __(int64_t index);
        void ___(int64_t index, std::any value);
        void add(std::any value);
        void addAll(DartObject* iterable);
        bool any(std::any test);
        DartObject* asMap();
        DartObject* cast();
        void clear();
        bool contains(DartObject* element);
        std::any elementAt(int64_t index);
        bool every(std::any test);
        void fillRange(int64_t start, int64_t end, std::any fillValue);
        std::any firstWhere(std::any test);
        std::any fold(std::any initialValue, std::any combine);
        void forEach(std::any action);
        DartObject* getRange(int64_t start, int64_t end);
        int64_t indexOf(std::any element, int64_t start);
        int64_t indexWhere(std::any test, int64_t start);
        void insert(int64_t index, std::any element);
        void insertAll(int64_t index, DartObject* iterable);
        std::any first();
        void first(std::any value);
        std::any last();
        void last(std::any value);
        std::any single();
        bool isEmpty();
        bool isNotEmpty();
        DartObject* iterator();
        DartObject* join(DartObject* separator);
        int64_t lastIndexOf(std::any element, int64_t start);
        int64_t lastIndexWhere(std::any test, int64_t start);
        std::any lastWhere(std::any test);
        std::any reduce(std::any combine);
        bool remove(DartObject* value);
        std::any removeAt(int64_t index);
        std::any removeLast();
        void removeRange(int64_t start, int64_t end);
        void removeWhere(std::any test);
        void replaceRange(int64_t start, int64_t end, DartObject* replacements);
        void retainWhere(std::any test);
        void setAll(int64_t index, DartObject* iterable);
        void setRange(int64_t start, int64_t end, DartObject* iterable, int64_t skipCount);
        void shuffle(DartObject* random);
        void sort(std::any compare);
        DartObject* sublist(int64_t start, int64_t end);
        DartObject* toList();
        DartObject* toSet();
        std::any singleWhere(std::any test);
        DartObject* _(DartObject* other);
        DartObject* toCppString();
        // Static methods
        static DartObject* empty();
        static DartObject* filled(int64_t length, std::any fill);
        static DartObject* from(DartObject* elements);
        static DartObject* of(DartObject* elements);
        static DartObject* generate(int64_t length, std::any generator);
        static DartObject* unmodifiable(DartObject* elements);
        static DartObject* castFrom(DartObject* source);
        static DartObject* castFromWithFactory(DartObject* source, std::any newList);
};

// Class: CppArrayList
class CppArrayList : public CppAny {
public:
    private:
        int64_t _length;
        DartObject* _array;
    
    public:
        CppArrayList(DartObject* array);
        CppArrayList(int64_t length, int64_t capacity);
        virtual ~CppArrayList();
    
        int64_t length();
        void ensureCapacity(int64_t newLen);
        void length(int64_t newLen);
        std::any __(int64_t index);
        void ___(int64_t index, std::any value);
        void add(std::any value);
        void addAll(DartObject* iterable);
        bool any(std::any test);
        DartObject* asMap();
        DartObject* cast();
        void clear();
        bool contains(DartObject* element);
        std::any elementAt(int64_t index);
        bool every(std::any test);
        void fillRange(int64_t start, int64_t end, std::any fillValue);
        std::any firstWhere(std::any test);
        std::any fold(std::any initialValue, std::any combine);
        void forEach(std::any action);
        DartObject* getRange(int64_t start, int64_t end);
        int64_t indexOf(std::any element, int64_t start);
        int64_t indexWhere(std::any test, int64_t start);
        void insert(int64_t index, std::any element);
        void insertAll(int64_t index, DartObject* iterable);
        std::any first();
        void first(std::any value);
        std::any last();
        void last(std::any value);
        std::any single();
        bool isEmpty();
        bool isNotEmpty();
        DartObject* iterator();
        int64_t lastIndexOf(std::any element, int64_t start);
        int64_t lastIndexWhere(std::any test, int64_t start);
        std::any lastWhere(std::any test);
        std::any reduce(std::any combine);
        bool remove(DartObject* value);
        std::any removeAt(int64_t index);
        std::any removeLast();
        void removeRange(int64_t start, int64_t end);
        void removeWhere(std::any test);
        void replaceRange(int64_t start, int64_t end, DartObject* replacements);
        void retainWhere(std::any test);
        void setAll(int64_t index, DartObject* iterable);
        void setRange(int64_t start, int64_t end, DartObject* iterable, int64_t skipCount);
        void shuffle(DartObject* random);
        void sort(std::any compare);
        void _quickSort(int64_t low, int64_t high, std::any compare);
        int64_t _partition(int64_t low, int64_t high, std::any compare);
        void _swap(int64_t i, int64_t j);
        DartObject* sublist(int64_t start, int64_t end);
        DartObject* toList();
        DartObject* toSet();
        std::any singleWhere(std::any test);
        DartObject* _(DartObject* other);
        DartObject* toCppString();
        // Static methods
        static DartObject* empty();
        static DartObject* filled(int64_t length, std::any fill);
        static DartObject* from(DartObject* elements);
        static DartObject* of(DartObject* elements);
        static DartObject* generate(int64_t length, std::any generator);
        static DartObject* unmodifiable(DartObject* elements);
        static int64_t _getSuggestCapacity(int64_t newLen);
        static DartObject* castFrom(DartObject* source);
        static DartObject* castFromWithFactory(DartObject* source, std::any newList);
};

// Class: _CppListIterator
class _CppListIterator : public CppAny {
public:
    private:
        DartObject* _list;
        int64_t _index;
    
    public:
        _CppListIterator(DartObject* _list);
        virtual ~_CppListIterator();
    
        std::any current();
        bool moveNext();
};

// Class: CppSet
class CppSet : public CppAny {
public:
        CppSet();
        virtual ~CppSet();
    
        bool add(std::any value);
        void addAll(DartObject* elements);
        DartObject* cast();
        void clear();
        bool contains(DartObject* element);
        bool containsAll(DartObject* other);
        DartObject* difference(DartObject* other);
        std::any elementAt(int64_t index);
        DartObject* intersection(DartObject* other);
        std::any first();
        std::any last();
        std::any single();
        bool isEmpty();
        bool isNotEmpty();
        DartObject* iterator();
        int64_t length();
        std::any lookup(DartObject* element);
        bool remove(DartObject* value);
        void removeAll(DartObject* elementsToRemove);
        void removeWhere(std::any test);
        void retainAll(DartObject* elementsToRetain);
        void retainWhere(std::any test);
        DartObject* union_(DartObject* other);
        DartObject* toCppString();
        // Static methods
        static DartObject* identity();
        static DartObject* from(DartObject* elements);
        static DartObject* of(DartObject* elements);
        static DartObject* unmodifiable(DartObject* elements);
        static DartObject* castFrom(DartObject* source);
        static DartObject* castFromWithFactory(DartObject* source, std::any newSet);
};

// Class: CppArraySet
class CppArraySet : public CppAny {
public:
    private:
        DartObject* _list;
    
    public:
        CppArraySet(DartObject* array);
        CppArraySet(int64_t capacity);
        virtual ~CppArraySet();
    
        bool add(std::any value);
        void addAll(DartObject* elements);
        DartObject* cast();
        void clear();
        bool contains(DartObject* element);
        bool containsAll(DartObject* other);
        DartObject* difference(DartObject* other);
        std::any elementAt(int64_t index);
        DartObject* intersection(DartObject* other);
        std::any first();
        std::any last();
        std::any single();
        bool isEmpty();
        bool isNotEmpty();
        DartObject* iterator();
        int64_t length();
        std::any lookup(DartObject* element);
        bool remove(DartObject* value);
        void removeAll(DartObject* elementsToRemove);
        void removeWhere(std::any test);
        void retainAll(DartObject* elementsToRetain);
        void retainWhere(std::any test);
        DartObject* union_(DartObject* other);
        DartObject* toCppString();
        // Static methods
        static DartObject* identity();
        static DartObject* from(DartObject* elements);
        static DartObject* of(DartObject* elements);
        static DartObject* unmodifiable(DartObject* elements);
        static DartObject* castFrom(DartObject* source);
        static DartObject* castFromWithFactory(DartObject* source, std::any newSet);
};

// Class: CppMapEntry
class CppMapEntry : public CppAny {
public:
    private:
        std::any key;
        std::any value;
    
    public:
        CppMapEntry(std::any key, std::any value);
        virtual ~CppMapEntry();
    
};

// Class: CppMap
class CppMap : public CppAny {
public:
        CppMap();
        virtual ~CppMap();
    
        std::any __(DartObject* key);
        void ___(std::any key, std::any value);
        void addAll(DartObject* other);
        void addEntries(DartObject* entries);
        DartObject* cast();
        void clear();
        bool containsKey(DartObject* key);
        bool containsValue(DartObject* value);
        DartObject* entries();
        void forEach(std::any action);
        bool isEmpty();
        bool isNotEmpty();
        DartObject* keys();
        int64_t length();
        std::any putIfAbsent(std::any key, std::any ifAbsent);
        std::any remove(DartObject* key);
        void removeWhere(std::any test);
        std::any update(std::any key, std::any update);
        void updateAll(std::any update);
        DartObject* values();
        DartObject* map(std::any transform);
        DartObject* toCppString();
        // Static methods
        static DartObject* identity();
        static DartObject* from(DartObject* other);
        static DartObject* of(DartObject* other);
        static DartObject* unmodifiable(DartObject* other);
        static DartObject* fromIterable(DartObject* iterable);
        static DartObject* fromIterables(DartObject* keys, DartObject* values);
        static DartObject* fromEntries(DartObject* entries);
        static DartObject* castFrom(DartObject* source);
        static DartObject* castFromWithFactory(DartObject* source, std::any newMap);
};

// Class: CppArrayMap
class CppArrayMap : public CppAny {
public:
    private:
        DartObject* _list;
    
    public:
        CppArrayMap(DartObject* array);
        CppArrayMap(int64_t capacity);
        virtual ~CppArrayMap();
    
        std::any __(DartObject* key);
        void ___(std::any key, std::any value);
        void addAll(DartObject* other);
        void addEntries(DartObject* entries);
        DartObject* cast();
        void clear();
        bool containsKey(DartObject* key);
        bool containsValue(DartObject* value);
        DartObject* entries();
        void forEach(std::any action);
        bool isEmpty();
        bool isNotEmpty();
        DartObject* keys();
        int64_t length();
        std::any putIfAbsent(std::any key, std::any ifAbsent);
        std::any remove(DartObject* key);
        void removeWhere(std::any test);
        std::any update(std::any key, std::any update);
        void updateAll(std::any update);
        DartObject* values();
        DartObject* map(std::any transform);
        DartObject* toCppString();
        // Static methods
        static DartObject* identity();
        static DartObject* from(DartObject* other);
        static DartObject* of(DartObject* other);
        static DartObject* unmodifiable(DartObject* other);
        static DartObject* fromIterable(DartObject* iterable);
        static DartObject* fromIterables(DartObject* keys, DartObject* values);
        static DartObject* fromEntries(DartObject* entries);
        static DartObject* castFrom(DartObject* source);
        static DartObject* castFromWithFactory(DartObject* source, std::any newMap);
};

// Class: CppStackTrace
class CppStackTrace : public CppAny {
public:
    private:
        DartObject* _current;
    
    public:
        CppStackTrace();
        virtual ~CppStackTrace();
    
        DartObject* toCppString();
        // Static methods
        static DartObject* current();
};

// Class: CppError
class CppError : public CppAny {
public:
        CppError();
        virtual ~CppError();
    
        DartObject* stackTrace();
};

// Class: CppStateError
class CppStateError : public CppAny {
public:
    private:
        DartObject* message;
    
    public:
        CppStateError(DartObject* message);
        virtual ~CppStateError();
    
};

// Class: CppRangeError
class CppRangeError : public CppAny {
public:
    private:
        DartObject* start;
        DartObject* end;
        DartObject* invalidValue;
        DartObject* name;
        DartObject* message;
    
    public:
        CppRangeError(DartObject* message);
        CppRangeError(DartObject* invalidValue, DartObject* name, DartObject* message);
        CppRangeError(DartObject* invalidValue, int64_t minValue, int64_t maxValue, DartObject* name, DartObject* message);
        virtual ~CppRangeError();
    
};

// Class: CppIndexError
class CppIndexError : public CppAny {
public:
    private:
        DartObject* indexable;
        int64_t length;
        int64_t invalidValue;
        DartObject* name;
        DartObject* message;
    
    public:
        CppIndexError(int64_t invalidValue, DartObject* indexable, DartObject* name, DartObject* message, int64_t length);
        CppIndexError(int64_t invalidValue, int64_t length);
        virtual ~CppIndexError();
    
};

// Class: BoxInt
class BoxInt : public CppAny {
public:
    private:
        int64_t value;
    
    public:
        BoxInt(int64_t value);
        virtual ~BoxInt();
    
        int64_t unbox();
};

// Class: BoxDouble
class BoxDouble : public CppAny {
public:
    private:
        double value;
    
    public:
        BoxDouble(double value);
        virtual ~BoxDouble();
    
        double unbox();
};

// Class: BoxBool
class BoxBool : public CppAny {
public:
    private:
        bool value;
    
    public:
        BoxBool(bool value);
        virtual ~BoxBool();
    
        bool unbox();
};

// Class: BoxString
class BoxString : public CppAny {
public:
    private:
        std::string value;
    
    public:
        BoxString(std::string value);
        virtual ~BoxString();
    
        std::string unbox();
};

// Global functions
void main();
void testCollectionMethods();
std::any testDynamic(int64_t aaa);
void testIterableMethods();
DartObject* native_cppCreatePointerArray(int64_t length);
int64_t native_cppGetPointerArrayLength(DartObject* array);
DartObject* native_cppGetPointerArrayItem(DartObject* array, int64_t index);
void native_cppSetPointerArrayItem(DartObject* array, int64_t index, DartObject* value);
void native_print(DartObject* object);
DartObject* native_getCurrentStackTrace();
DartObject* native_cppToString(DartObject* object);
DartObject* native_cppArrayConst(int64_t length, DartObject* v1, DartObject* v2, DartObject* v3, DartObject* v4, DartObject* v5, DartObject* v6, DartObject* v7, DartObject* v8, DartObject* v9, DartObject* v10);
DartObject* native_cppCharCodes(DartObject* value);
DartObject* native_cppCreateAsyncTask();
DartObject* native_cppAwaitAsyncTask(DartObject* taskData);
DartObject* native_cppGetAsyncTaskResult(DartObject* taskData);
DartObject* native_cppBox(DartObject* value);
std::any native_cppUnbox(DartObject* value);
DartObject* ObjectExt_toCppString(DartObject* _this);
std::any ObjectExt_get_toCppString(DartObject* _this);
// Global unboxing methods
int64_t asInt(std::any value);
double asDouble(std::any value);
bool asBool(std::any value);
std::string asString(std::any value);

} // namespace dart_cpp

// Generated C++ implementation
namespace dart_cpp {

// Implementation of class: CppAny
CppAny() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppAny::~CppAny() {
    // Destructor
}

DartObject* CppAny::toCppString() {
    {
        return /* TODO: Unsupported expression type: ConstantExpression */;
    }
}


// Implementation of class: CppIterator
CppIterator() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppIterator::~CppIterator() {
    // Destructor
}

std::any CppIterator::current() {
    // TODO: Implement method body
    return nullptr;
}

bool CppIterator::moveNext() {
    // TODO: Implement method body
    return false;
}


// Implementation of class: CppIterable
CppIterable() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppIterable::~CppIterable() {
    // Destructor
}

DartObject* CppIterable::iterator() {
    // TODO: Implement method body
    return nullptr;
}

int64_t CppIterable::length() {
    // TODO: Implement method body
    return 0;
}

bool CppIterable::isEmpty() {
    return /* TODO: Unsupported expression type: EqualsCall */;
}

bool CppIterable::isNotEmpty() {
    return (this.length > 0LL);
}

std::any CppIterable::first() {
    {
        if (this.isEmpty) {
            throw std::make_shared<CppStateError>("No element");
        }
        CppIterator it = this.iterator;
        if (!(it.moveNext())) {
            throw std::make_shared<CppStateError>("No element");
        }
        return it.current;
    }
}

std::any CppIterable::last() {
    {
        if (this.isEmpty) {
            throw std::make_shared<CppStateError>("No element");
        }
        CppIterator it = this.iterator;
        E result = nullptr;
        while (it.moveNext()) {
            {
                result = it.current;
            }
        }
        return /* TODO: Unsupported expression type: Let */;
    }
}

std::any CppIterable::single() {
    {
        if (this.isEmpty) {
            throw std::make_shared<CppStateError>("No element");
        }
        CppIterator it = this.iterator;
        it.moveNext();
        E result = it.current;
        if (it.moveNext()) {
            throw std::make_shared<CppStateError>("Too many elements");
        }
        return result;
    }
}

std::any CppIterable::elementAt(int64_t index) {
    {
        if ((index < 0LL)) {
            throw std::make_shared<ArgumentError>("Index cannot be negative");
        }
        CppIterator it = this.iterator;
        for (int64_t i = 0LL; (i <= index); i = (i + 1LL)) {
    if (!(it.moveNext())) throw std::make_shared<CppIndexError>(index, this);
    if (/* TODO: Unsupported expression type: EqualsCall */) return it.current;
}
        throw std::make_shared<CppIndexError>(index, this);
    }
}

bool CppIterable::contains(DartObject* element) {
    {
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                if (/* TODO: Unsupported expression type: EqualsCall */) {
                    return true;
                }
            }
        }
        return false;
    }
}

void CppIterable::forEach(std::any action) {
    {
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                /* TODO: Unsupported expression type: FunctionInvocation */;
            }
        }
    }
}

DartObject* CppIterable::map(std::any toElement) {
    {
        return std::make_shared<CppMappedIterable<E, T>>(this, toElement);
    }
}

DartObject* CppIterable::where(std::any test) {
    {
        return std::make_shared<CppWhereIterable<E>>(this, test);
    }
}

DartObject* CppIterable::whereType() {
    {
        return std::make_shared<CppWhereTypeIterable<T>>(this);
    }
}

DartObject* CppIterable::expand(std::any toElements) {
    {
        return std::make_shared<CppExpandIterable<E, T>>(this, toElements);
    }
}

bool CppIterable::any(std::any test) {
    {
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                if (/* TODO: Unsupported expression type: FunctionInvocation */) {
                    return true;
                }
            }
        }
        return false;
    }
}

bool CppIterable::every(std::any test) {
    {
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                if (!(/* TODO: Unsupported expression type: FunctionInvocation */)) {
                    return false;
                }
            }
        }
        return true;
    }
}

std::any CppIterable::firstWhere(std::any test) {
    {
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                if (/* TODO: Unsupported expression type: FunctionInvocation */) {
                    return it.current;
                }
            }
        }
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            return /* TODO: Unsupported expression type: FunctionInvocation */;
        }
        throw std::make_shared<CppStateError>("No element");
    }
}

std::any CppIterable::lastWhere(std::any test) {
    {
        CppIterator it = this.iterator;
        E result = nullptr;
        bool found = false;
        while (it.moveNext()) {
            {
                if (/* TODO: Unsupported expression type: FunctionInvocation */) {
                    {
                        result = it.current;
                        found = true;
                    }
                }
            }
        }
        if (found) {
            return /* TODO: Unsupported expression type: Let */;
        }
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            return /* TODO: Unsupported expression type: FunctionInvocation */;
        }
        throw std::make_shared<CppStateError>("No element");
    }
}

std::any CppIterable::singleWhere(std::any test) {
    {
        CppIterator it = this.iterator;
        E result = nullptr;
        bool found = false;
        while (it.moveNext()) {
            {
                if (/* TODO: Unsupported expression type: FunctionInvocation */) {
                    {
                        if (found) {
                            throw std::make_shared<CppStateError>("Too many elements");
                        }
                        result = it.current;
                        found = true;
                    }
                }
            }
        }
        if (found) {
            return /* TODO: Unsupported expression type: Let */;
        }
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            return /* TODO: Unsupported expression type: FunctionInvocation */;
        }
        throw std::make_shared<CppStateError>("No element");
    }
}

std::any CppIterable::reduce(std::any combine) {
    {
        CppIterator it = this.iterator;
        if (!(it.moveNext())) {
            throw std::make_shared<CppStateError>("No element");
        }
        E value = it.current;
        while (it.moveNext()) {
            {
                value = /* TODO: Unsupported expression type: FunctionInvocation */;
            }
        }
        return value;
    }
}

std::any CppIterable::fold(std::any initialValue, std::any combine) {
    {
        T value = initialValue;
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                value = /* TODO: Unsupported expression type: FunctionInvocation */;
            }
        }
        return value;
    }
}

DartObject* CppIterable::join(DartObject* separator) {
    {
        CppIterator it = this.iterator;
        if (!(it.moveNext())) {
            return /* TODO: Unsupported expression type: ConstantExpression */;
        }
        CppStringBuffer buffer = std::make_shared<CppStringBuffer>((it.current).toString());
        while (it.moveNext()) {
            {
                buffer.write(separator);
                buffer.write((it.current).toString());
            }
        }
        return buffer.toCppString();
    }
}

DartObject* CppIterable::take(int64_t count) {
    {
        return std::make_shared<CppTakeIterable<E>>(this, count);
    }
}

DartObject* CppIterable::takeWhile(std::any test) {
    {
        return std::make_shared<CppTakeWhileIterable<E>>(this, test);
    }
}

DartObject* CppIterable::skip(int64_t count) {
    {
        return std::make_shared<CppSkipIterable<E>>(this, count);
    }
}

DartObject* CppIterable::skipWhile(std::any test) {
    {
        return std::make_shared<CppSkipWhileIterable<E>>(this, test);
    }
}

DartObject* CppIterable::reversed() {
    {
        return std::make_shared<CppReversedIterable<E>>(this);
    }
}

DartObject* CppIterable::followedBy(DartObject* other) {
    {
        return std::make_shared<CppFollowedByIterable<E>>(this, other);
    }
}

DartObject* CppIterable::toList() {
    {
        return CppList<E>_from(this, /* growable: */ growable);
    }
}

DartObject* CppIterable::toSet() {
    {
        return CppSet<E>_from(this);
    }
}

DartObject* CppIterable::cast() {
    {
        return std::make_shared<CppCastIterable<E, T>>(this);
    }
}

static DartObject* CppIterable::empty() {
    return std::make_shared<_CppEmptyIterable<E>>();
}

static DartObject* CppIterable::generate(int64_t count, std::any generator) {
    {
        return std::make_shared<_CppGenerateIterable<E>>(count, generator);
    }
}

static DartObject* CppIterable::unmodifiable(DartObject* elements) {
    {
        return std::make_shared<_CppUnmodifiableIterable<E>>(elements.toList());
    }
}

static DartObject* CppIterable::castFrom(DartObject* source) {
    {
        return std::make_shared<_CppCastFromIterable<S, R>>(source);
    }
}


// Implementation of class: CppMappedIterable
CppMappedIterable(DartObject* _source, std::any _f) : _source(_source), _f(_f) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppMappedIterable::~CppMappedIterable() {
    // Destructor
}

DartObject* CppMappedIterable::iterator() {
    return std::make_shared<CppMappedIterator<S, T>>(this._source.iterator, this._f);
}

int64_t CppMappedIterable::length() {
    return this._source.length;
}


// Implementation of class: CppMappedIterator
CppMappedIterator(DartObject* _iterator, std::any _f) : _iterator(_iterator), _f(_f) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppMappedIterator::~CppMappedIterator() {
    // Destructor
}

std::any CppMappedIterator::current() {
    return /* TODO: Unsupported expression type: Let */;
}

bool CppMappedIterator::moveNext() {
    {
        if (this._iterator.moveNext()) {
            {
                /* TODO: Unsupported expression type: InstanceSet */;
                return true;
            }
        }
        return false;
    }
}


// Implementation of class: CppWhereIterable
CppWhereIterable(DartObject* _source, std::any _test) : _source(_source), _test(_test) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppWhereIterable::~CppWhereIterable() {
    // Destructor
}

DartObject* CppWhereIterable::iterator() {
    return std::make_shared<CppWhereIterator<E>>(this._source.iterator, this._test);
}

int64_t CppWhereIterable::length() {
    {
        int64_t count = 0LL;
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                count = (count + 1LL);
            }
        }
        return count;
    }
}


// Implementation of class: CppWhereIterator
CppWhereIterator(DartObject* _iterator, std::any _test) : _iterator(_iterator), _test(_test) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppWhereIterator::~CppWhereIterator() {
    // Destructor
}

std::any CppWhereIterator::current() {
    return this._iterator.current;
}

bool CppWhereIterator::moveNext() {
    {
        while (this._iterator.moveNext()) {
            {
                if (/* TODO: Unsupported expression type: Let */) {
                    {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}


// Implementation of class: CppWhereTypeIterable
CppWhereTypeIterable(DartObject* _source) : _source(_source) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppWhereTypeIterable::~CppWhereTypeIterable() {
    // Destructor
}

DartObject* CppWhereTypeIterable::iterator() {
    return std::make_shared<CppWhereTypeIterator<T>>(this._source.iterator);
}

int64_t CppWhereTypeIterable::length() {
    {
        int64_t count = 0LL;
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                count = (count + 1LL);
            }
        }
        return count;
    }
}


// Implementation of class: CppWhereTypeIterator
CppWhereTypeIterator(DartObject* _iterator) : _iterator(_iterator) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppWhereTypeIterator::~CppWhereTypeIterator() {
    // Destructor
}

std::any CppWhereTypeIterator::current() {
    return static_cast<T>(this._iterator.current);
}

bool CppWhereTypeIterator::moveNext() {
    {
        while (this._iterator.moveNext()) {
            {
                if (dynamic_cast<T*>(this._iterator.current) != nullptr) {
                    {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}


// Implementation of class: CppExpandIterable
CppExpandIterable(DartObject* _source, std::any _f) : _source(_source), _f(_f) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppExpandIterable::~CppExpandIterable() {
    // Destructor
}

DartObject* CppExpandIterable::iterator() {
    return std::make_shared<CppExpandIterator<S, T>>(this._source.iterator, this._f);
}

int64_t CppExpandIterable::length() {
    {
        int64_t count = 0LL;
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                count = (count + 1LL);
            }
        }
        return count;
    }
}


// Implementation of class: CppExpandIterator
CppExpandIterator(DartObject* _iterator, std::any _f) : _iterator(_iterator), _f(_f) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppExpandIterator::~CppExpandIterator() {
    // Destructor
}

std::any CppExpandIterator::current() {
    return /* TODO: Unsupported expression type: NullCheck */.current;
}

bool CppExpandIterator::moveNext() {
    {
        while (true) {
            {
                if ((!(/* TODO: Unsupported expression type: EqualsNull */) && /* TODO: Unsupported expression type: NullCheck */.moveNext())) {
                    {
                        return true;
                    }
                }
                if (!(this._iterator.moveNext())) {
                    {
                        return false;
                    }
                }
                /* TODO: Unsupported expression type: InstanceSet */;
            }
        }
    }
}


// Implementation of class: CppTakeIterable
CppTakeIterable(DartObject* _source, int64_t _count) : _source(_source), _count(_count) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppTakeIterable::~CppTakeIterable() {
    // Destructor
}

DartObject* CppTakeIterable::iterator() {
    return std::make_shared<CppTakeIterator<E>>(this._source.iterator, this._count);
}

int64_t CppTakeIterable::length() {
    return min(this._count, this._source.length);
}


// Implementation of class: CppTakeIterator
CppTakeIterator(DartObject* _iterator, int64_t _count) : _iterator(_iterator), _count(_count) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppTakeIterator::~CppTakeIterator() {
    // Destructor
}

std::any CppTakeIterator::current() {
    return this._iterator.current;
}

bool CppTakeIterator::moveNext() {
    {
        if ((this._remaining <= 0LL)) {
            return false;
        }
        if (this._iterator.moveNext()) {
            {
                /* TODO: Unsupported expression type: InstanceSet */;
                return true;
            }
        }
        return false;
    }
}


// Implementation of class: CppTakeWhileIterable
CppTakeWhileIterable(DartObject* _source, std::any _test) : _source(_source), _test(_test) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppTakeWhileIterable::~CppTakeWhileIterable() {
    // Destructor
}

DartObject* CppTakeWhileIterable::iterator() {
    return std::make_shared<CppTakeWhileIterator<E>>(this._source.iterator, this._test);
}

int64_t CppTakeWhileIterable::length() {
    {
        int64_t count = 0LL;
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                count = (count + 1LL);
            }
        }
        return count;
    }
}


// Implementation of class: CppTakeWhileIterator
CppTakeWhileIterator(DartObject* _iterator, std::any _test) : _iterator(_iterator), _test(_test) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppTakeWhileIterator::~CppTakeWhileIterator() {
    // Destructor
}

std::any CppTakeWhileIterator::current() {
    return this._iterator.current;
}

bool CppTakeWhileIterator::moveNext() {
    {
        if (this._finished) {
            return false;
        }
        if (this._iterator.moveNext()) {
            {
                if (/* TODO: Unsupported expression type: Let */) {
                    {
                        return true;
                    }
                }
                /* TODO: Unsupported expression type: InstanceSet */;
            }
        }
        return false;
    }
}


// Implementation of class: CppSkipIterable
CppSkipIterable(DartObject* _source, int64_t _count) : _source(_source), _count(_count) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppSkipIterable::~CppSkipIterable() {
    // Destructor
}

DartObject* CppSkipIterable::iterator() {
    return std::make_shared<CppSkipIterator<E>>(this._source.iterator, this._count);
}

int64_t CppSkipIterable::length() {
    return max(0LL, (this._source.length - this._count));
}


// Implementation of class: CppSkipIterator
CppSkipIterator(DartObject* _iterator, int64_t _count) : _iterator(_iterator), _count(_count) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppSkipIterator::~CppSkipIterator() {
    // Destructor
}

std::any CppSkipIterator::current() {
    return this._iterator.current;
}

bool CppSkipIterator::moveNext() {
    {
        if (!(this._skipped)) {
            {
                for (int64_t i = 0LL; (i < this._count); i = (i + 1LL)) {
    if (!(this._iterator.moveNext())) return false;
}
                /* TODO: Unsupported expression type: InstanceSet */;
            }
        }
        return this._iterator.moveNext();
    }
}


// Implementation of class: CppSkipWhileIterable
CppSkipWhileIterable(DartObject* _source, std::any _test) : _source(_source), _test(_test) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppSkipWhileIterable::~CppSkipWhileIterable() {
    // Destructor
}

DartObject* CppSkipWhileIterable::iterator() {
    return std::make_shared<CppSkipWhileIterator<E>>(this._source.iterator, this._test);
}

int64_t CppSkipWhileIterable::length() {
    {
        int64_t count = 0LL;
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                count = (count + 1LL);
            }
        }
        return count;
    }
}


// Implementation of class: CppSkipWhileIterator
CppSkipWhileIterator(DartObject* _iterator, std::any _test) : _iterator(_iterator), _test(_test) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppSkipWhileIterator::~CppSkipWhileIterator() {
    // Destructor
}

std::any CppSkipWhileIterator::current() {
    return this._iterator.current;
}

bool CppSkipWhileIterator::moveNext() {
    {
        if (!(this._skipped)) {
            {
                while (this._iterator.moveNext()) {
                    {
                        if (!(/* TODO: Unsupported expression type: Let */)) {
                            {
                                /* TODO: Unsupported expression type: InstanceSet */;
                                return true;
                            }
                        }
                    }
                }
                return false;
            }
        }
        return this._iterator.moveNext();
    }
}


// Implementation of class: CppReversedIterable
CppReversedIterable(DartObject* _source) : _source(_source) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppReversedIterable::~CppReversedIterable() {
    // Destructor
}

DartObject* CppReversedIterable::iterator() {
    return std::make_shared<CppReversedIterator<E>>(this._source);
}

int64_t CppReversedIterable::length() {
    return this._source.length;
}


// Implementation of class: CppReversedIterator
CppReversedIterator(DartObject* source) : source(source) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppReversedIterator::~CppReversedIterator() {
    // Destructor
}

std::any CppReversedIterator::current() {
    return this._elements[this._index];
}

bool CppReversedIterator::moveNext() {
    {
        if ((this._index > 0LL)) {
            {
                /* TODO: Unsupported expression type: InstanceSet */;
                return true;
            }
        }
        return false;
    }
}


// Implementation of class: CppFollowedByIterable
CppFollowedByIterable(DartObject* _first, DartObject* _second) : _first(_first), _second(_second) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppFollowedByIterable::~CppFollowedByIterable() {
    // Destructor
}

DartObject* CppFollowedByIterable::iterator() {
    return std::make_shared<CppFollowedByIterator<E>>(this._first.iterator, this._second.iterator);
}

int64_t CppFollowedByIterable::length() {
    return (this._first.length + this._second.length);
}


// Implementation of class: CppFollowedByIterator
CppFollowedByIterator(DartObject* _first, DartObject* _second) : _first(_first), _second(_second) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppFollowedByIterator::~CppFollowedByIterator() {
    // Destructor
}

std::any CppFollowedByIterator::current() {
    return (this._usingFirst ? this._first.current : this._second.current);
}

bool CppFollowedByIterator::moveNext() {
    {
        if (this._usingFirst) {
            {
                if (this._first.moveNext()) {
                    {
                        return true;
                    }
                }
                /* TODO: Unsupported expression type: InstanceSet */;
            }
        }
        return this._second.moveNext();
    }
}


// Implementation of class: CppCastIterable
CppCastIterable(DartObject* _source) : _source(_source) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppCastIterable::~CppCastIterable() {
    // Destructor
}

DartObject* CppCastIterable::iterator() {
    return std::make_shared<CppCastIterator<S, T>>(this._source.iterator);
}

int64_t CppCastIterable::length() {
    return this._source.length;
}


// Implementation of class: CppCastIterator
CppCastIterator(DartObject* _iterator) : _iterator(_iterator) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppCastIterator::~CppCastIterator() {
    // Destructor
}

std::any CppCastIterator::current() {
    return static_cast<T>(this._iterator.current);
}

bool CppCastIterator::moveNext() {
    return this._iterator.moveNext();
}


// Implementation of class: _CppEmptyIterable
_CppEmptyIterable() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppEmptyIterable::~_CppEmptyIterable() {
    // Destructor
}

DartObject* _CppEmptyIterable::iterator() {
    return std::make_shared<_CppEmptyIterator<E>>();
}

int64_t _CppEmptyIterable::length() {
    return 0LL;
}


// Implementation of class: _CppEmptyIterator
_CppEmptyIterator() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppEmptyIterator::~_CppEmptyIterator() {
    // Destructor
}

std::any _CppEmptyIterator::current() {
    return throw std::make_shared<CppStateError>("No element");
}

bool _CppEmptyIterator::moveNext() {
    return false;
}


// Implementation of class: _CppGenerateIterable
_CppGenerateIterable(int64_t _count, std::any _generator) : _count(_count), _generator(_generator) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppGenerateIterable::~_CppGenerateIterable() {
    // Destructor
}

DartObject* _CppGenerateIterable::iterator() {
    return std::make_shared<_CppGenerateIterator<E>>(this._count, this._generator);
}

int64_t _CppGenerateIterable::length() {
    return this._count;
}


// Implementation of class: _CppGenerateIterator
_CppGenerateIterator(int64_t _count, std::any _generator) : _count(_count), _generator(_generator) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppGenerateIterator::~_CppGenerateIterator() {
    // Destructor
}

std::any _CppGenerateIterator::current() {
    return /* TODO: Unsupported expression type: Let */;
}

bool _CppGenerateIterator::moveNext() {
    {
        if ((this._index < this._count)) {
            {
                /* TODO: Unsupported expression type: InstanceSet */;
                return true;
            }
        }
        return false;
    }
}


// Implementation of class: _CppUnmodifiableIterable
_CppUnmodifiableIterable(DartObject* _elements) : _elements(_elements) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppUnmodifiableIterable::~_CppUnmodifiableIterable() {
    // Destructor
}

DartObject* _CppUnmodifiableIterable::iterator() {
    return this._elements.iterator;
}

int64_t _CppUnmodifiableIterable::length() {
    return this._elements.length;
}


// Implementation of class: _CppCastFromIterable
_CppCastFromIterable(DartObject* _source) : _source(_source) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppCastFromIterable::~_CppCastFromIterable() {
    // Destructor
}

DartObject* _CppCastFromIterable::iterator() {
    return std::make_shared<_CppCastFromIterator<S, R>>(this._source.iterator);
}

int64_t _CppCastFromIterable::length() {
    return this._source.length;
}


// Implementation of class: _CppCastFromIterator
_CppCastFromIterator(DartObject* _iterator) : _iterator(_iterator) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppCastFromIterator::~_CppCastFromIterator() {
    // Destructor
}

std::any _CppCastFromIterator::current() {
    return static_cast<R>(this._iterator.current);
}

bool _CppCastFromIterator::moveNext() {
    return this._iterator.moveNext();
}


// Implementation of class: CppStringPool
CppStringPool() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppStringPool::~CppStringPool() {
    // Destructor
}

DartObject* CppStringPool::getOrCreateFromCodeUnits(DartObject* codeUnits) {
    {
        {
            CppIterator _sync_for_iterator = this._pool.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppUserData existing = _sync_for_iterator.current;
    if (this._compareUserData(existing, codeUnits)) {
    return existing;
}
}
        }
        CppUserData userData = native_cppCreatePointerArray(codeUnits.length);
        for (int64_t i = 0LL; (i < codeUnits.length); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(userData, i, codeUnits[i]);
}
        this._pool.add(userData);
        return userData;
    }
}

DartObject* CppStringPool::getOrCreateFromUserData(DartObject* userData) {
    {
        if (this._pool.contains(userData)) {
            {
                return userData;
            }
        }
        this._pool.add(userData);
        return userData;
    }
}

bool CppStringPool::_compareUserData(DartObject* userData, DartObject* codeUnits) {
    {
        int64_t length = native_cppGetPointerArrayLength(userData);
        if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
            return false;
        }
        for (int64_t i = 0LL; (i < length); i = (i + 1LL)) {
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    return false;
}
}
        return true;
    }
}

void CppStringPool::clear() {
    {
        this._pool.clear();
    }
}

DartObject* CppStringPool::getStats() {
    {
        int64_t totalMemory = 0LL;
        {
            CppIterator _sync_for_iterator = this._pool.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppUserData userData = _sync_for_iterator.current;
    totalMemory = (totalMemory + native_cppGetPointerArrayLength(userData));
}
        }
        return std::make_shared<CppStringPoolStats>(/* totalStrings: */ this._pool.length, /* totalMemory: */ totalMemory);
    }
}

static DartObject* CppStringPool::instance() {
    return CppStringPool::_instance;
}


// Implementation of class: CppStringPoolStats
CppStringPoolStats() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppStringPoolStats::~CppStringPoolStats() {
    // Destructor
}

std::string CppStringPoolStats::toString() {
    {
        return /* TODO: Unsupported expression type: StringConcatenation */;
    }
}


// Implementation of class: CppStringBuffer
CppStringBuffer(DartObject* content) : content(content) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppStringBuffer::~CppStringBuffer() {
    // Destructor
}

void CppStringBuffer::write(DartObject* obj) {
    {
        if (/* TODO: Unsupported expression type: EqualsNull */) {
            return;
        }
        this._parts.add(CppStringBuffer::_convertStringToUserData(obj));
    }
}

void CppStringBuffer::writeAll(DartObject* objects, DartObject* separator) {
    {
        CppIterator iterator = objects.iterator;
        if (iterator.moveNext()) {
            {
                this._parts.add(CppStringBuffer::_convertStringToUserData(/* TODO: Unsupported expression type: Let */));
                while (iterator.moveNext()) {
                    {
                        if ((!(/* TODO: Unsupported expression type: EqualsNull */) && separator.isNotEmpty)) {
                            {
                                this._parts.add(separator._codeUnits);
                            }
                        }
                        this._parts.add(CppStringBuffer::_convertStringToUserData(/* TODO: Unsupported expression type: Let */));
                    }
                }
            }
        }
    }
}

void CppStringBuffer::writeCharCode(int64_t charCode) {
    {
        this._parts.add(CppStringBuffer::_convertStringToUserData(std::make_shared<CppString>(charCode)));
    }
}

void CppStringBuffer::writeln(DartObject* obj) {
    {
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            {
                this._parts.add(CppStringBuffer::_convertStringToUserData(obj));
            }
        }
        this._parts.add(CppStringBuffer::_convertStringToUserData(std::make_shared<CppString>(10LL)));
    }
}

void CppStringBuffer::clear() {
    {
        this._parts.clear();
    }
}

DartObject* CppStringBuffer::toCppString() {
    {
        CppList codeUnits = CppList<int64_t>_empty(/* growable: */ true);
        {
            CppIterator _sync_for_iterator = this._parts.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppUserData part = _sync_for_iterator.current;
    int64_t length = native_cppGetPointerArrayLength(part);
    for (int64_t i = 0LL; (i < length); i = (i + 1LL)) {
    codeUnits.add(asInt(native_cppGetPointerArrayItem(part, i)));
}
}
        }
        return std::make_shared<CppString>(codeUnits);
    }
}

int64_t CppStringBuffer::length() {
    {
        int64_t totalLength = 0LL;
        {
            CppIterator _sync_for_iterator = this._parts.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppUserData part = _sync_for_iterator.current;
    totalLength = (totalLength + native_cppGetPointerArrayLength(part));
}
        }
        return totalLength;
    }
}

bool CppStringBuffer::isEmpty() {
    return this._parts.isEmpty;
}

bool CppStringBuffer::isNotEmpty() {
    return this._parts.isNotEmpty;
}

static DartObject* CppStringBuffer::_convertStringToUserData(DartObject* obj) {
    {
        if (dynamic_cast<CppString*>(obj) != nullptr) {
            {
                return obj._codeUnits;
            }
        }
        return CppStringPool::instance.getOrCreateFromCodeUnits(CppStringBuffer::_convertStringToCodeUnits((obj).toString()));
    }
}

static DartObject* CppStringBuffer::_convertStringToCodeUnits(std::string str) {
    {
        CppList codeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < str.length); i = (i + 1LL)) {
    codeUnits.add(str.codeUnitAt(i));
}
        return codeUnits;
    }
}


// Implementation of class: CppString
CppString(DartObject* userData) : userData(userData) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppString(DartObject* codeUnits) : codeUnits(codeUnits) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppString(int64_t charCode) : charCode(charCode) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppString(DartObject* charCodes, int64_t start, int64_t end) : charCodes(charCodes), start(start), end(end) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppString::~CppString() {
    // Destructor
}

std::string CppString::_toExternalString() {
    {
        CppList codeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < this.length); i = (i + 1LL)) {
    codeUnits.add(asInt(native_cppGetPointerArrayItem(this._codeUnits, i)));
}
        return CppString_fromCharCodes(static_cast<CppIterable>(codeUnits));
    }
}

bool CppString::_equalCodeUnits(DartObject* other) {
    {
        int64_t thisLength = this.length;
        int64_t otherLength = other.length;
        if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
            return false;
        }
        for (int64_t i = 0LL; (i < thisLength); i = (i + 1LL)) {
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    return false;
}
}
        return true;
    }
}

DartObject* CppString::__(int64_t index) {
    {
        int64_t thisLength = this.length;
        if (((index < 0LL) || (index >= thisLength))) {
            {
                throw std::make_shared<CppIndexError>(index, this, "index");
            }
        }
        int64_t codeUnit = asInt(native_cppGetPointerArrayItem(this._codeUnits, index));
        return std::make_shared<CppString>(codeUnit);
    }
}

int64_t CppString::length() {
    return native_cppGetPointerArrayLength(this._codeUnits);
}

bool CppString::isEmpty() {
    return /* TODO: Unsupported expression type: EqualsCall */;
}

bool CppString::isNotEmpty() {
    return (this.length > 0LL);
}

int64_t CppString::hashCode() {
    {
        int64_t hash = 0LL;
        for (int64_t i = 0LL; (i < this.length); i = (i + 1LL)) {
    hash = (((hash * 31LL) + asInt(native_cppGetPointerArrayItem(this._codeUnits, i))) & 2147483647LL);
}
        return hash;
    }
}

bool CppString::__(DartObject* other) {
    {
        if (identical(this, other)) {
            return true;
        }
        if (dynamic_cast<CppString*>(other) != nullptr) {
            {
                return this._equalCodeUnits(other);
            }
        }
        return false;
    }
}

DartObject* CppString::_(DartObject* other) {
    {
        int64_t thisLength = this.length;
        int64_t otherLength = other.length;
        CppList newCodeUnits = CppList<int64_t>_empty(/* growable: */ true);
        /* TODO: Unsupported statement type: EmptyStatement */
        for (int64_t i = 0LL; (i < thisLength); i = (i + 1LL)) {
    newCodeUnits.add(asInt(native_cppGetPointerArrayItem(this._codeUnits, i)));
}
        for (int64_t i = 0LL; (i < otherLength); i = (i + 1LL)) {
    newCodeUnits.add(asInt(native_cppGetPointerArrayItem(other._codeUnits, i)));
}
        return std::make_shared<CppString>(newCodeUnits);
    }
}

DartObject* CppString::_(int64_t times) {
    {
        if ((times <= 0LL)) {
            return /* TODO: Unsupported expression type: ConstantExpression */;
        }
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            return this;
        }
        int64_t thisLength = this.length;
        CppList newCodeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t repeat = 0LL; (repeat < times); repeat = (repeat + 1LL)) {
    for (int64_t i = 0LL; (i < thisLength); i = (i + 1LL)) {
    newCodeUnits.add(asInt(native_cppGetPointerArrayItem(this._codeUnits, i)));
}
}
        return std::make_shared<CppString>(newCodeUnits);
    }
}

int64_t CppString::codeUnitAt(int64_t index) {
    {
        if (((index < 0LL) || (index >= this.length))) {
            {
                throw std::make_shared<CppIndexError>(index, this, "index");
            }
        }
        return asInt(native_cppGetPointerArrayItem(this._codeUnits, index));
    }
}

DartObject* CppString::codeUnits() {
    {
        int64_t thisLength = this.length;
        CppList units = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < thisLength); i = (i + 1LL)) {
    units.add(asInt(native_cppGetPointerArrayItem(this._codeUnits, i)));
}
        return units;
    }
}

DartObject* CppString::runes() {
    return this._toExternalString().runes;
}

int64_t CppString::compareTo(DartObject* other) {
    {
        int64_t thisLength = this.length;
        int64_t otherLength = other.length;
        int64_t minLength = ((thisLength < otherLength) ? thisLength : otherLength);
        for (int64_t i = 0LL; (i < minLength); i = (i + 1LL)) {
    int64_t thisCodeUnit = asInt(native_cppGetPointerArrayItem(this._codeUnits, i));
    int64_t otherCodeUnit = asInt(native_cppGetPointerArrayItem(other._codeUnits, i));
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    return (thisCodeUnit - otherCodeUnit);
}
}
        return (thisLength - otherLength);
    }
}

bool CppString::startsWith(DartObject* pattern, int64_t index) {
    {
        if (((index < 0LL) || (index >= this.length))) {
            return false;
        }
        if (((index + pattern.length) > this.length)) {
            return false;
        }
        for (int64_t i = 0LL; (i < pattern.length); i = (i + 1LL)) {
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    return false;
}
}
        return true;
    }
}

bool CppString::endsWith(DartObject* other) {
    {
        if ((other.length > this.length)) {
            return false;
        }
        int64_t startIndex = (this.length - other.length);
        for (int64_t i = 0LL; (i < other.length); i = (i + 1LL)) {
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    return false;
}
}
        return true;
    }
}

int64_t CppString::indexOf(DartObject* pattern, int64_t start) {
    {
        if ((start < 0LL)) {
            start = 0LL;
        }
        if (pattern.isEmpty) {
            return start;
        }
        if (((start + pattern.length) > this.length)) {
            return -1LL;
        }
        for (int64_t i = start; (i <= (this.length - pattern.length)); i = (i + 1LL)) {
    bool match = true;
    /* TODO: Unsupported statement type: LabeledStatement */
    if (match) return i;
}
        return -1LL;
    }
}

int64_t CppString::lastIndexOf(DartObject* pattern, int64_t start) {
    {
        if (pattern.isEmpty) {
            return /* TODO: Unsupported expression type: Let */;
        }
        (/* TODO: Unsupported expression type: EqualsNull */ ? start = this.length : nullptr);
        if ((start < 0LL)) {
            return -1LL;
        }
        if (((start + pattern.length) > this.length)) {
            start = (this.length - pattern.length);
        }
        for (int64_t i = start; (i >= 0LL); i = (i - 1LL)) {
    bool match = true;
    /* TODO: Unsupported statement type: LabeledStatement */
    if (match) return i;
}
        return -1LL;
    }
}

bool CppString::contains(DartObject* other, int64_t startIndex) {
    {
        return !(/* TODO: Unsupported expression type: EqualsCall */);
    }
}

DartObject* CppString::substring(int64_t start, int64_t end) {
    {
        (/* TODO: Unsupported expression type: EqualsNull */ ? end = this.length : nullptr);
        if ((start < 0LL)) {
            start = 0LL;
        }
        if ((end > this.length)) {
            end = this.length;
        }
        if ((start >= end)) {
            return /* TODO: Unsupported expression type: ConstantExpression */;
        }
        int64_t newLength = (end - start);
        CppList newCodeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < newLength); i = (i + 1LL)) {
    int64_t codeUnit = asInt(native_cppGetPointerArrayItem(this._codeUnits, (start + i)));
    newCodeUnits.add(codeUnit);
}
        return std::make_shared<CppString>(newCodeUnits);
    }
}

DartObject* CppString::trim() {
    {
        int64_t start = 0LL;
        int64_t end = this.length;
        while (((start < end) && this._isWhitespace(asInt(native_cppGetPointerArrayItem(this._codeUnits, start))))) {
            {
                start = (start + 1LL);
            }
        }
        while (((end > start) && this._isWhitespace(asInt(native_cppGetPointerArrayItem(this._codeUnits, (end - 1LL)))))) {
            {
                end = (end - 1LL);
            }
        }
        return this.substring(start, end);
    }
}

DartObject* CppString::trimLeft() {
    {
        int64_t start = 0LL;
        while (((start < this.length) && this._isWhitespace(asInt(native_cppGetPointerArrayItem(this._codeUnits, start))))) {
            {
                start = (start + 1LL);
            }
        }
        return this.substring(start);
    }
}

DartObject* CppString::trimRight() {
    {
        int64_t end = this.length;
        while (((end > 0LL) && this._isWhitespace(asInt(native_cppGetPointerArrayItem(this._codeUnits, (end - 1LL)))))) {
            {
                end = (end - 1LL);
            }
        }
        return this.substring(0LL, end);
    }
}

bool CppString::_isWhitespace(int64_t codeUnit) {
    {
        return ((((((/* TODO: Unsupported expression type: EqualsCall */ || /* TODO: Unsupported expression type: EqualsCall */) || /* TODO: Unsupported expression type: EqualsCall */) || /* TODO: Unsupported expression type: EqualsCall */) || /* TODO: Unsupported expression type: EqualsCall */) || /* TODO: Unsupported expression type: EqualsCall */) || /* TODO: Unsupported expression type: EqualsCall */);
    }
}

DartObject* CppString::padLeft(int64_t width, DartObject* padding) {
    {
        if ((width <= this.length)) {
            return this;
        }
        (/* TODO: Unsupported expression type: EqualsNull */ ? padding = std::make_shared<CppString>(32LL) : nullptr);
        int64_t padLength = (width - this.length);
        int64_t padCount = (padLength / padding.length).ceil();
        CppString padString = (padding * padCount);
        CppString actualPad = padString.substring(0LL, padLength);
        return (actualPad + this);
    }
}

DartObject* CppString::padRight(int64_t width, DartObject* padding) {
    {
        if ((width <= this.length)) {
            return this;
        }
        (/* TODO: Unsupported expression type: EqualsNull */ ? padding = std::make_shared<CppString>(32LL) : nullptr);
        int64_t padLength = (width - this.length);
        int64_t padCount = (padLength / padding.length).ceil();
        CppString padString = (padding * padCount);
        CppString actualPad = padString.substring(0LL, padLength);
        return (this + actualPad);
    }
}

DartObject* CppString::replaceFirst(DartObject* from, DartObject* to, int64_t startIndex) {
    {
        int64_t index = this.indexOf(from, startIndex);
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            return this;
        }
        CppString beforePart = this.substring(0LL, index);
        CppString afterPart = this.substring((index + from.length));
        return ((beforePart + to) + afterPart);
    }
}

DartObject* CppString::replaceAll(DartObject* from, DartObject* replace) {
    {
        if (from.isEmpty) {
            return this;
        }
        CppList parts = this.split(from);
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            return this;
        }
        CppList result = CppList<CppString>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < parts.length); i = (i + 1LL)) {
    result.add(parts[i]);
    if ((i < (parts.length - 1LL))) {
    result.add(replace);
}
}
        return CppString::join(static_cast<CppIterable>(result));
    }
}

DartObject* CppString::replaceRange(int64_t start, int64_t end, DartObject* replacement) {
    {
        (/* TODO: Unsupported expression type: EqualsNull */ ? end = this.length : nullptr);
        if ((start < 0LL)) {
            start = 0LL;
        }
        if ((end > this.length)) {
            end = this.length;
        }
        if ((start >= end)) {
            return (this + replacement);
        }
        CppString beforePart = this.substring(0LL, start);
        CppString afterPart = this.substring(end);
        return ((beforePart + replacement) + afterPart);
    }
}

DartObject* CppString::split(DartObject* separator) {
    {
        if (separator.isEmpty) {
            {
                CppList result = CppList<CppString>_empty(/* growable: */ true);
                for (int64_t i = 0LL; (i < this.length); i = (i + 1LL)) {
    result.add(this.substring(i, (i + 1LL)));
}
                return result;
            }
        }
        CppList result = CppList<CppString>_empty(/* growable: */ true);
        int64_t start = 0LL;
        int64_t index = this.indexOf(separator, start);
        while (!(/* TODO: Unsupported expression type: EqualsCall */)) {
            {
                result.add(this.substring(start, index));
                start = (index + separator.length);
                index = this.indexOf(separator, start);
            }
        }
        result.add(this.substring(start));
        return result;
    }
}

DartObject* CppString::toLowerCase() {
    {
        CppList resultCodeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < this.length); i = (i + 1LL)) {
    int64_t codeUnit = asInt(native_cppGetPointerArrayItem(this._codeUnits, i));
    if (((codeUnit >= 65LL) && (codeUnit <= 90LL))) {
    codeUnit = (codeUnit + 32LL);
}
    resultCodeUnits.add(codeUnit);
}
        return std::make_shared<CppString>(resultCodeUnits);
    }
}

DartObject* CppString::toUpperCase() {
    {
        CppList resultCodeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < this.length); i = (i + 1LL)) {
    int64_t codeUnit = asInt(native_cppGetPointerArrayItem(this._codeUnits, i));
    if (((codeUnit >= 97LL) && (codeUnit <= 122LL))) {
    codeUnit = (codeUnit - 32LL);
}
    resultCodeUnits.add(codeUnit);
}
        return std::make_shared<CppString>(resultCodeUnits);
    }
}

DartObject* CppString::allMatches(DartObject* string, int64_t start) {
    {
        if (((start < 0LL) || (start > string.length))) {
            {
                throw std::make_shared<CppRangeError>(start, 0LL, string.length, "start");
            }
        }
        return std::make_shared<_CppStringAllMatchesIterable>(string, this, start);
    }
}

DartObject* CppString::matchAsPrefix(DartObject* string, int64_t start) {
    {
        if (((start < 0LL) || (start > string.length))) {
            {
                throw std::make_shared<CppRangeError>(start, 0LL, string.length);
            }
        }
        if (((start + this.length) > string.length)) {
            return nullptr;
        }
        for (int64_t i = 0LL; (i < this.length); i = (i + 1LL)) {
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    return nullptr;
}
}
        return std::make_shared<CppStringMatch>(start, string, this);
    }
}

DartObject* CppString::toCppString() {
    {
        return this;
    }
}

std::string CppString::toStandardString() {
    {
        return this._toExternalString();
    }
}

void CppString::dispose() {
    {
    }
}

bool CppString::sharesDataWith(DartObject* other) {
    {
        return identical(this._codeUnits, other._codeUnits);
    }
}

int64_t CppString::dataHashCode() {
    return this._codeUnits.hashCode;
}

static DartObject* CppString::convertString(DartObject* obj) {
    {
        if (dynamic_cast<CppString*>(obj) != nullptr) {
            {
                return obj;
            }
        }
        return std::make_shared<CppString>(native_cppToString(obj));
    }
}

static DartObject* CppString::fromString(std::string source) {
    {
        CppList codeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < source.length); i = (i + 1LL)) {
    codeUnits.add(source.codeUnitAt(i));
}
        return std::make_shared<CppString>(codeUnits);
    }
}

static DartObject* CppString::join(DartObject* strings, DartObject* separator) {
    {
        (/* TODO: Unsupported expression type: EqualsNull */ ? separator = /* TODO: Unsupported expression type: ConstantExpression */ : nullptr);
        CppList stringList = strings.toList();
        if (stringList.isEmpty) {
            return /* TODO: Unsupported expression type: ConstantExpression */;
        }
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            return stringList[0LL];
        }
        CppList newCodeUnits = CppList<int64_t>_empty(/* growable: */ true);
        for (int64_t i = 0LL; (i < stringList.length); i = (i + 1LL)) {
    CppString str = stringList[i];
    for (int64_t j = 0LL; (j < str.length); j = (j + 1LL)) {
    newCodeUnits.add(asInt(native_cppGetPointerArrayItem(str._codeUnits, j)));
}
    if ((i < (stringList.length - 1LL))) {
    for (int64_t j = 0LL; (j < separator.length); j = (j + 1LL)) {
    newCodeUnits.add(asInt(native_cppGetPointerArrayItem(separator._codeUnits, j)));
}
}
}
        return std::make_shared<CppString>(newCodeUnits);
    }
}


// Implementation of class: CppStringMatch
CppStringMatch(int64_t start, DartObject* input, DartObject* pattern) : start(start), input(input), pattern(pattern) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppStringMatch::~CppStringMatch() {
    // Destructor
}

int64_t CppStringMatch::end() {
    return (this.start + this.pattern.length);
}

DartObject* CppStringMatch::group(int64_t group) {
    {
        if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
            {
                throw std::make_shared<CppRangeError>(group);
            }
        }
        return this.pattern;
    }
}

DartObject* CppStringMatch::__(int64_t group) {
    return (/* TODO: Unsupported expression type: EqualsCall */ ? this.pattern : throw std::make_shared<CppRangeError>(group));
}

int64_t CppStringMatch::groupCount() {
    return 0LL;
}


// Implementation of class: _CppStringAllMatchesIterable
_CppStringAllMatchesIterable(DartObject* _input, DartObject* _pattern, int64_t _index) : _input(_input), _pattern(_pattern), _index(_index) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppStringAllMatchesIterable::~_CppStringAllMatchesIterable() {
    // Destructor
}

DartObject* _CppStringAllMatchesIterable::iterator() {
    return std::make_shared<_CppStringAllMatchesIterator>(this._input, this._pattern, this._index);
}

int64_t _CppStringAllMatchesIterable::length() {
    {
        int64_t count = 0LL;
        CppIterator it = this.iterator;
        while (it.moveNext()) {
            {
                count = (count + 1LL);
            }
        }
        return count;
    }
}

DartObject* _CppStringAllMatchesIterable::first() {
    {
        int64_t index = this._input.indexOf(this._pattern, this._index);
        if ((index >= 0LL)) {
            {
                return std::make_shared<CppStringMatch>(index, this._input, this._pattern);
            }
        }
        throw std::make_shared<CppStateError>("No element");
    }
}


// Implementation of class: _CppStringAllMatchesIterator
_CppStringAllMatchesIterator(DartObject* _input, DartObject* _pattern, int64_t _index) : _input(_input), _pattern(_pattern), _index(_index) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppStringAllMatchesIterator::~_CppStringAllMatchesIterator() {
    // Destructor
}

bool _CppStringAllMatchesIterator::moveNext() {
    {
        int64_t patternLen = this._pattern.length;
        if (((this._index + patternLen) > this._input.length)) {
            {
                /* TODO: Unsupported expression type: InstanceSet */;
                return false;
            }
        }
        int64_t index = this._input.indexOf(this._pattern, this._index);
        if ((index < 0LL)) {
            {
                /* TODO: Unsupported expression type: InstanceSet */;
                /* TODO: Unsupported expression type: InstanceSet */;
                return false;
            }
        }
        int64_t end = (index + patternLen);
        /* TODO: Unsupported expression type: InstanceSet */;
        /* TODO: Unsupported expression type: InstanceSet */;
        return true;
    }
}

DartObject* _CppStringAllMatchesIterator::current() {
    return /* TODO: Unsupported expression type: Let */;
}


// Implementation of class: CppList
CppList::CppList() {
    // Default constructor
}

CppList::~CppList() {
    // Destructor
}

int64_t CppList::length() {
    // TODO: Implement method body
    return 0;
}

void CppList::length(int64_t newLen) {
    // TODO: Implement method body
}

std::any CppList::__(int64_t index) {
    // TODO: Implement method body
    return nullptr;
}

void CppList::___(int64_t index, std::any value) {
    // TODO: Implement method body
}

void CppList::add(std::any value) {
    // TODO: Implement method body
}

void CppList::addAll(DartObject* iterable) {
    // TODO: Implement method body
}

bool CppList::any(std::any test) {
    // TODO: Implement method body
    return false;
}

DartObject* CppList::asMap() {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppList::cast() {
    // TODO: Implement method body
    return nullptr;
}

void CppList::clear() {
    // TODO: Implement method body
}

bool CppList::contains(DartObject* element) {
    // TODO: Implement method body
    return false;
}

std::any CppList::elementAt(int64_t index) {
    // TODO: Implement method body
    return nullptr;
}

bool CppList::every(std::any test) {
    // TODO: Implement method body
    return false;
}

void CppList::fillRange(int64_t start, int64_t end, std::any fillValue) {
    // TODO: Implement method body
}

std::any CppList::firstWhere(std::any test) {
    // TODO: Implement method body
    return nullptr;
}

std::any CppList::fold(std::any initialValue, std::any combine) {
    // TODO: Implement method body
    return nullptr;
}

void CppList::forEach(std::any action) {
    // TODO: Implement method body
}

DartObject* CppList::getRange(int64_t start, int64_t end) {
    // TODO: Implement method body
    return nullptr;
}

int64_t CppList::indexOf(std::any element, int64_t start) {
    // TODO: Implement method body
    return 0;
}

int64_t CppList::indexWhere(std::any test, int64_t start) {
    // TODO: Implement method body
    return 0;
}

void CppList::insert(int64_t index, std::any element) {
    // TODO: Implement method body
}

void CppList::insertAll(int64_t index, DartObject* iterable) {
    // TODO: Implement method body
}

std::any CppList::first() {
    // TODO: Implement method body
    return nullptr;
}

void CppList::first(std::any value) {
    // TODO: Implement method body
}

std::any CppList::last() {
    // TODO: Implement method body
    return nullptr;
}

void CppList::last(std::any value) {
    // TODO: Implement method body
}

std::any CppList::single() {
    // TODO: Implement method body
    return nullptr;
}

bool CppList::isEmpty() {
    // TODO: Implement method body
    return false;
}

bool CppList::isNotEmpty() {
    // TODO: Implement method body
    return false;
}

DartObject* CppList::iterator() {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppList::join(DartObject* separator) {
    // TODO: Implement method body
    return nullptr;
}

int64_t CppList::lastIndexOf(std::any element, int64_t start) {
    // TODO: Implement method body
    return 0;
}

int64_t CppList::lastIndexWhere(std::any test, int64_t start) {
    // TODO: Implement method body
    return 0;
}

std::any CppList::lastWhere(std::any test) {
    // TODO: Implement method body
    return nullptr;
}

std::any CppList::reduce(std::any combine) {
    // TODO: Implement method body
    return nullptr;
}

bool CppList::remove(DartObject* value) {
    // TODO: Implement method body
    return false;
}

std::any CppList::removeAt(int64_t index) {
    // TODO: Implement method body
    return nullptr;
}

std::any CppList::removeLast() {
    // TODO: Implement method body
    return nullptr;
}

void CppList::removeRange(int64_t start, int64_t end) {
    // TODO: Implement method body
}

void CppList::removeWhere(std::any test) {
    // TODO: Implement method body
}

void CppList::replaceRange(int64_t start, int64_t end, DartObject* replacements) {
    // TODO: Implement method body
}

void CppList::retainWhere(std::any test) {
    // TODO: Implement method body
}

void CppList::setAll(int64_t index, DartObject* iterable) {
    // TODO: Implement method body
}

void CppList::setRange(int64_t start, int64_t end, DartObject* iterable, int64_t skipCount) {
    // TODO: Implement method body
}

void CppList::shuffle(DartObject* random) {
    // TODO: Implement method body
}

void CppList::sort(std::any compare) {
    // TODO: Implement method body
}

DartObject* CppList::sublist(int64_t start, int64_t end) {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppList::toList() {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppList::toSet() {
    // TODO: Implement method body
    return nullptr;
}

std::any CppList::singleWhere(std::any test) {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppList::_(DartObject* other) {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppList::toCppString() {
    // TODO: Implement method body
    return nullptr;
}

static DartObject* CppList::empty() {
    {
        return CppArrayList<E>_empty(/* growable: */ growable);
    }
}

static DartObject* CppList::filled(int64_t length, std::any fill) {
    {
        return CppArrayList<E>_filled(length, fill, /* growable: */ growable);
    }
}

static DartObject* CppList::from(DartObject* elements) {
    {
        return CppArrayList<E>_from(elements, /* growable: */ growable);
    }
}

static DartObject* CppList::of(DartObject* elements) {
    {
        return CppArrayList<E>_of(elements, /* growable: */ growable);
    }
}

static DartObject* CppList::generate(int64_t length, std::any generator) {
    {
        return CppArrayList<E>_generate(length, generator, /* growable: */ growable);
    }
}

static DartObject* CppList::unmodifiable(DartObject* elements) {
    {
        return CppArrayList<E>_unmodifiable(elements);
    }
}

static DartObject* CppList::castFrom(DartObject* source) {
    {
        return CppArrayList::castFrom(source);
    }
}

static DartObject* CppList::castFromWithFactory(DartObject* source, std::any newList) {
    {
        return CppArrayList::castFromWithFactory(source, newList);
    }
}


// Implementation of class: CppArrayList
CppArrayList(DartObject* array) : array(array) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppArrayList(int64_t length, int64_t capacity) : length(length), capacity(capacity) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppArrayList::~CppArrayList() {
    // Destructor
}

int64_t CppArrayList::length() {
    return this._length;
}

void CppArrayList::ensureCapacity(int64_t newLen) {
    {
        if ((newLen > native_cppGetPointerArrayLength(this._array))) {
            {
                CppUserData newArray = native_cppCreatePointerArray(CppArrayList::_getSuggestCapacity(newLen));
                for (int64_t i = 0LL; (i < native_cppGetPointerArrayLength(this._array)); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(newArray, i, native_cppGetPointerArrayItem(this._array, i));
}
                /* TODO: Unsupported expression type: InstanceSet */;
            }
        }
    }
}

void CppArrayList::length(int64_t newLen) {
    {
        this.ensureCapacity(newLen);
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

std::any CppArrayList::__(int64_t index) {
    return native_cppUnbox(native_cppGetPointerArrayItem(this._array, index));
}

void CppArrayList::___(int64_t index, std::any value) {
    return native_cppSetPointerArrayItem(this._array, index, native_cppBox(value));
}

void CppArrayList::add(std::any value) {
    {
        this.ensureCapacity((this._length + 1LL));
        native_cppSetPointerArrayItem(this._array, /* TODO: Unsupported expression type: Let */, native_cppBox(value));
    }
}

void CppArrayList::addAll(DartObject* iterable) {
    {
        {
            CppIterator _sync_for_iterator = iterable.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    this.add(_sync_for_iterator.current);
}
        }
    }
}

bool CppArrayList::any(std::any test) {
    {
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: FunctionInvocation */) return true;
}
        return false;
    }
}

DartObject* CppArrayList::asMap() {
    {
        CppArrayMap map = std::make_shared<CppArrayMap<int64_t, E>>();
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    map[i] = native_cppUnbox(native_cppGetPointerArrayItem(this._array, i));
}
        return map;
    }
}

DartObject* CppArrayList::cast() {
    {
        return static_cast<CppIterable>(CppArrayList::castFrom(this));
    }
}

void CppArrayList::clear() {
    {
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

bool CppArrayList::contains(DartObject* element) {
    {
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) return true;
}
        return false;
    }
}

std::any CppArrayList::elementAt(int64_t index) {
    return native_cppUnbox(native_cppGetPointerArrayItem(this._array, index));
}

bool CppArrayList::every(std::any test) {
    {
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    if (!(/* TODO: Unsupported expression type: FunctionInvocation */)) return false;
}
        return true;
    }
}

void CppArrayList::fillRange(int64_t start, int64_t end, std::any fillValue) {
    {
        for (int64_t i = start; (i < end); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(this._array, i, native_cppBox(fillValue));
}
    }
}

std::any CppArrayList::firstWhere(std::any test) {
    {
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: FunctionInvocation */) {
    return native_cppUnbox(native_cppGetPointerArrayItem(this._array, i));
}
}
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            return /* TODO: Unsupported expression type: FunctionInvocation */;
        }
        throw std::make_shared<CppStateError>("No element");
    }
}

std::any CppArrayList::fold(std::any initialValue, std::any combine) {
    {
        T value = initialValue;
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    value = /* TODO: Unsupported expression type: FunctionInvocation */;
}
        return value;
    }
}

void CppArrayList::forEach(std::any action) {
    {
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    /* TODO: Unsupported expression type: FunctionInvocation */;
}
    }
}

DartObject* CppArrayList::getRange(int64_t start, int64_t end) {
    {
        return CppArrayList<E>_from(CppIterable::generate((end - start), /* TODO: Unsupported expression type: FunctionExpression */));
    }
}

int64_t CppArrayList::indexOf(std::any element, int64_t start) {
    {
        for (int64_t i = start; (i < this._length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) return i;
}
        return -1LL;
    }
}

int64_t CppArrayList::indexWhere(std::any test, int64_t start) {
    {
        for (int64_t i = start; (i < this._length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: FunctionInvocation */) return i;
}
        return -1LL;
    }
}

void CppArrayList::insert(int64_t index, std::any element) {
    {
        if (((index < 0LL) || (index > this._length))) {
            throw std::make_shared<CppIndexError>(index, this);
        }
        this.ensureCapacity((this._length + 1LL));
        for (int64_t i = this._length; (i > index); i = (i - 1LL)) {
    native_cppSetPointerArrayItem(this._array, i, native_cppGetPointerArrayItem(this._array, (i - 1LL)));
}
        native_cppSetPointerArrayItem(this._array, index, native_cppBox(element));
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

void CppArrayList::insertAll(int64_t index, DartObject* iterable) {
    {
        if (((index < 0LL) || (index > this._length))) {
            throw std::make_shared<CppIndexError>(index, this);
        }
        CppList elements = iterable.toList();
        int64_t insertLength = elements.length;
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            return;
        }
        this.ensureCapacity((this._length + insertLength));
        for (int64_t i = (this._length - 1LL); (i >= index); i = (i - 1LL)) {
    native_cppSetPointerArrayItem(this._array, (i + insertLength), native_cppGetPointerArrayItem(this._array, i));
}
        for (int64_t i = 0LL; (i < insertLength); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(this._array, (index + i), native_cppBox(elements[i]));
}
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

std::any CppArrayList::first() {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            throw std::make_shared<CppStateError>("No element");
        }
        return native_cppUnbox(native_cppGetPointerArrayItem(this._array, 0LL));
    }
}

void CppArrayList::first(std::any value) {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            throw std::make_shared<CppStateError>("No element");
        }
        native_cppSetPointerArrayItem(this._array, 0LL, native_cppBox(value));
    }
}

std::any CppArrayList::last() {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            throw std::make_shared<CppStateError>("No element");
        }
        return native_cppUnbox(native_cppGetPointerArrayItem(this._array, (this._length - 1LL)));
    }
}

void CppArrayList::last(std::any value) {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            throw std::make_shared<CppStateError>("No element");
        }
        native_cppSetPointerArrayItem(this._array, (this._length - 1LL), native_cppBox(value));
    }
}

std::any CppArrayList::single() {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            throw std::make_shared<CppStateError>("No element");
        }
        if ((this._length > 1LL)) {
            throw std::make_shared<CppStateError>("Too many elements");
        }
        return native_cppUnbox(native_cppGetPointerArrayItem(this._array, 0LL));
    }
}

bool CppArrayList::isEmpty() {
    return /* TODO: Unsupported expression type: EqualsCall */;
}

bool CppArrayList::isNotEmpty() {
    return !(/* TODO: Unsupported expression type: EqualsCall */);
}

DartObject* CppArrayList::iterator() {
    return std::make_shared<_CppListIterator<E>>(this);
}

int64_t CppArrayList::lastIndexOf(std::any element, int64_t start) {
    {
        int64_t startIndex = /* TODO: Unsupported expression type: Let */;
        for (int64_t i = startIndex; (i >= 0LL); i = (i - 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) return i;
}
        return -1LL;
    }
}

int64_t CppArrayList::lastIndexWhere(std::any test, int64_t start) {
    {
        int64_t startIndex = /* TODO: Unsupported expression type: Let */;
        for (int64_t i = startIndex; (i >= 0LL); i = (i - 1LL)) {
    if (/* TODO: Unsupported expression type: FunctionInvocation */) return i;
}
        return -1LL;
    }
}

std::any CppArrayList::lastWhere(std::any test) {
    {
        for (int64_t i = (this._length - 1LL); (i >= 0LL); i = (i - 1LL)) {
    if (/* TODO: Unsupported expression type: FunctionInvocation */) {
    return native_cppUnbox(native_cppGetPointerArrayItem(this._array, i));
}
}
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            return /* TODO: Unsupported expression type: FunctionInvocation */;
        }
        throw std::make_shared<CppStateError>("No element");
    }
}

std::any CppArrayList::reduce(std::any combine) {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            throw std::make_shared<CppStateError>("No element");
        }
        E value = native_cppUnbox(native_cppGetPointerArrayItem(this._array, 0LL));
        for (int64_t i = 1LL; (i < this._length); i = (i + 1LL)) {
    value = /* TODO: Unsupported expression type: FunctionInvocation */;
}
        return value;
    }
}

bool CppArrayList::remove(DartObject* value) {
    {
        int64_t index = this.indexOf(static_cast<E>(value));
        if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
            {
                this.removeAt(index);
                return true;
            }
        }
        return false;
    }
}

std::any CppArrayList::removeAt(int64_t index) {
    {
        if (((index < 0LL) || (index >= this._length))) {
            throw std::make_shared<CppIndexError>(index, this);
        }
        E element = native_cppUnbox(native_cppGetPointerArrayItem(this._array, index));
        for (int64_t i = index; (i < (this._length - 1LL)); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(this._array, i, native_cppGetPointerArrayItem(this._array, (i + 1LL)));
}
        /* TODO: Unsupported expression type: InstanceSet */;
        return static_cast<E>(element);
    }
}

std::any CppArrayList::removeLast() {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            throw std::make_shared<CppStateError>("No element");
        }
        return this.removeAt((this._length - 1LL));
    }
}

void CppArrayList::removeRange(int64_t start, int64_t end) {
    {
        if (((((start < 0LL) || (start > this._length)) || (end < start)) || (end > this._length))) {
            {
                throw std::make_shared<CppRangeError>(start, 0LL, this._length);
            }
        }
        int64_t length = (end - start);
        for (int64_t i = start; (i < (this._length - length)); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(this._array, i, native_cppGetPointerArrayItem(this._array, (i + length)));
}
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

void CppArrayList::removeWhere(std::any test) {
    {
        int64_t writeIndex = 0LL;
        for (int64_t readIndex = 0LL; (readIndex < this._length); readIndex = (readIndex + 1LL)) {
    if (!(/* TODO: Unsupported expression type: FunctionInvocation */)) {
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    native_cppSetPointerArrayItem(this._array, writeIndex, native_cppGetPointerArrayItem(this._array, readIndex));
}
    writeIndex = (writeIndex + 1LL);
}
}
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

void CppArrayList::replaceRange(int64_t start, int64_t end, DartObject* replacements) {
    {
        if (((((start < 0LL) || (start > this._length)) || (end < start)) || (end > this._length))) {
            {
                throw std::make_shared<CppRangeError>(start, 0LL, this._length);
            }
        }
        CppList replacementList = replacements.toList();
        int64_t replacementLength = replacementList.length;
        int64_t rangeLength = (end - start);
        if ((replacementLength > rangeLength)) {
            {
                this.ensureCapacity(((this._length + replacementLength) - rangeLength));
            }
        }
        if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
            {
                for (int64_t i = (this._length - 1LL); (i >= end); i = (i - 1LL)) {
    native_cppSetPointerArrayItem(this._array, ((i + replacementLength) - rangeLength), native_cppGetPointerArrayItem(this._array, i));
}
            }
        }
        for (int64_t i = 0LL; (i < replacementLength); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(this._array, (start + i), native_cppBox(replacementList[i]));
}
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

void CppArrayList::retainWhere(std::any test) {
    {
        int64_t writeIndex = 0LL;
        for (int64_t readIndex = 0LL; (readIndex < this._length); readIndex = (readIndex + 1LL)) {
    if (/* TODO: Unsupported expression type: FunctionInvocation */) {
    if (!(/* TODO: Unsupported expression type: EqualsCall */)) {
    native_cppSetPointerArrayItem(this._array, writeIndex, native_cppGetPointerArrayItem(this._array, readIndex));
}
    writeIndex = (writeIndex + 1LL);
}
}
        /* TODO: Unsupported expression type: InstanceSet */;
    }
}

void CppArrayList::setAll(int64_t index, DartObject* iterable) {
    {
        if (((index < 0LL) || (index > this._length))) {
            throw std::make_shared<CppIndexError>(index, this);
        }
        int64_t i = index;
        {
            CppIterator _sync_for_iterator = iterable.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    E element = _sync_for_iterator.current;
    if ((i >= this._length)) {
    this.add(element);
} else {
    native_cppSetPointerArrayItem(this._array, i, native_cppBox(element));
}
    i = (i + 1LL);
}
        }
    }
}

void CppArrayList::setRange(int64_t start, int64_t end, DartObject* iterable, int64_t skipCount) {
    {
        if (((((start < 0LL) || (start > this._length)) || (end < start)) || (end > this._length))) {
            {
                throw std::make_shared<CppRangeError>(start, 0LL, this._length);
            }
        }
        CppIterator iterator = iterable.iterator;
        for (int64_t i = 0LL; (i < skipCount); i = (i + 1LL)) {
    if (!(iterator.moveNext())) return;
}
        /* TODO: Unsupported statement type: LabeledStatement */
    }
}

void CppArrayList::shuffle(DartObject* random) {
    {
        (/* TODO: Unsupported expression type: EqualsNull */ ? random = Random() : nullptr);
        for (int64_t i = (this._length - 1LL); (i > 0LL); i = (i - 1LL)) {
    int64_t j = random.nextInt((i + 1LL));
    DartObject* temp = native_cppGetPointerArrayItem(this._array, i);
    native_cppSetPointerArrayItem(this._array, i, native_cppGetPointerArrayItem(this._array, j));
    native_cppSetPointerArrayItem(this._array, j, temp);
}
    }
}

void CppArrayList::sort(std::any compare) {
    {
        if ((this._length <= 1LL)) {
            return;
        }
        this._quickSort(0LL, (this._length - 1LL), compare);
    }
}

void CppArrayList::_quickSort(int64_t low, int64_t high, std::any compare) {
    {
        if ((low < high)) {
            {
                int64_t pi = this._partition(low, high, compare);
                this._quickSort(low, (pi - 1LL), compare);
                this._quickSort((pi + 1LL), high, compare);
            }
        }
    }
}

int64_t CppArrayList::_partition(int64_t low, int64_t high, std::any compare) {
    {
        E pivot = native_cppUnbox(native_cppGetPointerArrayItem(this._array, high));
        int64_t i = (low - 1LL);
        for (int64_t j = low; (j < high); j = (j + 1LL)) {
    E current = native_cppUnbox(native_cppGetPointerArrayItem(this._array, j));
    bool shouldSwap = false;
    if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
    shouldSwap = (/* TODO: Unsupported expression type: FunctionInvocation */ <= 0LL);
} else {
    shouldSwap = (static_cast<Comparable>(current).compareTo(pivot) <= 0LL);
}
    if (shouldSwap) {
    i = (i + 1LL);
    this._swap(i, j);
}
}
        this._swap((i + 1LL), high);
        return (i + 1LL);
    }
}

void CppArrayList::_swap(int64_t i, int64_t j) {
    {
        E temp = static_cast<E>(native_cppGetPointerArrayItem(this._array, i));
        native_cppSetPointerArrayItem(this._array, i, native_cppGetPointerArrayItem(this._array, j));
        native_cppSetPointerArrayItem(this._array, j, temp);
    }
}

DartObject* CppArrayList::sublist(int64_t start, int64_t end) {
    {
        int64_t endIndex = /* TODO: Unsupported expression type: Let */;
        if (((((start < 0LL) || (start > this._length)) || (endIndex < start)) || (endIndex > this._length))) {
            {
                throw std::make_shared<CppRangeError>(start, 0LL, this._length);
            }
        }
        return CppArrayList<E>_from(CppIterable::generate((endIndex - start), /* TODO: Unsupported expression type: FunctionExpression */));
    }
}

DartObject* CppArrayList::toList() {
    {
        return CppArrayList<E>_from(static_cast<CppIterable>(this), /* growable: */ growable);
    }
}

DartObject* CppArrayList::toSet() {
    {
        return CppArraySet<E>_from(this);
    }
}

std::any CppArrayList::singleWhere(std::any test) {
    {
        E result = nullptr;
        bool found = false;
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: FunctionInvocation */) {
    if (found) throw std::make_shared<CppStateError>("Too many elements");
    result = native_cppUnbox(native_cppGetPointerArrayItem(this._array, i));
    found = true;
}
}
        if (found) {
            return /* TODO: Unsupported expression type: NullCheck */;
        }
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            return /* TODO: Unsupported expression type: FunctionInvocation */;
        }
        throw std::make_shared<CppStateError>("No element");
    }
}

DartObject* CppArrayList::_(DartObject* other) {
    {
        CppArrayList result = std::make_shared<CppArrayList<E>>(0LL, (this._length + other.length));
        for (int64_t i = 0LL; (i < this._length); i = (i + 1LL)) {
    result.add(native_cppUnbox(native_cppGetPointerArrayItem(this._array, i)));
}
        {
            CppIterator _sync_for_iterator = other.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    result.add(_sync_for_iterator.current);
}
        }
        return result;
    }
}

DartObject* CppArrayList::toCppString() {
    {
        if (/* TODO: Unsupported expression type: EqualsCall */) {
            return CppString::fromString("[]");
        }
        CppStringBuffer buffer = std::make_shared<CppStringBuffer>("[");
        buffer.write(native_cppUnbox(native_cppGetPointerArrayItem(this._array, 0LL)));
        for (int64_t i = 1LL; (i < this._length); i = (i + 1LL)) {
    buffer.write(", ");
    buffer.write(native_cppUnbox(native_cppGetPointerArrayItem(this._array, i)));
}
        buffer.write("]");
        return buffer.toCppString();
    }
}

static DartObject* CppArrayList::empty() {
    {
        return (growable ? std::make_shared<CppArrayList<E>>(0LL, 0LL) : std::make_shared<CppArrayList<E>>(0LL, 0LL));
    }
}

static DartObject* CppArrayList::filled(int64_t length, std::any fill) {
    {
        CppUserData array = native_cppCreatePointerArray(length);
        for (int64_t i = 0LL; (i < length); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(array, i, native_cppBox(fill));
}
        return std::make_shared<CppArrayList<E>>(array);
    }
}

static DartObject* CppArrayList::from(DartObject* elements) {
    {
        int64_t length = elements.length;
        CppUserData array = (growable ? native_cppCreatePointerArray(length) : native_cppCreatePointerArray(CppArrayList::_getSuggestCapacity(length)));
        int64_t i = 0LL;
        {
            CppIterator _sync_for_iterator = elements.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    native_cppSetPointerArrayItem(array, /* TODO: Unsupported expression type: Let */, native_cppBox(_sync_for_iterator.current));
}
        }
        return std::make_shared<CppArrayList<E>>(array);
    }
}

static DartObject* CppArrayList::of(DartObject* elements) {
    return CppArrayList<E>_from(elements, /* growable: */ growable);
}

static DartObject* CppArrayList::generate(int64_t length, std::any generator) {
    {
        CppUserData array = (growable ? native_cppCreatePointerArray(length) : native_cppCreatePointerArray(CppArrayList::_getSuggestCapacity(length)));
        for (int64_t i = 0LL; (i < length); i = (i + 1LL)) {
    native_cppSetPointerArrayItem(array, i, native_cppBox(/* TODO: Unsupported expression type: FunctionInvocation */));
}
        return std::make_shared<CppArrayList<E>>(array);
    }
}

static DartObject* CppArrayList::unmodifiable(DartObject* elements) {
    {
        int64_t length = elements.length;
        CppUserData array = native_cppCreatePointerArray(length);
        int64_t i = 0LL;
        {
            CppIterator _sync_for_iterator = elements.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    native_cppSetPointerArrayItem(array, /* TODO: Unsupported expression type: Let */, native_cppBox(_sync_for_iterator.current));
}
        }
        return std::make_shared<CppArrayList<E>>(array);
    }
}

static int64_t CppArrayList::_getSuggestCapacity(int64_t newLen) {
    {
        return ((newLen > 256LL) ? newLen : pow(2LL, (log(newLen) / log(2LL)).ceil()).toInt());
    }
}

static DartObject* CppArrayList::castFrom(DartObject* source) {
    {
        CppArrayList result = std::make_shared<CppArrayList<R>>(0LL, 4LL);
        {
            CppIterator _sync_for_iterator = source.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    result.add(static_cast<R>(_sync_for_iterator.current));
}
        }
        return result;
    }
}

static DartObject* CppArrayList::castFromWithFactory(DartObject* source, std::any newList) {
    {
        CppList result = /* TODO: Unsupported expression type: FunctionInvocation */;
        {
            CppIterator _sync_for_iterator = source.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    result.add(static_cast<R>(_sync_for_iterator.current));
}
        }
        return result;
    }
}


// Implementation of class: _CppListIterator
_CppListIterator(DartObject* _list) : _list(_list) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

_CppListIterator::~_CppListIterator() {
    // Destructor
}

std::any _CppListIterator::current() {
    return this._list[this._index];
}

bool _CppListIterator::moveNext() {
    {
        /* TODO: Unsupported expression type: InstanceSet */;
        return (this._index < this._list.length);
    }
}


// Implementation of class: CppSet
CppSet::CppSet() {
    // Default constructor
}

CppSet::~CppSet() {
    // Destructor
}

bool CppSet::add(std::any value) {
    // TODO: Implement method body
    return false;
}

void CppSet::addAll(DartObject* elements) {
    // TODO: Implement method body
}

DartObject* CppSet::cast() {
    // TODO: Implement method body
    return nullptr;
}

void CppSet::clear() {
    // TODO: Implement method body
}

bool CppSet::contains(DartObject* element) {
    // TODO: Implement method body
    return false;
}

bool CppSet::containsAll(DartObject* other) {
    // TODO: Implement method body
    return false;
}

DartObject* CppSet::difference(DartObject* other) {
    // TODO: Implement method body
    return nullptr;
}

std::any CppSet::elementAt(int64_t index) {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppSet::intersection(DartObject* other) {
    // TODO: Implement method body
    return nullptr;
}

std::any CppSet::first() {
    // TODO: Implement method body
    return nullptr;
}

std::any CppSet::last() {
    // TODO: Implement method body
    return nullptr;
}

std::any CppSet::single() {
    // TODO: Implement method body
    return nullptr;
}

bool CppSet::isEmpty() {
    // TODO: Implement method body
    return false;
}

bool CppSet::isNotEmpty() {
    // TODO: Implement method body
    return false;
}

DartObject* CppSet::iterator() {
    // TODO: Implement method body
    return nullptr;
}

int64_t CppSet::length() {
    // TODO: Implement method body
    return 0;
}

std::any CppSet::lookup(DartObject* element) {
    // TODO: Implement method body
    return nullptr;
}

bool CppSet::remove(DartObject* value) {
    // TODO: Implement method body
    return false;
}

void CppSet::removeAll(DartObject* elementsToRemove) {
    // TODO: Implement method body
}

void CppSet::removeWhere(std::any test) {
    // TODO: Implement method body
}

void CppSet::retainAll(DartObject* elementsToRetain) {
    // TODO: Implement method body
}

void CppSet::retainWhere(std::any test) {
    // TODO: Implement method body
}

DartObject* CppSet::union_(DartObject* other) {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppSet::toCppString() {
    // TODO: Implement method body
    return nullptr;
}

static DartObject* CppSet::identity() {
    return CppArraySet<E>_identity();
}

static DartObject* CppSet::from(DartObject* elements) {
    {
        return CppArraySet<E>_from(elements);
    }
}

static DartObject* CppSet::of(DartObject* elements) {
    return CppArraySet<E>_of(elements);
}

static DartObject* CppSet::unmodifiable(DartObject* elements) {
    {
        return CppArraySet<E>_unmodifiable(elements);
    }
}

static DartObject* CppSet::castFrom(DartObject* source) {
    {
        return CppArraySet::castFrom(source);
    }
}

static DartObject* CppSet::castFromWithFactory(DartObject* source, std::any newSet) {
    {
        return CppArraySet::castFromWithFactory(source, newSet);
    }
}


// Implementation of class: CppArraySet
CppArraySet(DartObject* array) : array(array) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppArraySet(int64_t capacity) : capacity(capacity) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppArraySet::~CppArraySet() {
    // Destructor
}

bool CppArraySet::add(std::any value) {
    {
        if (this.contains(value)) {
            {
                return false;
            }
        }
        this._list.add(value);
        return true;
    }
}

void CppArraySet::addAll(DartObject* elements) {
    {
        {
            CppIterator _sync_for_iterator = elements.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    this.add(_sync_for_iterator.current);
}
        }
    }
}

DartObject* CppArraySet::cast() {
    {
        return static_cast<CppIterable>(CppSet::castFrom(this));
    }
}

void CppArraySet::clear() {
    {
        this._list.clear();
    }
}

bool CppArraySet::contains(DartObject* element) {
    {
        for (int64_t i = 0LL; (i < this._list.length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) {
    return true;
}
}
        return false;
    }
}

bool CppArraySet::containsAll(DartObject* other) {
    {
        {
            CppIterator _sync_for_iterator = other.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    if (!(this.contains(_sync_for_iterator.current))) return false;
}
        }
        return true;
    }
}

DartObject* CppArraySet::difference(DartObject* other) {
    {
        CppArraySet result = std::make_shared<CppArraySet<E>>();
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    E element = _sync_for_iterator.current;
    if (!(other.contains(element))) {
    result.add(element);
}
}
        }
        return result;
    }
}

std::any CppArraySet::elementAt(int64_t index) {
    return this._list.elementAt(index);
}

DartObject* CppArraySet::intersection(DartObject* other) {
    {
        CppArraySet result = std::make_shared<CppArraySet<E>>();
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    E element = _sync_for_iterator.current;
    if (other.contains(element)) {
    result.add(element);
}
}
        }
        return result;
    }
}

std::any CppArraySet::first() {
    {
        if (this._list.isEmpty) {
            throw std::make_shared<CppStateError>("No element");
        }
        return this._list.first;
    }
}

std::any CppArraySet::last() {
    {
        if (this._list.isEmpty) {
            throw std::make_shared<CppStateError>("No element");
        }
        return this._list.last;
    }
}

std::any CppArraySet::single() {
    {
        if (this._list.isEmpty) {
            throw std::make_shared<CppStateError>("No element");
        }
        if ((this._list.length > 1LL)) {
            throw std::make_shared<CppStateError>("Too many elements");
        }
        return this._list.single;
    }
}

bool CppArraySet::isEmpty() {
    return this._list.isEmpty;
}

bool CppArraySet::isNotEmpty() {
    return this._list.isNotEmpty;
}

DartObject* CppArraySet::iterator() {
    return this._list.iterator;
}

int64_t CppArraySet::length() {
    return this._list.length;
}

std::any CppArraySet::lookup(DartObject* element) {
    {
        for (int64_t i = 0LL; (i < this._list.length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) {
    return this._list[i];
}
}
        return nullptr;
    }
}

bool CppArraySet::remove(DartObject* value) {
    {
        return this._list.remove(value);
    }
}

void CppArraySet::removeAll(DartObject* elementsToRemove) {
    {
        {
            CppIterator _sync_for_iterator = elementsToRemove.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    this.remove(_sync_for_iterator.current);
}
        }
    }
}

void CppArraySet::removeWhere(std::any test) {
    {
        this._list.removeWhere(test);
    }
}

void CppArraySet::retainAll(DartObject* elementsToRetain) {
    {
        CppSet retainSet = CppSet<std::any>_from(elementsToRetain);
        this.removeWhere(/* TODO: Unsupported expression type: FunctionExpression */);
    }
}

void CppArraySet::retainWhere(std::any test) {
    {
        this._list.retainWhere(test);
    }
}

DartObject* CppArraySet::union_(DartObject* other) {
    {
        CppArraySet result = std::make_shared<CppArraySet<E>>();
        result.addAll(static_cast<CppIterable>(this));
        result.addAll(static_cast<CppIterable>(other));
        return result;
    }
}

DartObject* CppArraySet::toCppString() {
    {
        if (this._list.isEmpty) {
            return CppString::fromString("{}");
        }
        CppStringBuffer buffer = std::make_shared<CppStringBuffer>("{");
        CppIterator iterator = this._list.iterator;
        if (iterator.moveNext()) {
            {
                buffer.write(iterator.current);
                while (iterator.moveNext()) {
                    {
                        buffer.write(", ");
                        buffer.write(iterator.current);
                    }
                }
            }
        }
        buffer.write("}");
        return buffer.toCppString();
    }
}

static DartObject* CppArraySet::identity() {
    return std::make_shared<CppArraySet<E>>(4LL);
}

static DartObject* CppArraySet::from(DartObject* elements) {
    {
        CppArraySet set = std::make_shared<CppArraySet<E>>();
        {
            CppIterator _sync_for_iterator = elements.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    set.add(static_cast<E>(_sync_for_iterator.current));
}
        }
        return set;
    }
}

static DartObject* CppArraySet::of(DartObject* elements) {
    return CppArraySet<E>_from(elements);
}

static DartObject* CppArraySet::unmodifiable(DartObject* elements) {
    {
        CppArraySet set = std::make_shared<CppArraySet<E>>();
        {
            CppIterator _sync_for_iterator = elements.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    set.add(_sync_for_iterator.current);
}
        }
        return set;
    }
}

static DartObject* CppArraySet::castFrom(DartObject* source) {
    {
        CppArraySet result = std::make_shared<CppArraySet<R>>();
        {
            CppIterator _sync_for_iterator = source.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    result.add(static_cast<R>(_sync_for_iterator.current));
}
        }
        return result;
    }
}

static DartObject* CppArraySet::castFromWithFactory(DartObject* source, std::any newSet) {
    {
        CppSet result = /* TODO: Unsupported expression type: FunctionInvocation */;
        {
            CppIterator _sync_for_iterator = source.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    result.add(static_cast<R>(_sync_for_iterator.current));
}
        }
        return result;
    }
}


// Implementation of class: CppMapEntry
CppMapEntry(std::any key, std::any value) : key(key), value(value) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppMapEntry::~CppMapEntry() {
    // Destructor
}


// Implementation of class: CppMap
CppMap::CppMap() {
    // Default constructor
}

CppMap::~CppMap() {
    // Destructor
}

std::any CppMap::__(DartObject* key) {
    // TODO: Implement method body
    return nullptr;
}

void CppMap::___(std::any key, std::any value) {
    // TODO: Implement method body
}

void CppMap::addAll(DartObject* other) {
    // TODO: Implement method body
}

void CppMap::addEntries(DartObject* entries) {
    // TODO: Implement method body
}

DartObject* CppMap::cast() {
    // TODO: Implement method body
    return nullptr;
}

void CppMap::clear() {
    // TODO: Implement method body
}

bool CppMap::containsKey(DartObject* key) {
    // TODO: Implement method body
    return false;
}

bool CppMap::containsValue(DartObject* value) {
    // TODO: Implement method body
    return false;
}

DartObject* CppMap::entries() {
    // TODO: Implement method body
    return nullptr;
}

void CppMap::forEach(std::any action) {
    // TODO: Implement method body
}

bool CppMap::isEmpty() {
    // TODO: Implement method body
    return false;
}

bool CppMap::isNotEmpty() {
    // TODO: Implement method body
    return false;
}

DartObject* CppMap::keys() {
    // TODO: Implement method body
    return nullptr;
}

int64_t CppMap::length() {
    // TODO: Implement method body
    return 0;
}

std::any CppMap::putIfAbsent(std::any key, std::any ifAbsent) {
    // TODO: Implement method body
    return nullptr;
}

std::any CppMap::remove(DartObject* key) {
    // TODO: Implement method body
    return nullptr;
}

void CppMap::removeWhere(std::any test) {
    // TODO: Implement method body
}

std::any CppMap::update(std::any key, std::any update) {
    // TODO: Implement method body
    return nullptr;
}

void CppMap::updateAll(std::any update) {
    // TODO: Implement method body
}

DartObject* CppMap::values() {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppMap::map(std::any transform) {
    // TODO: Implement method body
    return nullptr;
}

DartObject* CppMap::toCppString() {
    // TODO: Implement method body
    return nullptr;
}

static DartObject* CppMap::identity() {
    return CppArrayMap<K, V>_identity();
}

static DartObject* CppMap::from(DartObject* other) {
    return CppArrayMap<K, V>_from(other);
}

static DartObject* CppMap::of(DartObject* other) {
    return CppArrayMap<K, V>_of(other);
}

static DartObject* CppMap::unmodifiable(DartObject* other) {
    {
        return CppArrayMap<K, V>_unmodifiable(other);
    }
}

static DartObject* CppMap::fromIterable(DartObject* iterable) {
    {
        return CppArrayMap<K, V>_fromIterable(iterable, /* key: */ key, /* value: */ value);
    }
}

static DartObject* CppMap::fromIterables(DartObject* keys, DartObject* values) {
    {
        return CppArrayMap<K, V>_fromIterables(keys, values);
    }
}

static DartObject* CppMap::fromEntries(DartObject* entries) {
    {
        return CppArrayMap<K, V>_fromEntries(entries);
    }
}

static DartObject* CppMap::castFrom(DartObject* source) {
    {
        return CppArrayMap::castFrom(source);
    }
}

static DartObject* CppMap::castFromWithFactory(DartObject* source, std::any newMap) {
    {
        return CppArrayMap::castFromWithFactory(source, newMap);
    }
}


// Implementation of class: CppArrayMap
CppArrayMap(DartObject* array) : array(array) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppArrayMap(int64_t capacity) : capacity(capacity) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppArrayMap::~CppArrayMap() {
    // Destructor
}

std::any CppArrayMap::__(DartObject* key) {
    {
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    if (/* TODO: Unsupported expression type: EqualsCall */) {
    return entry.value;
}
}
        }
        return nullptr;
    }
}

void CppArrayMap::___(std::any key, std::any value) {
    {
        for (int64_t i = 0LL; (i < this._list.length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) {
    this._list[i] = std::make_shared<CppMapEntry<K, V>>(key, value);
    return;
}
}
        this._list.add(std::make_shared<CppMapEntry<K, V>>(key, value));
    }
}

void CppArrayMap::addAll(DartObject* other) {
    {
        other.forEach(/* TODO: Unsupported expression type: FunctionExpression */);
    }
}

void CppArrayMap::addEntries(DartObject* entries) {
    {
        {
            CppIterator _sync_for_iterator = entries.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    this[entry.key] = entry.value;
}
        }
    }
}

DartObject* CppArrayMap::cast() {
    return CppMap::castFrom(this);
}

void CppArrayMap::clear() {
    {
        this._list.clear();
    }
}

bool CppArrayMap::containsKey(DartObject* key) {
    {
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    if (/* TODO: Unsupported expression type: EqualsCall */) return true;
}
        }
        return false;
    }
}

bool CppArrayMap::containsValue(DartObject* value) {
    {
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    if (/* TODO: Unsupported expression type: EqualsCall */) return true;
}
        }
        return false;
    }
}

DartObject* CppArrayMap::entries() {
    return this._list;
}

void CppArrayMap::forEach(std::any action) {
    {
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    /* TODO: Unsupported expression type: FunctionInvocation */;
}
        }
    }
}

bool CppArrayMap::isEmpty() {
    return this._list.isEmpty;
}

bool CppArrayMap::isNotEmpty() {
    return this._list.isNotEmpty;
}

DartObject* CppArrayMap::keys() {
    return this._list.map(/* TODO: Unsupported expression type: FunctionExpression */);
}

int64_t CppArrayMap::length() {
    return this._list.length;
}

std::any CppArrayMap::putIfAbsent(std::any key, std::any ifAbsent) {
    {
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    if (/* TODO: Unsupported expression type: EqualsCall */) return entry.value;
}
        }
        V v = /* TODO: Unsupported expression type: FunctionInvocation */;
        this._list.add(std::make_shared<CppMapEntry<K, V>>(key, v));
        return v;
    }
}

std::any CppArrayMap::remove(DartObject* key) {
    {
        for (int64_t i = 0LL; (i < this._list.length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) {
    V v = this._list[i].value;
    for (int64_t j = i; (j < (this._list.length - 1LL)); j = (j + 1LL)) {
    this._list[j] = this._list[(j + 1LL)];
}
    /* TODO: Unsupported expression type: InstanceSet */;
    return v;
}
}
        return nullptr;
    }
}

void CppArrayMap::removeWhere(std::any test) {
    {
        int64_t i = 0LL;
        while ((i < this._list.length)) {
            {
                CppMapEntry entry = this._list[i];
                if (/* TODO: Unsupported expression type: FunctionInvocation */) {
                    {
                        this.remove(entry.key);
                    }
                } else {
                    {
                        i = (i + 1LL);
                    }
                }
            }
        }
    }
}

std::any CppArrayMap::update(std::any key, std::any update) {
    {
        for (int64_t i = 0LL; (i < this._list.length); i = (i + 1LL)) {
    if (/* TODO: Unsupported expression type: EqualsCall */) {
    V newValue = /* TODO: Unsupported expression type: FunctionInvocation */;
    this._list[i] = std::make_shared<CppMapEntry<K, V>>(key, newValue);
    return newValue;
}
}
        if (!(/* TODO: Unsupported expression type: EqualsNull */)) {
            {
                V v = /* TODO: Unsupported expression type: FunctionInvocation */;
                this._list.add(std::make_shared<CppMapEntry<K, V>>(key, v));
                return v;
            }
        }
        throw std::make_shared<ArgumentError>("Key not found");
    }
}

void CppArrayMap::updateAll(std::any update) {
    {
        for (int64_t i = 0LL; (i < this._list.length); i = (i + 1LL)) {
    CppMapEntry entry = this._list[i];
    this._list[i] = std::make_shared<CppMapEntry<K, V>>(entry.key, /* TODO: Unsupported expression type: FunctionInvocation */);
}
    }
}

DartObject* CppArrayMap::values() {
    return this._list.map(/* TODO: Unsupported expression type: FunctionExpression */);
}

DartObject* CppArrayMap::map(std::any transform) {
    {
        CppArrayMap result = std::make_shared<CppArrayMap<K2, V2>>();
        {
            CppIterator _sync_for_iterator = this._list.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    CppMapEntry newEntry = /* TODO: Unsupported expression type: FunctionInvocation */;
    result[newEntry.key] = newEntry.value;
}
        }
        return result;
    }
}

DartObject* CppArrayMap::toCppString() {
    {
        if (this._list.isEmpty) {
            return CppString::fromString("{}");
        }
        CppStringBuffer buffer = std::make_shared<CppStringBuffer>("{");
        CppIterator iterator = this._list.iterator;
        if (iterator.moveNext()) {
            {
                buffer.write(/* TODO: Unsupported expression type: StringConcatenation */);
                while (iterator.moveNext()) {
                    {
                        buffer.write(/* TODO: Unsupported expression type: StringConcatenation */);
                    }
                }
            }
        }
        buffer.write("}");
        return buffer.toCppString();
    }
}

static DartObject* CppArrayMap::identity() {
    return std::make_shared<CppArrayMap<K, V>>();
}

static DartObject* CppArrayMap::from(DartObject* other) {
    return CppArrayMap<K, V>_unmodifiable(other);
}

static DartObject* CppArrayMap::of(DartObject* other) {
    return CppArrayMap<K, V>_fromEntries(other.entries);
}

static DartObject* CppArrayMap::unmodifiable(DartObject* other) {
    {
        CppArrayMap map = std::make_shared<CppArrayMap<K, V>>();
        other.forEach(/* TODO: Unsupported expression type: FunctionExpression */);
        return map;
    }
}

static DartObject* CppArrayMap::fromIterable(DartObject* iterable) {
    {
        CppArrayMap map = std::make_shared<CppArrayMap<K, V>>();
        {
            CppIterator _sync_for_iterator = iterable.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    std::any element = _sync_for_iterator.current;
    std::any k = /* TODO: Unsupported expression type: Let */;
    std::any v = /* TODO: Unsupported expression type: Let */;
    map[static_cast<K>(k)] = static_cast<V>(v);
}
        }
        return map;
    }
}

static DartObject* CppArrayMap::fromIterables(DartObject* keys, DartObject* values) {
    {
        CppArrayMap map = std::make_shared<CppArrayMap<K, V>>();
        CppIterator keyIter = keys.iterator;
        CppIterator valueIter = values.iterator;
        while ((keyIter.moveNext() && valueIter.moveNext())) {
            {
                map[keyIter.current] = valueIter.current;
            }
        }
        return map;
    }
}

static DartObject* CppArrayMap::fromEntries(DartObject* entries) {
    {
        CppArrayMap map = std::make_shared<CppArrayMap<K, V>>();
        {
            CppIterator _sync_for_iterator = entries.iterator;
            for (; _sync_for_iterator.moveNext(); ) {
    CppMapEntry entry = _sync_for_iterator.current;
    map[entry.key] = entry.value;
}
        }
        return map;
    }
}

static DartObject* CppArrayMap::castFrom(DartObject* source) {
    {
        CppArrayMap result = std::make_shared<CppArrayMap<RK, RV>>();
        source.forEach(/* TODO: Unsupported expression type: FunctionExpression */);
        return result;
    }
}

static DartObject* CppArrayMap::castFromWithFactory(DartObject* source, std::any newMap) {
    {
        CppMap result = /* TODO: Unsupported expression type: FunctionInvocation */;
        source.forEach(/* TODO: Unsupported expression type: FunctionExpression */);
        return result;
    }
}


// Implementation of class: CppStackTrace
CppStackTrace() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppStackTrace::~CppStackTrace() {
    // Destructor
}

DartObject* CppStackTrace::toCppString() {
    return std::make_shared<CppString>(native_getCurrentStackTrace());
}

static DartObject* CppStackTrace::current() {
    return CppStackTrace::_current;
}


// Implementation of class: CppError
CppError() {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppError::~CppError() {
    // Destructor
}

DartObject* CppError::stackTrace() {
    return CppStackTrace::current;
}


// Implementation of class: CppStateError
CppStateError(DartObject* message) : message(message) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppStateError::~CppStateError() {
    // Destructor
}


// Implementation of class: CppRangeError
CppRangeError(DartObject* message) : message(message) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppRangeError(DartObject* invalidValue, DartObject* name, DartObject* message) : invalidValue(invalidValue), name(name), message(message) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppRangeError(DartObject* invalidValue, int64_t minValue, int64_t maxValue, DartObject* name, DartObject* message) : invalidValue(invalidValue), minValue(minValue), maxValue(maxValue), name(name), message(message) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppRangeError::~CppRangeError() {
    // Destructor
}


// Implementation of class: CppIndexError
CppIndexError(int64_t invalidValue, DartObject* indexable, DartObject* name, DartObject* message, int64_t length) : invalidValue(invalidValue), indexable(indexable), name(name), message(message), length(length) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppIndexError(int64_t invalidValue, int64_t length) : invalidValue(invalidValue), length(length) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

CppIndexError::~CppIndexError() {
    // Destructor
}


// Implementation of class: BoxInt
BoxInt(int64_t value) : value(value) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

BoxInt::~BoxInt() {
    // Destructor
}

int64_t BoxInt::unbox() {
    return this.value;
}


// Implementation of class: BoxDouble
BoxDouble(double value) : value(value) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

BoxDouble::~BoxDouble() {
    // Destructor
}

double BoxDouble::unbox() {
    return this.value;
}


// Implementation of class: BoxBool
BoxBool(bool value) : value(value) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

BoxBool::~BoxBool() {
    // Destructor
}

bool BoxBool::unbox() {
    return this.value;
}


// Implementation of class: BoxString
BoxString(std::string value) : value(value) {
    /* TODO: Unsupported statement type: EmptyStatement */
}

BoxString::~BoxString() {
    // Destructor
}

std::string BoxString::unbox() {
    return this.value;
}


// Global functions implementation
void main() {
    {
        testIterableMethods();
    }
}

void testCollectionMethods() {
    {
        Random aa = Random();
        aa.nextDouble();
        aa.nextDouble();
        aa.nextDouble();
        CppList list = CppList<int64_t>_filled(3LL, 0LL);
        list[0LL] = 1LL;
        list[1LL] = 2LL;
        list[2LL] = 3LL;
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        list.add(4LL);
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        list.removeAt(1LL);
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        print("CppList 方法测试通过！");
    }
}

std::any testDynamic(int64_t aaa) {
    {
        return std::make_shared<BoxInt>((aaa + 5LL));
    }
}

void testIterableMethods() {
    {
        int64_t ttt = asInt(testDynamic(1LL));
        print(ttt);
        std::any ttt2 = testDynamic(1LL);
        int64_t ggg = asInt(ttt2);
        print(ggg);
        CppUserData list44 = native_cppArrayConst(5LL, 1LL, 2LL, 3LL, 4LL, 5LL);
        CppList iterableList = std::make_shared<CppArrayList<int64_t>>(list44);
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        /* TODO: Unsupported statement type: AssertStatement */
        CppIterable mappedList = iterableList.map(/* TODO: Unsupported expression type: FunctionExpression */);
        /* TODO: Unsupported statement type: AssertStatement */
        CppIterable filteredList = iterableList.where(/* TODO: Unsupported expression type: FunctionExpression */);
        /* TODO: Unsupported statement type: AssertStatement */
        print("CppIterable 方法测试通过！");
        CppStringBuffer buffer = std::make_shared<CppStringBuffer>();
        buffer.write("Hello");
        buffer.write("World");
        print((buffer).toString());
        CppError error = std::make_shared<CppError>();
        (error).toString();
        CppStringBuffer buffer2 = std::make_shared<CppStringBuffer>("xx");
        buffer2.write("Hello");
        buffer2.write("World");
        print((buffer2).toString());
        std::vector<int64_t> list = _GrowableList::generate(10LL, /* TODO: Unsupported expression type: FunctionExpression */);
        list.add(11LL);
        print((list).toString());
        int64_t g1 = 1LL;
        int64_t g2 = 0;
        g2 = 5LL;
        std::function<DartObject*()> ff = /* TODO: Unsupported expression type: FunctionExpression */;
        /* TODO: Unsupported expression type: FunctionInvocation */;
        std::vector<std::any> list2 = _GrowableList::(0LL);
        for (int64_t i = 0LL; (i < 10LL); i = (i + 1LL)) {
    list2.add(/* TODO: Unsupported expression type: FunctionExpression */);
}
        list2.forEach(/* TODO: Unsupported expression type: FunctionExpression */);
        {
            std::vector<std::any> list3 = _GrowableList::(0LL);
            int64_t i = 0LL;
            for (int64_t unnamed = i = 0LL; (i < 10LL); i = (i + 1LL)) {
    list3.add(/* TODO: Unsupported expression type: FunctionExpression */);
}
            list3.forEach(/* TODO: Unsupported expression type: FunctionExpression */);
        }
        {
            std::vector<std::any> list4 = _GrowableList::(0LL);
            for (int64_t i = 0LL; (i < 3LL); i = (i + 1LL)) {
    list4.add(/* TODO: Unsupported expression type: FunctionExpression */);
}
            list4.forEach(/* TODO: Unsupported expression type: FunctionExpression */);
        }
    }
}

DartObject* native_cppCreatePointerArray(int64_t length) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

int64_t native_cppGetPointerArrayLength(DartObject* array) {
    // Native global function implementation should be provided externally
    return 0; // Placeholder for native function
}

DartObject* native_cppGetPointerArrayItem(DartObject* array, int64_t index) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

void native_cppSetPointerArrayItem(DartObject* array, int64_t index, DartObject* value) {
    // Native global function implementation should be provided externally
}

void native_print(DartObject* object) {
    // Native global function implementation should be provided externally
}

DartObject* native_getCurrentStackTrace() {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* native_cppToString(DartObject* object) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* native_cppArrayConst(int64_t length, DartObject* v1, DartObject* v2, DartObject* v3, DartObject* v4, DartObject* v5, DartObject* v6, DartObject* v7, DartObject* v8, DartObject* v9, DartObject* v10) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* native_cppCharCodes(DartObject* value) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* native_cppCreateAsyncTask() {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* native_cppAwaitAsyncTask(DartObject* taskData) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* native_cppGetAsyncTaskResult(DartObject* taskData) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* native_cppBox(DartObject* value) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

std::any native_cppUnbox(DartObject* value) {
    // Native global function implementation should be provided externally
    return nullptr; // Placeholder for native function
}

DartObject* ObjectExt_toCppString(DartObject* _this) {
    {
        if (dynamic_cast<CppAny*>(_this) != nullptr) {
            {
                return static_cast<CppAny>(_this).toCppString();
            }
        }
        throw "Cannot convert to CppString";
    }
}

std::any ObjectExt_get_toCppString(DartObject* _this) {
    return /* TODO: Unsupported expression type: FunctionExpression */;
}

// Global unboxing methods implementation
int64_t asInt(std::any value) {
    try {
        auto boxed = std::any_cast<std::shared_ptr<BoxInt>>(value);
        return boxed->value;
    } catch (const std::bad_any_cast&) {
        try {
            return std::any_cast<int64_t>(value);
        } catch (const std::bad_any_cast&) {
            throw std::runtime_error("Cannot cast to int");
        }
    }
}

double asDouble(std::any value) {
    try {
        auto boxed = std::any_cast<std::shared_ptr<BoxDouble>>(value);
        return boxed->value;
    } catch (const std::bad_any_cast&) {
        try {
            return std::any_cast<double>(value);
        } catch (const std::bad_any_cast&) {
            try {
                return static_cast<double>(std::any_cast<int64_t>(value));
            } catch (const std::bad_any_cast&) {
                throw std::runtime_error("Cannot cast to double");
            }
        }
    }
}

bool asBool(std::any value) {
    try {
        auto boxed = std::any_cast<std::shared_ptr<BoxBool>>(value);
        return boxed->value;
    } catch (const std::bad_any_cast&) {
        try {
            return std::any_cast<bool>(value);
        } catch (const std::bad_any_cast&) {
            throw std::runtime_error("Cannot cast to bool");
        }
    }
}

std::string asString(std::any value) {
    try {
        auto boxed = std::any_cast<std::shared_ptr<BoxString>>(value);
        return boxed->value;
    } catch (const std::bad_any_cast&) {
        try {
            return std::any_cast<std::string>(value);
        } catch (const std::bad_any_cast&) {
            throw std::runtime_error("Cannot cast to string");
        }
    }
}


} // namespace dart_cpp

