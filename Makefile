.DEFAULT_GOAL   := all

.PHONY: all
all: deps compile

.PHONY: compile
compile:
	mix compile

.PHONY: clean-all
clean-all: clean

.PHONY: clean
clean:
	mix clean

.PHONY: test
test:
	mix test

.PHONY: deps
deps:
	mix deps.get

.PHONY: shell
shell:
	iex -S mix
