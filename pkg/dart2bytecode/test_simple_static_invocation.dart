class TestClass {
  var _first;
  
  void testMethod(var entry) {
    if (identical(entry, _first)) {
      print('Found first element');
    }
  }
} 