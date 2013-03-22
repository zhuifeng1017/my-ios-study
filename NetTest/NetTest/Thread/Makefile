DIR_INCLUDE = ./
DIR_SRC = ./
DIR_BIN = ./
DIR_LIB = ./

TARBALL= threadTT

AR = ar
AR_FLAGS = rs

CC = g++
CC_FLAGS = -g -Wall -I $(DIR_INCLUDE) -L $(DIR_LIB) 

OBJ_LIB = Mutex.o Event.o
OBJ_LIB_SRC = $(DIR_SRC)/Mutex.cpp \
              $(DIR_SRC)/Event.cc
OBJ_LIB_HDR = $(DIR_SRC)/Mutex.h \
              $(DIR_SRC)/Event.h
              

PROGRAM = $(DIR_BIN)/threadTT
OBJ_PROG = Main.o
OBJ_PROG_SRC = $(DIR_SRC)/Main.cpp

MAKEFILE=Makefile
README=README.md
LIB_LINK = -lpthread

$(PROGRAM):$(OBJ_PROG) $(OBJ_LIB)
	$(CC) $(CC_FLAGS) $(OBJ_PROG) $(OBJ_LIB) $(LIB_LINK) -o $(PROGRAM)

$(OBJ_PROG):$(OBJ_PROG_SRC) $(MAKEFILE) 
	$(CC) -c $(OBJ_PROG_SRC) $(CC_FLAGS) 

$(OBJ_LIB):$(OBJ_LIB_SRC) $(OBJ_LIB_HDR) $(MAKEFILE)  
	$(CC) -c $(OBJ_LIB_SRC) $(CC_FLAGS)

clean:
	rm -rf $(OBJ_LIB) $(PROGRAM) $(TARBALL).tar.gz

tarball:
	mkdir $(TARBALL)
	cp $(MAKEFILE) $(README) $(OBJ_LIB_HDR) $(OBJ_LIB_SRC) $(OBJ_PROG_SRC) $(TARBALL)/
	tar cfvz $(TARBALL).tar.gz $(TARBALL) 
	rm -rf $(TARBALL)