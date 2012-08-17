.PHONY: deps

all: compile

deps: erl_deps

compile: erl_compile python_compile java_compile

clean: erl_clean python_clean java_clean

distclean: clean
	rm -rf dist

release: python_release java_release

test: erl_test

# Erlang-specific build steps
erl_deps:
	@./rebar get-deps

erl_compile:
	@./rebar compile

erl_clean:
	@./rebar clean

erl_test: erl_compile
	@./rebar eunit skip_deps=true

# Python specific build steps
python_compile:
	@echo "==> Python"
	@./setup.py build

python_clean:
	@echo "==> Python"
	@./setup.py clean

python_release: python_compile
	@python2.6 setup.py bdist_egg upload
	@python2.7 setup.py bdist_egg upload

# Java specific build steps
java_compile:
	@echo "==> Java"
	@mvn install

java_clean:
	@echo "==> Java"
	@mvn clean

java_release: 
	@echo "==> Java"
ifeq ($(RELEASE_GPG_KEYNAME),)
	@echo "RELEASE_GPG_KEYNAME must be set to release/deploy"
else
	@mvn clean
	@mvn deploy	
endif
	

