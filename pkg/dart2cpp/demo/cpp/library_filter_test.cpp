#include "../../cpp/core/object.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// ============================================================================
// 类: MyBusinessClass
// ============================================================================

class MyBusinessClass {
public:
  String name;
  Int value;
  MyBusinessClass(String name, Int value) : name(name), value(value) {
  }
  
  void doSomething() {
    {
      dart_print(dart_string("Business logic: ") + this->name.toString() + dart_string(" has value ") + this->value.toString());
}
  }
  
};

void businessFunction() {
  {
    const auto obj = ObjectPtr<MyBusinessClass>(new MyBusinessClass(dart_string("test"), dart_int(42)));
    obj->doSomething();
}
}

void main() {
  {
    dart_print(dart_string("Testing library filtering..."));
    businessFunction();
}
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    {
      dart_print(dart_string("Testing library filtering..."));
      businessFunction();
}
    {
      VMServiceEmbedderHooks::cleanup = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::createTempDir = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::ddsConnected = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::ddsDisconnected = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::deleteDir = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::writeFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::writeStreamFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::readFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::listFiles = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::serverInformation = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::webServerControl = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::acceptNewWebSocketConnections = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::serveObservatory = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::getResidentCompilerInfoFile = /* Constant: StaticTearOffConstant */;
      server = ObjectPtr<Server>(new Server(VMService::(), _ip, _port, _originCheckDisabled, _authCodesDisabled, _serviceInfoFilename, _enableServicePortFallback));
      if (_autoStart) {
      _toggleWebServer();
}
      _registerSignalHandler();
}
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
