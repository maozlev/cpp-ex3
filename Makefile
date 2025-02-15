#!make -f

CXX=clang++-9 
CXXFLAGS=-std=c++2a -Werror -Wsign-conversion
VALGRIND_FLAGS=-v --leak-check=full --show-leak-kinds=all  --error-exitcode=99

SOURCES=NumberWithUnits.cpp
OBJECTS=$(subst .cpp,.o,$(SOURCES))

run: test
	./$^

test: TestRunner.o StudentTest1.o  StudentTest2.o  StudentTest3.o  $(OBJECTS)
	$(CXX) $(CXXFLAGS) $^ -o test

main: Main.o $(OBJECTS)
	$(CXX) $(CXXFLAGS) $^ -o main

demo: Demo.o $(OBJECTS)
	$(CXX) $(CXXFLAGS) $^ -o demo

%.o: %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) --compile $< -o $@

StudentTest1.cpp:  # Shlomo Glick
	curl https://raw.githubusercontent.com/shlomog12/ex3_partA/main/Test.cpp > $@

StudentTest2.cpp:  # Yair Raviv
	curl https://raw.githubusercontent.com/yairaviv/NumberWithUnits_a/main/Test.cpp > $@

StudentTest3.cpp:  # Roei Birger
	curl https://raw.githubusercontent.com/roei-birger/CPP_course_p3/master/Test.cpp > $@

tidy:
	clang-tidy $(SOURCES) -checks=bugprone-*,clang-analyzer-*,cppcoreguidelines-*,performance-*,portability-*,readability-*,-cppcoreguidelines-pro-bounds-pointer-arithmetic,-cppcoreguidelines-owning-memory --warnings-as-errors=-* --

valgrind: test
	valgrind --leak-check=full --error-exitcode=99 --tool=memcheck $(VALGRIND_FLAGS) ./test 

clean:
	rm -f *.o demo Demo
	rm -f *.o test
	rm -f StudentTest*.cpp
	rm -f filename.txt filename2.txt myTestFile.txt
