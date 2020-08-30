.PHONY: deps compile test

default: deps compile test

deps:
	scripts/dep.sh Olical aniseed origin/develop

compile:
	rm -rf lua
	deps/aniseed/scripts/compile.sh
	deps/aniseed/scripts/embed.sh aniseed kkslider

test:
	rm -rf test/lua
	deps/aniseed/scripts/test.sh
