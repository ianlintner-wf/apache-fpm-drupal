CURRENT_DIRECTORY := $(shell pwd)

build:
	@docker build --tag=espressodev/apache-fpm-drupal:latest $(CURRENT_DIRECTORY)

build-no-cache:
	@docker build --no-cache --tag=espressodev/apache-fpm-drupal:latest $(CURRENT_DIRECTORY)

.PHONY: build

