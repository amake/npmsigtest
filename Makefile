name := sigtermtest
slim-image := $(name)-slim
alpine-image := $(name)-alpine

.PHONY: all
all: test

.PHONY: build-slim
build-slim:
	docker build -t $(slim-image) -f Dockerfile.slim .

.PHONY: build-alpine
build-alpine:
	docker build -t $(alpine-image) -f Dockerfile.alpine .

.PHONY: test
test: test-slim test-alpine

.PHONY: test-slim
test-slim: build-slim
	docker run --rm --name $(slim-image) $(slim-image) & \
	sleep 3 && \
	docker kill -s TERM $(slim-image) && wait

.PHONY: test-alpine
test-alpine: build-alpine
	docker run --rm --name $(alpine-image) $(alpine-image) & \
	sleep 3 && \
	docker kill -s TERM $(alpine-image) && wait
