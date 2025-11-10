CXX = g++
CXXFLAGS = -std=c++17 -Wall -I..
LDFLAGS =

TARGET = oop_comprehensive_test
SOURCES = oop_comprehensive_test_base.cpp ./core/object.cpp

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SOURCES)

clean:
	rm -f $(TARGET) *.o oop_part*.cpp template_instantiations.cpp

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run

# 迭代器测试
iterator_test: iterator_test.cpp
	$(CXX) $(CXXFLAGS) -o iterator_test iterator_test.cpp ./core/object.cpp

run_iterator: iterator_test
	./iterator_test

clean_iterator:
	rm -f iterator_test

# 自定义类测试
custom_class_test: custom_class_test.cpp
	$(CXX) $(CXXFLAGS) -o custom_class_test custom_class_test.cpp ./core/object.cpp

run_custom: custom_class_test
	./custom_class_test

clean_custom:
	rm -f custom_class_test

# 简单自定义类测试
simple_custom_class_test: simple_custom_class_test.cpp
	$(CXX) $(CXXFLAGS) -o simple_custom_class_test simple_custom_class_test.cpp ./core/object.cpp

run_simple_custom: simple_custom_class_test
	./simple_custom_class_test

clean_simple_custom:
	rm -f simple_custom_class_test

# 最佳实践测试
best_practices_test: best_practices_test.cpp
	$(CXX) $(CXXFLAGS) -o best_practices_test best_practices_test.cpp ./core/object.cpp

run_best_practices: best_practices_test
	./best_practices_test

clean_best_practices:
	rm -f best_practices_test

# ObjectPtr容器测试
objectptr_containers_test: objectptr_containers_test.cpp
	$(CXX) $(CXXFLAGS) -o objectptr_containers_test objectptr_containers_test.cpp ./core/object.cpp

run_objectptr_containers: objectptr_containers_test
	./objectptr_containers_test

clean_objectptr_containers:
	rm -f objectptr_containers_test

# 运行所有测试
test_all: $(TARGET) iterator_test simple_custom_class_test best_practices_test objectptr_containers_test
	@echo "=== 运行OOP综合测试 ==="
	./$(TARGET)
	@echo ""
	@echo "=== 运行迭代器测试 ==="
	./iterator_test
	@echo ""
	@echo "=== 运行简单自定义类测试 ==="
	./simple_custom_class_test
	@echo ""
	@echo "=== 运行最佳实践测试 ==="
	./best_practices_test
	@echo ""
	@echo "=== 运行ObjectPtr容器测试 ==="
	./objectptr_containers_test

# 清理所有测试
clean_all: clean clean_iterator clean_custom clean_simple_custom clean_best_practices clean_objectptr_containers
