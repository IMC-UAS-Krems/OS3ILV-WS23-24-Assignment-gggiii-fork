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
CLEANUP = rm -rf
MKDIR = mkdir -p
GCC = gcc

TARGET_EXTENSION=out

# Project Structure
PATHU = unity/src/
PATHS = src/
# Personal tests go here
PATHT = test/
# Public tests go here
PATHPT = public/test/
PATHB = build/
PATHD = build/depends/
PATHO = build/objs/
PATHR = build/results/
PATHC = build/coverage

BUILD_PATHS = $(PATHB) $(PATHD) $(PATHO) $(PATHR)

# Test source
SRCT = $(wildcard $(PATHT)*.c)
# Public Test source
SRCPT = $(wildcard $(PATHPT)*.c)


COMPILE = $(GCC) -c
COMPILE_WITH_COVERAGE = $(GCC) -fPIC -fprofile-arcs -ftest-coverage -c
LINK = $(GCC) -fPIC -fprofile-arcs -ftest-coverage 
DEPEND = $(GCC) -MM -MG -MF

CFLAGS = -I. -I$(PATHU) -I$(PATHS) -pedantic -Wall -Werror -Wuninitialized -Wshadow -Wwrite-strings -Wconversion -Wunreachable-code -D_POSIX_SOURCE -DTEST

# This assume that tests follow the Naming Convention Test<MODULE_NAME>.
# For example, TestBlah.c, where Blah matches the file Blah.c
RESULTS = $(patsubst $(PATHT)Test%.c,$(PATHR)Test%.txt,$(SRCT))
PRESULTS = $(patsubst $(PATHPT)PublicTest%.c,$(PATHR)PublicTest%.txt,$(SRCPT))

PASSED = `grep -s PASS $(PATHR)*.txt`
FAIL = `grep -s FAIL $(PATHR)*.txt`
IGNORE = `grep -s IGNORE $(PATHR)*.txt`

LCOV := $(shell command -v lcov 2> /dev/null)
CLANG_FORMAT := $(shell command -v clang-format 2> /dev/null)
UNITY := $(shell [[ -d $(PATHU) ]] && echo "Unity")

###### Declare Phonies

.PHONY: help
.PHONY: test
.PHONY: deps
.PHONY: clean

###### Targets start here 

help: ## Makefile help
	@echo "Makefile Location: $(MKFILE_DIR)"
	@echo "Working Directory: $(WORKING_DIR)"
	@echo "Available Commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


test: $(BUILD_PATHS) $(RESULTS) $(PRESULTS) ## Visualize the test results
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
	git submodule add https://github.com/ThrowTheSwitch/Unity.git unity
endif


dirs: $(PATHB) $(PATHD) $(PATHO) $(PATHR) ## Create build directories
	@echo "Done"


clean: ## Clean temp files
	$(CLEANUP) $(PATHO)
	$(CLEANUP) $(PATHB)*.$(TARGET_EXTENSION)
	$(CLEANUP) $(PATHR)*.txt
	$(CLEANUP) $(PATHC)


lint: deps ## Reformat (Lint) the source code with clang-format
	clang-format -i --style=LLVM $(PATHS)%.c $(PATHS)%.h


coverage: deps ## Compute code coverage and generate the report
	gcov $(PATHO)/*.gcda
	$(CLEANUP) $(PATHC)
	mkdir $(PATHC)
	lcov --capture --directory . --output-file $(PATHC)/coverage.info
	genhtml $(PATHC)/coverage.info --output-directory $(PATHC)


######
$(PATHR)%.txt: $(PATHB)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

# Build Tests
$(PATHB)Test%.$(TARGET_EXTENSION): $(PATHO)Test%.o $(PATHO)%.o $(PATHO)unity.o #$(PATHD)Test%.d
	$(LINK) -o $@ $^

# Build Public Tests
$(PATHB)PublicTest%.$(TARGET_EXTENSION): $(PATHO)PublicTest%.o $(PATHO)%.o $(PATHO)unity.o #$(PATHD)Test%.d
	$(LINK) -o $@ $^

# Compile Tests
$(PATHO)%.o:: $(PATHT)%.c 
	$(COMPILE) $(CFLAGS) $< -o $@

# Compile Public Tests
$(PATHO)%.o:: $(PATHPT)%.c 
	$(COMPILE) $(CFLAGS) $< -o $@

# Build Source - Note that we add coverage instrumentation here
$(PATHO)%.o:: $(PATHS)%.c
	$(COMPILE_WITH_COVERAGE) $(CFLAGS) $< -o $@

# Build Unity
$(PATHO)%.o:: $(PATHU)%.c $(PATHU)%.h
	$(COMPILE) $(CFLAGS) $< -o $@

# Build Depedency
$(PATHD)%.d:: $(PATHT)%.c
	$(DEPEND) $@ $<

# Make sure build directories are there
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