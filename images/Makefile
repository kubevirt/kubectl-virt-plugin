REPO?=quay.io/kubevirtci
TAG?=latest
BUILDER_IMAGE_NAME=kubectl-virt-builder
TEST_INSTALL_IMAGE_NAME=kubectl-krew
CONTAINER_ENGINE?=docker

all: update_image_sha

.PHONY: build_builder
build_builder:
	$(CONTAINER_ENGINE) build . -f builder/Dockerfile -t $(REPO)/$(BUILDER_IMAGE_NAME):$(TAG)

.PHONY: push_builder
push_builder: build_builder
	$(CONTAINER_ENGINE) push $(REPO)/$(BUILDER_IMAGE_NAME):$(TAG)

.PHONY: build_test_install
build_test_install:
	$(CONTAINER_ENGINE) build . -f test_install/Dockerfile -t $(REPO)/$(TEST_INSTALL_IMAGE_NAME):$(TAG)

.PHONY: push_test_install
push_test_install: build_builder build_test_install
	$(CONTAINER_ENGINE) push $(REPO)/$(TEST_INSTALL_IMAGE_NAME):$(TAG)

.PHONY: push_all
push_all: push_builder push_test_install

.PHONY: update_image_sha
update_image_sha: push_all
	./update-image-sha.sh $(REPO)/$(TEST_INSTALL_IMAGE_NAME)
