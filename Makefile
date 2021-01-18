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