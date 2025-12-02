.PHONY: compile debug test quicktest clean all


PYTHON ?= python
ROOT = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))


all: compile


clean:
	rm -fr dist/ doc/_build/
	rm -fr async_gaussdb/gaussdbproto/*.c async_gaussdb/gaussdbproto/*.html
	rm -fr async_gaussdb/gaussdbproto/codecs/*.html
	rm -fr async_gaussdb/gaussdbproto/*.so
	rm -fr async_gaussdb/protocol/*.c async_gaussdb/protocol/*.html
	rm -fr async_gaussdb/protocol/*.so build *.egg-info
	rm -fr async_gaussdb/protocol/codecs/*.html
	find . -name '__pycache__' | xargs rm -rf


compile:
	env ASYNCGAUSSDB_BUILD_CYTHON_ALWAYS=1 $(PYTHON) -m pip install -e .


debug:
	env ASYNCGAUSSDB_DEBUG=1 $(PYTHON) -m pip install -e .

test:
	PYTHONASYNCIODEBUG=1 $(PYTHON) -m unittest -v tests.suite
	$(PYTHON) -m unittest -v tests.suite
	USE_UVLOOP=1 $(PYTHON) -m unittest -v tests.suite


testinstalled:
	cd "$${HOME}" && $(PYTHON) $(ROOT)/tests/__init__.py


quicktest:
	$(PYTHON) -m unittest -v tests.suite


htmldocs:
	$(PYTHON) -m pip install -e .[docs]
	$(MAKE) -C docs html
