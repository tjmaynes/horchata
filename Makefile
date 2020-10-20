KUBECTL_VERSION := $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
SERVICE_USER    := some-user

include .env
export $(shell sed 's/=.*//' .env)

ensure_programs_installed:
	$(call ensure_program_exists,docker)
	$(call ensure_program_exists,kubectl)
	$(call ensure_program_exists,skaffold)

install_dependencies: ensure_programs_installed
	chmod +x ./scripts/install_dependencies.sh
	./scripts/install_dependencies.sh \
	$(KUBECTL_VERSION) \
	$(HELM_VERSION)

setup: ensure_programs_installed
	chmod +x ./scripts/setup.sh
	./scripts/setup.sh \
	$(SERVICE_USER) \
	$(ISTIO_CHART_VERSION) \
	$(ISTIO_NAMESPACE) \
	$(TILLER_NAMESPACE)

clean: remove_files
	rm -rf bin/ charts/

define run_setup
	chmod +x ./$1/setup.sh
	./$1/setup.sh
endef

define ensure_program_exists
command -v ${1} >/dev/null 2>&1 || { echo >&2 "Program '${1}' is not installed!"; exit 1; }
endef
