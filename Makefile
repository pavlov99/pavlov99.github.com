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

.PHONY: deploy
deploy:
	@echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
	@git checkout develop
	@hugo
	@git add -A
	@git commit -m "rebuilding site '$(shell date)'"
	@git push origin develop
	@git subtree push --prefix=public git@github.com:pavlov99/pavlov99.github.com.git master
