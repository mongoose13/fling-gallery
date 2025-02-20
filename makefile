build:
	flutter build web -t example/main.dart

.PHONY: clean
clean:
	rm -rf build

deploy: build
	firebase deploy
