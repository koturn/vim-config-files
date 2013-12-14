### This Makefile was written for GNU Make. ###
CC       = gcc
CXX      = g++
# MACROS   = -DNDEBUG
# INCS     = -I./include
CFLAGS   = -pipe $(C_WARNING_FLAGS)   $(COPTFLAGS)   $(INCS) $(if $(STD), $(addprefix -std=, $(STD)),) $(MACROS)
CXXFLAGS = -pipe $(CXX_WARNING_FLAGS) $(CXXOPTFLAGS) $(INCS) $(if $(STD), $(addprefix -std=, $(STD)),) $(MACROS)
LDFLAGS  = -pipe $(LDOPTFLAGS)
# LDLIBS   = -lm
TARGET   = template
OBJS     = $(addsuffix .o, $(basename $(TARGET)))
SRCS     = $(OBJS:%.o=%.c)

C_WARNING_FLAGS = -Wall -Wextra -Wformat=2 -Wstrict-aliasing=2  \
                  -Wcast-align -Wcast-qual -Wconversion         \
                  -Wfloat-equal -Wpointer-arith -Wswitch-enum   \
                  -Wwrite-strings -pedantic
CXX_WARNING_FLAGS = $(C_WARNING_FLAGS) -Weffc++ -Woverloaded-virtual

ifeq ($(OS),Windows_NT)
    TARGET   := $(addsuffix .exe, $(TARGET))
    CFLAGS   += -finput-charset=utf-8 -fexec-charset=cp932
    CXXFLAGS += -finput-charset=utf-8 -fexec-charset=cp932
else
    TARGET := $(addsuffix .out, $(TARGET))
endif

# priority : DEBUG > LTO > OPT
ifeq ($(OPT),true)
    COPTFLAGS    = -flto -Ofast -march=native
    CXXOPTFLAGS  = -flto -Ofast -march=native
    LDOPTFLAGS   = -flto -Ofast -s
else
    COPTFLAGS    = -O3
    CXXOPTFLAGS  = -O3
    LDOPTFLAGS   = -O3 -s
endif
ifeq ($(LTO),true)
    COPTFLAGS    = -flto
    CXXOPTFLAGS  = -flto
    LDOPTFLAGS   = -flto
endif
ifeq ($(DEBUG),true)
    COPTFLAGS    = -O0 -g
    CXXOPTFLAGS  = -O0 -g
endif

ifeq ($(OMP),true)
    COPTFLAGS    += -fopenmp
    CXXOPTFLAGS  += -fopenmp
    LDOPTFLAGS   += -fopenmp
else
    COPTFLAGS    += -Wno-unknown-pragmas
    CXXOPTFLAGS  += -Wno-unknown-pragmas
endif

%.exe :
	$(CC) $(LDFLAGS) $(filter %.c %.o, $^) $(LDLIBS) -o $@
%.out :
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
