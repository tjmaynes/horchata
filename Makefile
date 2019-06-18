PROJECT_NAME := $(shell gcloud info --format='value(config.project)')
SERVICE_ACCOUNT_NAME := spinnaker-storage-account
SERVICE_ACCOUNT_EMAIL := $(shell gcloud iam service-accounts list --filter="displayName:$(SERVICE_ACCOUNT_NAME)" --format='value(email)')
SERVICE_USER := $(shell gcloud config get-value account)
CLUSTER_NAME := trying-out-kubernetes
CLUSTER_REGION := us-central1
CLUSTER_VERSION := 1.12.8-gke.6
HELM_VERSION := 2.7.2
SPINNAKER_VERSION := 0.3.5
SPINNAKER_TIMEOUT := 600
SPINNAKER_CONFIG_FILE := spinnaker-config.yaml
SPINNAKER_SERVICE_ACCOUNT_JSON_FILE := spinnaker-sa.json
SPINNAKER_STORAGE_BUCKET := $(PROJECT_NAME)-spinnaker-config
SPINNAKER_USERNAME := test-user
SPINNAKER_EMAIL := "test@example.com"
SPINNAKER_DECK_POD=$(shell kubectl get pods --namespace default -l "component=deck" -o jsonpath="{.items[0].metadata.name}")
PORT := 8080

.enable_kubernetes_api:
	gcloud services enable container.googleapis.com
	@echo "$@ - Waiting for service_account to be created"
	sleep 20
	@echo "$@ - Finished!"
	touch $@

.initialize_kubernetes: .enable_kubernetes_api
	gcloud container clusters create $(CLUSTER_NAME) \
		--username="" \
		--node-version=$(CLUSTER_VERSION) \
		--machine-type=n1-standard-1 \
		--image-type=COS \
		--num-nodes=1 \
		--enable-autorepair \
		--enable-autoscaling \
		--enable-stackdriver-kubernetes \
		--min-nodes=1 \
		--max-nodes=2 \
		--region=$(CLUSTER_REGION) \
		--project=$(PROJECT_NAME) \
		--preemptible \
		--scopes="https://www.googleapis.com/auth/cloud-platform"
	touch $@

.initialize_service_account:
	gcloud iam service-accounts create spinnaker-storage-account \
    	--display-name spinnaker-storage-account
	@echo "$@ - Waiting for service_account to be created"
	sleep 20
	@echo "$@ - Finished!"
	touch $@

.initialize_iam_policies: .initialize_service_account
	gcloud projects add-iam-policy-binding $(PROJECT_NAME) \
		--role roles/storage.admin \
		--member serviceAccount:$(SERVICE_ACCOUNT_EMAIL)
	touch $@

.install_local_helm:
	curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v$(HELM_VERSION)-darwin-amd64.tar.gz
	tar -zxvf helm-v$(HELM_VERSION)-darwin-amd64.tar.gz
	chmod +x ./darwin-amd64/helm
	mv ./darwin-amd64/helm /usr/local/bin/
	rm -rf ./darwin-amd64
	touch $@

.install_tiller_server:
	kubectl create clusterrolebinding user-admin-binding \
		--clusterrole=cluster-admin \
		--user=$(SERVICE_USER)
	kubectl create serviceaccount tiller --namespace kube-system
	kubectl create clusterrolebinding tiller-admin-binding \
		--clusterrole=cluster-admin \
		--serviceaccount=kube-system:tiller
	touch $@

.initialize_helm: .install_local_helm .install_tiller_server
	helm init --service-account=tiller --upgrade
	helm repo update
	touch $@

.create_spinnaker_key:
	gcloud iam service-accounts keys create $(SPINNAKER_SERVICE_ACCOUNT_JSON_FILE) \
		--iam-account $(SERVICE_ACCOUNT_EMAIL)
	touch $@

.create_spinnaker_storage_bucket:
	gsutil mb -c regional -l $(CLUSTER_REGION) gs://$(SPINNAKER_STORAGE_BUCKET)
	touch $@

.create_spinnaker_config: .create_spinnaker_key .create_spinnaker_storage_bucket
	SPINNAKER_CONFIG_FILE_NAME=$(SPINNAKER_CONFIG_FILE) \
	SPINNAKER_STORAGE_BUCKET=$(SPINNAKER_STORAGE_BUCKET) \
	SPINNAKER_USERNAME=$(SPINNAKER_USERNAME) \
	SPINNAKER_EMAIL=$(SPINNAKER_EMAIL) \
	SPINNAKER_SERVICE_ACCOUNT_JSON_FILE=$(SPINNAKER_SERVICE_ACCOUNT_JSON_FILE) \
	./scripts/create-spinnaker-config.sh 

.install_spinnaker: .install_kubernetes .create_spinnaker_config
	kubectl create clusterrolebinding \
		--clusterrole=cluster-admin \
		--serviceaccount=default:default spinnaker-admin
	helm install -n cd stable/spinnaker \
		-f $(SPINNAKER_CONFIG_FILE) \
		--timeout $(SPINNAKER_TIMEOUT) \
		--version $(SPINNAKER_VERSION) \
		--namespace spinnaker
	touch $@

.install_kubernetes: .initialize_iam_policies .initialize_kubernetes .initialize_helm
	touch $@

setup_port_forwarding:
	kubectl port-forward --namespace default $(SPINNAKER_DECK_POD) $(PORT):9000

.delete_cluster:
	gcloud container clusters delete $(CLUSTER_NAME) --region $(CLUSTER_REGION)

.delete_service_accounts:
	gcloud iam service-accounts delete $(SERVICE_ACCOUNT_EMAIL)

.disable_kubernetes_api:
	gcloud services disable container.googleapis.com 

.delete_storage_buckets:
	gsutil rb -f gs://$(SPINNAKER_STORAGE_BUCKET)

install_dependencies: .install_spinnaker

clean: .delete_cluster .disable_kubernetes_api .delete_storage_buckets .delete_service_accounts
	rm -rf .install_* .create_* .initialize_* .enable_* .setup_*
	rm -rf helm* $(SPINNAKER_CONFIG_FILE) $(SPINNAKER_SERVICE_ACCOUNT_JSON_FILE)
