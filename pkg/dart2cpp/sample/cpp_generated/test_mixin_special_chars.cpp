#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Performer
// ============================================================================

class Performer {
public:
  virtual ~Performer() = default;
  
  Nullable perform() {
    dart_print(dart_string("Performing..."));
return Void;
  }
  
};

// ============================================================================
// 类: Singing
// ============================================================================

class Singing {
public:
  virtual ~Singing() = default;
  
  Nullable sing() {
    dart_print(dart_string("Singing..."));
return Void;
  }
  
};

// ============================================================================
// 类: Musician
// ============================================================================

class Musician {
public:
  String name;
  Musician(String name) : name(name) {
  }
  
  Nullable introduce() {
    dart_print(dart_string("I am ") + (this->name).toString());
return Void;
  }
  
};

// ============================================================================
// 类: _Singer_Musician_Performer
// ============================================================================

class _Singer_Musician_Performer : public Musician, virtual public Performer {
public:
  virtual ~_Singer_Musician_Performer() = default;
  
  template<typename... Args>
  _Singer_Musician_Performer(Args&&... args) : Musician(std::forward<Args>(args)...) {}
  
  Nullable perform() {
    dart_print(dart_string("Performing..."));
return Void;
  }
  
};

// ============================================================================
// 类: _Singer_Musician_Performer_Singing
// ============================================================================

class _Singer_Musician_Performer_Singing : public _Singer_Musician_Performer, virtual public Singing {
public:
  virtual ~_Singer_Musician_Performer_Singing() = default;
  
  template<typename... Args>
  _Singer_Musician_Performer_Singing(Args&&... args) : _Singer_Musician_Performer(std::forward<Args>(args)...) {}
  
  Nullable sing() {
    dart_print(dart_string("Singing..."));
return Void;
  }
  
};

// ============================================================================
// 类: Singer
// ============================================================================

class Singer : public _Singer_Musician_Performer_Singing {
public:
  Singer(String name) : _Singer_Musician_Performer_Singing(name) {
  }
  
  Nullable showTalents() {
    this->introduce();
this->perform();
this->sing();
return Void;
  }
  
};

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto singer = ObjectPtr<Singer>(new Singer(dart_string("Alice")));
singer->showTalents();
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
