deps := pubspec.lock

build: deps
	flutter build web -t example/main.dart

.PHONY: clean
clean:
	rm -rf --interactive=never build

.PHONY: deps
deps: $(deps)

.PHONY: run
run: deps
	flutter run -d chrome --no-hot example/main.dart

deploy: build
	firebase deploy

.PHONY: test
test: deps
	flutter test

.PHONY: pana
pana: ~/.pub-cache/bin/pana
	~/.pub-cache/bin/pana . --no-warning --exit-code-threshold 0

# Tool-based outputs
$(deps): pubspec.yaml
	flutter pub get

~/.pub-cache/bin/pana:
	dart pub global activate pana