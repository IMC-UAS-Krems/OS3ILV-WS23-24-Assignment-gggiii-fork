# This makefile is based on http://www.throwtheswitch.org/build/make

# Environmental variables
MKFILE_DIR := $(shell dirname "$(abspath $(lastword $(MAKEFILE_LIST)))")
WORKING_DIR := $(shell pwd)

# TODO Ensure that the makefile is NOT invoked from the public folder

# OS-Specific Commands
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	INSTALLER = sudo apt-get install 
endif
ifeq ($(UNAME_S),Darwin)
	INSTALLER = brew
endif

# Generic Commands
RM = rm -f
MKDIR = mkdir -p
TARGET_EXTENSION=out

# Project Structure
PATHU = unity/src/
PATHS = src/
PATHT = test/
PATHB = build/
PATHD = build/depends/
PATHO = build/objs/
PATHR = build/results/

BUILD_PATHS = $(PATHB) $(PATHD) $(PATHO) $(PATHR)

# Test source
SRCT = $(wildcard $(PATHT)*.c)

COMPILE=gcc -c
LINK=gcc
DEPEND=gcc -MM -MG -MF
CFLAGS=-I. -I$(PATHU) -I$(PATHS) -DTEST
# TODO: ADD OTHER OPTIONS COVERAGE OPTIONS

# This assume that tests follow the Naming Convention Test<MODULE_NAME>.
# For example, TestBlah.c, where Blah matches the file Blah.c
RESULTS = $(patsubst $(PATHT)Test%.c,$(PATHR)Test%.txt,$(SRCT) )

PASSED = `grep -s PASS $(PATHR)*.txt`
FAIL = `grep -s FAIL $(PATHR)*.txt`
IGNORE = `grep -s IGNORE $(PATHR)*.txt`

LCOV := $(shell command -v lcov 2> /dev/null)
CLANG_FORMAT := $(shell command -v clang-format 2> /dev/null)
UNITY := $(shell [[ -d $(PATHU) ]] && echo "Unity")


###### Targets start here 

help: ## Makefile help
	@echo "Makefile Location: $(MKFILE_DIR)"
	@echo "Working Directory: $(WORKING_DIR)"
	@echo "Available Commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


test: $(BUILD_PATHS) $(RESULTS) ## Run the tests
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"


deps: ## Install dependencies
ifndef LCOV
    $(INSTALLER) lcov
endif
ifndef CLANG_FORMAT
    $(INSTALLER) clang-format
endif
ifndef UNITY
	@echo "Unity not installed"
endif


dirs: $(PATHB) $(PATHD) $(PATHO) $(PATHR) ## Create build directories
	@echo "Done"


clean: ## Clean temp files
	$(CLEANUP) $(PATHO)*.o
	$(CLEANUP) $(PATHB)*.$(TARGET_EXTENSION)
	$(CLEANUP) $(PATHR)*.txt


lint: deps ## Reformat (Lint) the source code with clang-format
	clang-format -i --style=LLVM $(PATHS)%.c $(PATHS)%.h

# coverage: 
# 	@

######
$(PATHR)%.txt: $(PATHB)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

$(PATHB)Test%.$(TARGET_EXTENSION): $(PATHO)Test%.o $(PATHO)%.o $(PATHO)unity.o #$(PATHD)Test%.d
	$(LINK) -o $@ $^

$(PATHO)%.o:: $(PATHT)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o:: $(PATHS)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o:: $(PATHU)%.c $(PATHU)%.h
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHD)%.d:: $(PATHT)%.c
	$(DEPEND) $@ $<

$(PATHB):
	$(MKDIR) $(PATHB)

$(PATHD):
	$(MKDIR) $(PATHD)

$(PATHO):
	$(MKDIR) $(PATHO)

$(PATHR):
	$(MKDIR) $(PATHR)





.PRECIOUS: $(PATHB)Test%.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.d
.PRECIOUS: $(PATHO)%.o
.PRECIOUS: $(PATHR)%.txt




# # Basic flags: -c -Wall -Werror 
# # TODO Are those flags really necessary?
# FLAGS := -O3 -std=c17 -pedantic -Wall -Werror -Wuninitialized -Wshadow -Wwrite-strings -Wconversion -Wunreachable-code -D_POSIX_SOURCE
# FLAGS_DEBUG := -O0 -g -DDEBUG -std=c17 -pedantic -Wall -Werror -Wuninitialized -Wshadow -Wwrite-strings -Wconversion -Wunreachable-code -D_POSIX_SOURCE

# COVERAGE_FLAGS := -fPIC -fprofile-arcs -ftest-coverage
# COVERAGE_DIR := coverage-report

# RM := rm -rf

# # DIRECTORIES
# SRC_DIR := src
# SRC_FILES := ${wildcard ${SRC_DIR}/*.c}

# TEST_DIR := test
# TEST_FILES := ${wildcard ${TEST_DIR}/*.c}

# UNIT_DIR := unity

# LIBS_DIR := libs
# LIBS_FILES := ${wildcard ${SRC_DIR}/*.*}

# OBJ_DIR := obj
# OBJ_FILES := ${patsubst ${SRC_DIR}/%.c, ${OBJ_DIR}/%.o, ${SRC_FILES}}

# # build
# BIN_DIR := bin
# BIN_FILES := ${BIN_DIR}/main


# TEST_OBJ_DIR := testsobj
# TEST_OBJ_FILES := ${patsubst ${TEST_DIR}/%.c, ${TEST_OBJ_DIR}/%.o, ${TEST_FILES}}

# # TODO Add public test files



# # COMPILE OBJECT FILES INTO EXECUTABLE
# build: ${OBJ_FILES} ## Build the project
# 	${CC} ${FLAGS} ${OBJ_FILES} -o ${BIN_FILES}

# build-test: ${TEST_OBJ_FILES} ## Build the tests
# 	${CC} ${FLAGS} ${TEST_OBJ_FILES} ${OBJ_FILES} -o ${BIN_FILES}

# test: build-test
# 	echo

# # This build and instrument using the COVERAGE
# # build: main.o foo.o test.o ## Make build
# # 	$(CC) $(COVERAGE_FLAGS) -o main main.o foo.o test.o

# # Automatically compile the source flags into OBJ_FILES
# ${OBJ_DIR}/%.o: ${SRC_DIR}/%.c
# 	@${CC} ${FLAGS} -c $< -o $@
# # 	$(CC) $(COVERAGE_FLAGS) -c -Wall -Werror main.c

# # REMOVE TMP FILES
# .PHONY: clean
# clean: ## Clean all generate files
# 	$(RM) ${BIN_DIR}/* ${OBJ_DIR}/* 2>/dev/null || true
# 	$(RM) $(COVERAGE_DIR)

# # $(RM) main *.out *.o *.so *.gcno *.gcda *.gcov lcov-report gcovr-report



# coverage: ## Run code coverage
# 	gcov ${SRC_DIR}

# # gcov main.c foo.c test.c

# # TODO Check if paths are OK here!
# report-coveraget: coverage ## Generate coverage report using lcov
# 	mkdir $(COVERAGE_DIR)
# 	lcov --capture --directory . --output-file $(COVERAGE_DIR)/coverage.info
# 	genhtml $(COVERAGE_DIR)/coverage.info --output-directory $(COVERAGE_DIR)


# ##### UNTESTED
# # # RUN THE EXECUTABLE
# # run: build
# # 	./${BIN_FILES}




