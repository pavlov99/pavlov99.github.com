.PHONY: all
all:
	@npm install
	@bower install


.PHONY: help
# target: help - Display callable targets
help:
	@egrep "^# target:" [Mm]akefile | sed -e 's/^# target: //g'

.PHONY: run
run:
	@hugo server --buildDrafts --watch --bind=0.0.0.0
