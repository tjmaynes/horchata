install_dependencies:
	dotnet restore

test: build
	dotnet test

build:
	dotnet build	

run:
	dotnet run --project ./src/Horchata.CLI/Horchata.CLI.csproj

deploy:
	@ echo "Coming soon!"

ship_it: install_dependencies test