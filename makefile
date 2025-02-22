build: pubspec.lock
	flutter build web -t example/main.dart

.PHONY: clean
clean:
	rm -rf --interactive=never build pubspec.lock

.PHONY: run
run: pubspec.lock
	flutter run -d chrome --no-hot example/main.dart

deploy: build
	firebase deploy

.PHONY: test
test: pubspec.lock
	flutter test

.PHONY: pana
pana: ~/.pub-cache/bin/pana
	~/.pub-cache/bin/pana . --no-warning --exit-code-threshold 0

# Tool-based outputs
pubspec.lock: pubspec.yaml
	flutter pub get

~/.pub-cache/bin/pana:
	dart pub global activate pana