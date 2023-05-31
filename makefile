.PHONY: all clear

SRCS := $(wildcard */*.v)
TESTBENCH := $(wildcard */testbenches/$(target)_tb.v)

all:
	iverilog -o vvp/$(target) $(SRCS) ${TESTBENCH}

clear:
	rm vvp/*