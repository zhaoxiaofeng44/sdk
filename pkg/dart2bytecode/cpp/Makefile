CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra

CORE_SRCS = core/object.cpp core/string.cpp core/num.cpp core/math.cpp core/func.cpp core/api.cpp output.cpp
CORE_OBJS = $(CORE_SRCS:.cpp=.o)

.PHONY: all clean test

all: test

test: test/core_test
	./test/core_test

test/core_test: test/core_test.cpp $(CORE_OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f test/core_test $(CORE_OBJS) 