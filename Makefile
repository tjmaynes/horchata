CLUSTER_NAME := learning-kubernetes
CLUSTER_REGION := us-central1
CLUSTER_VERSION := 1.14.10-gke.27
CLUSTER_NODE_VERSION := 1.15.9-gke.26
GCLOUD_VERSION := 287.0.0
HELM_VERSION := 2.16.5
ISTIO_CHART_VERSION := 1.5.1
ISTIO_NAMESPACE := istio-system
PROJECT_NAME = $(shell ./bin/gcloud/bin/gcloud info --format='value(config.project)')
SERVICE_USER = $(shell ./bin/gcloud/bin/gcloud config get-value account)

install_dependencies:
	chmod +x ./scripts/install_dependencies.sh
	./scripts/install_dependencies.sh \
	$(GCLOUD_VERSION) \
	$(HELM_VERSION)

define run_setup
	chmod +x ./$1/setup.sh
	./$1/setup.sh
endef

.setup_gcloud_dependencies:
	$(call run_setup,gcloud) \
	$(PROJECT_NAME) \
	$(CLUSTER_NAME) \
	$(CLUSTER_REGION) \
	$(CLUSTER_VERSION) \
	$(CLUSTER_NODE_VERSION)
	touch $@

.install_helm_on_k8s:
	$(call run_setup,helm) \
	$(SERVICE_USER)
	touch $@

.install_istio_on_k8s:
	$(call run_setup,istio) \
	$(ISTIO_CHART_VERSION) \
	$(ISTIO_NAMESPACE)
	touch $@

workstation: install_dependencies
	./bin/gcloud/bin/gcloud init

setup_cluster: install_dependencies .setup_gcloud_dependencies .install_helm_on_k8s .install_istio_on_k8s

.remove_install_files:
	rm -rf .install_* .setup_* charts/

teardown_cluster: install_dependencies .remove_install_files
	chmod +x ./scripts/install_dependencies.sh
	./scripts/teardown.sh \
	$(PROJECT_NAME) \
	$(CLUSTER_NAME) \
	$(CLUSTER_REGION)

clean: .remove_install_files
	rm -rf bin/