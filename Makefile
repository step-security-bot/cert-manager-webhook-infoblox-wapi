OS ?= $(shell go env GOOS)
ARCH ?= $(shell go env GOARCH)

IMAGE_NAME := sarg3nt/cert-manager-webhook-infoblox-wapi
IMAGE_TAG := 1.6.0

OUT := $(shell pwd)/_out

KUBEBUILDER_VERSION=3.13.0

$(shell mkdir -p "$(OUT)")

test: _test/kubebuilder
	TEST_ASSET_ETCD=./_test/kubebuilder/bin/etcd \
	TEST_ASSET_KUBE_APISERVER=./_test/kubebuilder/bin/kube-apiserver \
	TEST_ASSET_KUBECTL=./_test/kubebuilder/bin/kubectl \
	go test -v .

_test/kubebuilder:
	curl -fsSL https://github.com/kubernetes-sigs/kubebuilder/releases/download/v$(KUBEBUILDER_VERSION)/kubebuilder_$(KUBEBUILDER_VERSION)_$(OS)_$(ARCH).tar.gz -o kubebuilder-tools.tar.gz
	mkdir -p _test/kubebuilder
	tar -xvf kubebuilder-tools.tar.gz
	mv kubebuilder_$(KUBEBUILDER_VERSION)_$(OS)_$(ARCH)/bin _test/kubebuilder/
	rm kubebuilder-tools.tar.gz
	rm -R kubebuilder_$(KUBEBUILDER_VERSION)_$(OS)_$(ARCH)

clean: clean-kubebuilder

clean-kubebuilder:
	rm -Rf _test/kubebuilder

build:
	docker build -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

push: 
	docker tag "$(IMAGE_NAME):$(IMAGE_TAG)" "$(IMAGE_NAME):latest"
	docker push "$(IMAGE_NAME):$(IMAGE_TAG)"
	docker push "$(IMAGE_NAME):latest"

.PHONY: rendered-manifest.yaml
rendered-manifest.yaml:
	helm template \
		cert-manager-webhook-infoblox-wapi \
		--set image.repository=$(IMAGE_NAME) \
		--set image.tag=$(IMAGE_TAG) \
		deploy/cert-manager-webhook-infoblox-wapi > "$(OUT)/rendered-manifest.yaml"
