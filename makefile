build:
	flutter build web -t example/main.dart

.PHONY: clean
clean:
	rm -rf --interactive=never build

.PHONY: run
run:
	flutter run -d chrome --no-hot example/main.dart

deploy: build
	firebase deploy

.PHONY: test
test:
	flutter test

~/.pub-cache/bin/pana:
	dart pub global activate pana

.PHONY: pana
pana: ~/.pub-cache/bin/pana
	~/.pub-cache/bin/pana --exit-code-threshold 0
