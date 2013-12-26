ENV_DIR=$(CURDIR)/.env
PYTHON=$(ENV_DIR)/bin/python
PYVERSION=$(shell pyversions --default)
RED=\033[0;31m
NC=\033[0m

.PHONY: all
all:	$(ENV_DIR)
	@pelican _src/

.PHONY: help
# target: help - Display callable targets
help:
	@egrep "^# target:" [Mm]akefile | sed -e 's/^# target: //g'

.PHONY: clean
# target: clean - Display callable targets
clean:
	@rm -rf build dist docs/_build
	@find . -name "*.py[co]" -delete
	@find . -name "*.deb" -delete
	@find . -name "*.orig" -delete

.PHONY: run
run:
	$(PYTHON) -m SimpleHTTPServer

$(ENV_DIR): requirements.txt
	[ -d $(ENV_DIR) ] || virtualenv --no-site-packages $(ENV_DIR)
	$(ENV_DIR)/bin/pip install -M -r requirements.txt
	touch $(ENV_DIR)
