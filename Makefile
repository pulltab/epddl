.DEFAULT_GOAL   := all

.PHONY: all
all: deps compile

.PHONY: compile
compile:
	rebar3 compile

.PHONY: clean-all
clean-all: clean

.PHONY: clean
clean:
	rebar3 clean

.PHONY: test
test: check

.PHONY: check
check:
	rebar3 eunit

.PHONY: deps
deps:
	rebar3 deps
