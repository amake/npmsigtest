name := sigtermtest

variants := alpine slim slim-bash slim-busybox

.PHONY: all
all: test

define build_one
  .PHONY: build-$(1)
  build-$(1):
	docker build -t $$(name)-$(1) -f Dockerfile.$(1) .
endef

$(foreach _,$(variants),$(eval $(call build_one,$(_))))

.PHONY: test
test: test-local $(foreach _,$(variants),test-$(_))

.PHONY: test-local
test-local:
	npm run start & \
	sleep 3 && \
	kill -s TERM $$!

define test_one
  .PHONY: test-$(1)
  test-$(1): build-$(1)
	docker run --rm --name $$(name)-$(1) $$(name)-$(1) & \
	sleep 3 && \
	docker kill -s TERM $$(name)-$(1) && wait
endef

$(foreach _,$(variants),$(eval $(call test_one,$(_))))

