HUGO=docker run --rm -it --volume $(CURDIR):/src --publish 1313:1313 --user hugo --name=hugo jguyomard/hugo-builder:0.55-extras hugo

.PHONY: help
# target: help - Display callable targets
help:
	@egrep "^# target:" [Mm]akefile | sed -e 's/^# target: //g'

# Convert "make hugo" parameters to "hugo" arguments so make would not treat them as targets
# Usage example: make hugo --help (--help is not a make target but hugo's parameter)
# See link: https://stackoverflow.com/questions/2214575/passing-arguments-to-make-run#answer-14061796
# If the first argument is "hugo"...
ifeq (hugo, $(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "hugo"
  RUN_ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: hugo
# target: hugo - Execute hugo command with given parameters
hugo:
	$(HUGO) $(RUN_ARGS)

.PHONY: run
# target: run - Run development server
run: clean
	$(HUGO) server --buildDrafts --watch --bind=0.0.0.0

.PHONY: build
# target: build - Build a production version of the site
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
