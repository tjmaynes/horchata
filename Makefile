KUBECTL_VERSION := $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
SERVICE_USER    := some-user

include .env
export $(shell sed 's/=.*//' .env)

install_dependencies:
	chmod +x ./scripts/install_dependencies.sh
	./scripts/install_dependencies.sh

setup:
	chmod +x ./scripts/setup.sh
	./scripts/setup.sh

clean:
	rm -rf bin/ charts/

define run_setup
	chmod +x ./$1/setup.sh
	./$1/setup.sh
endef
