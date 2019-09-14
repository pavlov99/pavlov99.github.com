HUGO=docker run --rm -it --volume $(CURDIR):/src --publish 1313:1313 --user hugo jguyomard/hugo-builder:0.55-extras hugo

.PHONY: help
# target: help - Display callable targets
help:
	@egrep "^# target:" [Mm]akefile | sed -e 's/^# target: //g'

.PHONY: run
run: clean
	$(HUGO) server --buildDrafts --watch --bind=0.0.0.0

.PHONY: build
build: clean
	$(HUGO)

.PHONY: clean
clean:
	@rm -rf public

.PHONY: deploy
deploy: clean
	@echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
	@git checkout develop
	$(HUGO)
	@git add -A
	@git commit -m "rebuilding site '$(shell date)'"
	@git push origin develop
	@git subtree push --prefix=public git@github.com:pavlov99/pavlov99.github.com.git master
