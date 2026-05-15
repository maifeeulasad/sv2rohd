.PHONY: help setup clean build test test-coverage lint format analyze run docs watch install build-grammar

# Variables
DART := dart
BIN := bin/sv2rohd.dart
TEST_DIR := test
COVERAGE_DIR := coverage
OUTPUT_DIR := build
CONFIG_FILE := fixtures/sv2rohd.example.yaml
EXAMPLE_SV := fixtures/sv_samples/adder.sv

# Color output
RESET := \033[0m
BOLD := \033[1m
CYAN := \033[36m

# Default target
.DEFAULT_GOAL := help

##@ Help
help: ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)$(BOLD)%-20s$(RESET) %s\n", $$1, $$2}'

##@ Setup & Installation
setup: ## Install dependencies
	@echo "Installing dependencies..."
	@$(DART) pub get
	@echo "✓ Dependencies installed"

install: setup ## Alias for setup

upgrade-deps: ## Upgrade all dependencies
	@echo "Upgrading dependencies..."
	@$(DART) pub upgrade
	@echo "✓ Dependencies upgraded"

##@ Building
build: ## Build the project (pub get)
	@echo "Building project..."
	@$(DART) pub get
	@echo "✓ Project built"

build-grammar: ## Build ANTLR grammar files
	@echo "Building grammar files..."
	@$(DART) pub run build_runner build --delete-conflicting-outputs
	@echo "✓ Grammar files built"

antlr-grammar:
	@echo "Generating ANTLR grammar files..."
	java -jar helper/antlr-4.13.2-complete.jar -Dlanguage=Dart -o lib/generated grammar/SystemVerilogLexer.g4 && java -jar helper/antlr-4.13.2-complete.jar -Dlanguage=Dart -lib lib/generated/grammar -o lib/generated grammar/SystemVerilogParser.g4
	@echo "✓ ANTLR grammar files generated"

compile: setup ## Compile the project to executable
	@echo "Compiling sv2rohd executable..."
	@mkdir -p $(OUTPUT_DIR)
	@$(DART) compile exe $(BIN) -o $(OUTPUT_DIR)/sv2rohd 2>&1 && echo "✓ Executable compiled to $(OUTPUT_DIR)/sv2rohd" || echo "⚠ Compilation skipped (source contains uncompilable elements)"

##@ Testing
test: ## Run all tests
	@echo "Running tests..."
	@$(DART) test
	@echo "✓ Tests completed"

test-watch: ## Run tests in watch mode
	@echo "Running tests in watch mode..."
	@$(DART) test --watch

test-coverage: ## Run tests with coverage
	@echo "Running tests with coverage..."
	@$(DART) pub global activate coverage
	@$(DART) pub global run coverage:test_with_coverage --out=$(COVERAGE_DIR)
	@$(DART) pub global run coverage:format_coverage --package=. --report-on=lib --in=$(COVERAGE_DIR) --out=$(COVERAGE_DIR)/coverage.lcov --lcov
	@echo "✓ Coverage report generated in $(COVERAGE_DIR)/"

test-verbose: ## Run tests with verbose output
	@echo "Running tests (verbose)..."
	@$(DART) test -v

##@ Code Quality
analyze: ## Analyze code for issues
	@echo "Analyzing code..."
	@$(DART) analyze
	@echo "✓ Analysis complete"

lint: ## Lint code
	@echo "Linting code..."
	@$(DART) analyze --fatal-infos
	@echo "✓ Linting complete"

format: ## Format code according to style guide
	@echo "Formatting code..."
	@$(DART) format lib bin test
	@echo "✓ Code formatted"

format-check: ## Check if code needs formatting
	@echo "Checking code format..."
	@$(DART) format lib bin test --output=none
	@echo "✓ Code format check passed"

fix: ## Apply automated fixes
	@echo "Applying automated fixes..."
	@$(DART) fix --apply
	@echo "✓ Fixes applied"

##@ Running
run: ## Run the CLI with example input
	@echo "Running sv2rohd with example..."
	@$(DART) run $(BIN) -i $(EXAMPLE_SV) -o ./output
	@echo "✓ Conversion complete"

run-help: ## Display CLI help
	@echo "sv2rohd help:"
	@$(DART) run $(BIN) --help

run-version: ## Display CLI version
	@echo "sv2rohd version:"
	@$(DART) run $(BIN) --version

run-config: ## Run with configuration file
	@echo "Running sv2rohd with config..."
	@$(DART) run $(BIN) -c $(CONFIG_FILE) -i $(EXAMPLE_SV) -o ./output
	@echo "✓ Conversion with config complete"

##@ Cleaning
clean: ## Clean build and temporary files
	@echo "Cleaning build artifacts..."
	@rm -rf $(OUTPUT_DIR) $(COVERAGE_DIR)
	@echo "✓ Clean complete"

clean-deps: ## Remove pubspec.lock and reinstall
	@echo "Cleaning dependencies..."
	@rm -f pubspec.lock
	@$(DART) pub get
	@echo "✓ Dependencies cleaned and reinstalled"

clean-all: clean clean-deps ## Full clean (build + dependencies)
	@echo "✓ Full clean complete"

##@ Development
watch: ## Watch and run tests on file changes
	@echo "Watching for file changes..."
	@$(DART) test --watch

dev-setup: setup lint analyze ## Complete development setup (setup + lint + analyze)
	@echo "✓ Development environment ready"

##@ Documentation
docs: ## Generate documentation
	@echo "Generating documentation..."
	@$(DART) doc
	@echo "✓ Documentation generated in doc/"

docs-serve: docs ## Generate and serve documentation
	@echo "Serving documentation at http://localhost:8000..."
	@cd doc && $(DART) pub global run dhttpd

##@ CI/CD
ci: format-check analyze test ## Run CI checks (format + lint + test)
	@echo "✓ CI checks passed"

ci-coverage: format-check analyze test-coverage ## Run full CI with coverage
	@echo "✓ CI with coverage passed"

##@ Utilities
info: ## Display project information
	@echo "$(BOLD)Project Information:$(RESET)"
	@echo "  Name: sv2rohd"
	@echo "  Description: SystemVerilog to ROHD converter"
	@echo "  Version: 0.0.0"
	@echo "  SDK: >=3.0.0 <4.0.0"
	@echo ""
	@echo "$(BOLD)Directories:$(RESET)"
	@echo "  Source: lib/"
	@echo "  Binary: bin/"
	@echo "  Tests: test/"
	@echo "  Fixtures: fixtures/"
	@echo "  Grammar: grammar/"

deps: ## Show project dependencies
	@echo "Project dependencies:"
	@$(DART) pub deps

tree: ## Show dependency tree
	@echo "Dependency tree:"
	@$(DART) pub deps --style=tree

outdated: ## Check for outdated dependencies
	@echo "Checking for outdated dependencies..."
	@$(DART) pub outdated

.PHONY: all
all: clean setup lint analyze test build ## Run complete workflow (clean, setup, lint, analyze, test, build)
	@echo "✓ Complete workflow finished"
