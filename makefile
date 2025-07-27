.EXPORT_ALL_VARIABLES:
NAME = forge
DirName ?= build
ProjectUrl = "https://github.com/benbenbang/homebrew-forge"
BuildTime = $(shell date -u '+%Y-%m-%d_%H:%M:%S')
BuildCommit = $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
VERSION = $(shell git describe --abbrev=0 --tags 2>/dev/null || echo $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown"))
DEFAULT_CORES = 1
TREE_LEVEL ?= 5

# Determine the OS and ARCH if not provided
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Default OS and ARCH
ifeq ($(UNAME_S), Darwin)
	DEFAULT_GOOS = darwin
else ifeq ($(UNAME_S), Linux)
	DEFAULT_GOOS = linux
else ifeq ($(UNAME_S), Windows)
	DEFAULT_GOOS = windows
else
	DEFAULT_GOOS = $(UNAME_S)
endif

# Determine the ARCH if not provided
ifeq ($(UNAME_M), x86_64)
	DEFAULT_GOARCH = amd64
else ifeq ($(UNAME_M), arm64)
	DEFAULT_GOARCH = arm64
else
	DEFAULT_GOARCH = $(UNAME_M)
endif

.PHONY: verify
## verify dependencies
verify:
	@if ! type bunster &>/dev/null; then \
		echo "bunster is not installed."; \
		echo "please run: "; \
		echo "brew tap yassinebenaid/bunster"; \
		echo "brew install bunster"; \
	fi
	@if ! type direnv &>/dev/null; then \
		echo "direnv is not installed."; \
		echo "please run: "; \
		echo "brew install direnv"; \
	fi

.PHONY: build
## Build forge binary
build: verify
	@bunster build ./bin/forge.sh -o ./bin/forge && chmod +x ./bin/forge


.PHONY: clean
## Remove build files and caches
clean:
	@rm -rf ./bin/forge 2>/dev/null || true
	@if type go &>/dev/null; then \
		go clean -cache; \
		go clean -testcache; \
	fi
	@echo "Cleaned build artifacts and caches"

.PHONY: tree
## Print file structure
tree:
	@tree . -I 'artifacts' -I 'vendor' -I 'templates' -I 'logs' -I 'stacks' -I 'scripts' -I 'build' -L $(TREE_LEVEL)

.DEFAULT_GOAL := help

help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
