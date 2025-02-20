build:
	flutter build web -t example/main.dart

.PHONY: clean
clean:
	rm -rf build

.PHONY: run
run:
	flutter run -d chrome example/main.dart

deploy: build
	firebase deploy
