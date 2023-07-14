name := sigtermtest
slim-image := $(name)-slim
alpine-image := $(name)-alpine

.PHONY: all
all: test

.PHONY: build-slim
build-slim:
	docker build -t $(slim-image) -f Dockerfile.slim .

.PHONY: build-slim-bash
build-slim-bash:
	docker build -t $(slim-image)-bash -f Dockerfile.slim-bash .

.PHONY: build-slim-busybox
build-slim-busybox:
	docker build -t $(slim-image)-busybox -f Dockerfile.slim-busybox .

.PHONY: build-alpine
build-alpine:
	docker build -t $(alpine-image) -f Dockerfile.alpine .

.PHONY: test
test: test-slim test-slim-bash test-slim-busybox test-alpine

.PHONY: test-slim
test-slim: build-slim
	docker run --rm --name $(slim-image) $(slim-image) & \
	sleep 3 && \
	docker kill -s TERM $(slim-image) && wait

.PHONY: test-slim-bash
test-slim-bash: build-slim-bash
	docker run --rm --name $(slim-image)-bash $(slim-image)-bash & \
	sleep 3 && \
	docker kill -s TERM $(slim-image)-bash && wait

.PHONY: test-slim-busybox
test-slim-busybox: build-slim-busybox
	docker run --rm --name $(slim-image)-busybox $(slim-image)-busybox & \
	sleep 3 && \
	docker kill -s TERM $(slim-image)-busybox && wait

.PHONY: test-alpine
test-alpine: build-alpine
	docker run --rm --name $(alpine-image) $(alpine-image) & \
	sleep 3 && \
	docker kill -s TERM $(alpine-image) && wait
