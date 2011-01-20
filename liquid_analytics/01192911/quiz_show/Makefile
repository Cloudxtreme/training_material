.PHONY: deps test

all: deps compile

deps:
	@./rebar get-deps

compile: deps
	@./rebar compile

clean:
	@./rebar clean

distclean: clean
	@./rebar delete-deps

test: compile
	@./rebar skip_deps=true eunit

start: all
	@exec erl -pa ebin deps/*/ebin -boot start_sasl -s quiz_show
