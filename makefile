#~/user/bin/make -f
EXECUTABLE = bin/linux/oless

CC         = gcc
CXX        = g++
CXXFLAGS = -lstdc++ -std=c++0x -O3 -Wfatal-errors -Werror

SOURCE = \
	oless/pole.cpp \
	oless/olessoffice.cpp \
	oless/oless.cpp \
	oless/vbahelper.cpp \
	oless/program.cpp

OBJECT = $(SOURCE:.cpp=.o)

# Rules
all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECT)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(CPP_FILES) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -rf $(EXECUTABLE) $(OBJECT)


BINDIR ?= ${PREFIX}/bin

install:
	@cp -p bin/oless ${PREFIX}/bin/oless