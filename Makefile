DOCKER_USERNAME ?= wurly
DOCKER_IMAGE_NAME ?= builder_nuttx_esp32

BUILD_ARGS := --build-arg IMAGE_NAME=${DOCKER_IMAGE_NAME}

.PHONY: build
build:
	docker build -t $(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME):latest $(BUILD_ARGS) .

.PHONY: push
push:
	echo ${DOCKER_PASSWORD} | docker login -u $(DOCKER_USERNAME) --password-stdin
	docker push $(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME):latest

.PHONY: ci-cd
ci-cd: build push

.PHONY: build-tag
build-tag:
	docker build -t $(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME):$(TAG) $(BUILD_ARGS) .

.PHONY: push-tag
push-tag:
	echo ${DOCKER_PASSWORD} | docker login -u $(DOCKER_USERNAME) --password-stdin
	docker push $(DOCKER_USERNAME)/$(DOCKER_IMAGE_NAME):$(TAG)
