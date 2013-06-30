### This Makefile was written for GNU Make. ###
CC      = gcc
# CXX     = g++
# MACROS  = -DNDEBUG
# LDLIBS  = -lm
CFLAGS  = -pipe -Wall -Wextra $(if $(STD), $(addprefix -std=, $(STD)),) $(MACROS)
# CXXFLAGS = -pipe -O3 -Wall -Wextra $(if $(STD), $(addprefix -std=, $(STD)),) $(MACROS)
LDFLAGS = -pipe
TARGET  = template
OBJS    = $(addsuffix .o, $(basename $(TARGET)))
SRCS    = $(OBJS:%.o=%.c)


ifeq ($(OS),Windows_NT)
    TARGET := $(addsuffix .exe, $(TARGET))
    CFLAGS += -finput-charset=utf-8 -fexec-charset=cp932
else
    TARGET := $(addsuffix .out, $(TARGET))
endif

ifeq ($(DEBUG),true)
    CFLAGS  += -O0 -g
else
    CFLAGS  += -O3
    LDFLAGS += -O3 -s
endif

ifeq ($(LTO),true)
    CFLAGS  += -flto
    LDFLAGS += -flto
endif

ifeq ($(OMP),true)
    CFLAGS  += -fopenmp
    LDFLAGS += -fopenmp
else
    CFLAGS  += -Wno-unknown-pragmas
endif

%.exe :
	$(CC) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@


.PHONY : all
all : $(TARGET)

$(TARGET) : $(OBJS)


.PHONY : clean
clean :
	$(RM) $(TARGET) $(OBJS)
.PHONY : objclean
objclean :
	$(RM) $(OBJS)
