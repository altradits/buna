# ==============================================================================
# YEBENTE BUNA - AUTOMATION MAKEFILE
# Premium Authentic Ethiopian Coffee & Cultural Ceremony E-Commerce Platform
# ==============================================================================

PORT ?= 3000
RAILS_ENV ?= development

# Userspace Ruby & Gem Environment
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY ?= YES
export PATH := /opt/homebrew/opt/ruby@3.2/bin:/opt/homebrew/lib/ruby/gems/3.2.0/bin:/opt/homebrew/opt/postgresql@16/bin:$(HOME)/.local/bin:$(PATH)
ifneq ($(wildcard $(HOME)/.local/lib/ruby-dev-hook.rb),)
export RUBYOPT ?= -r$(HOME)/.local/lib/ruby-dev-hook.rb
export GEM_HOME ?= $(HOME)/.local/share/gem/ruby/3.2.0
export GEM_PATH ?= $(HOME)/.local/share/gem/ruby/3.2.0:/var/lib/gems/3.2.0
export LIBRARY_PATH := $(HOME)/.local/lib/ruby-dev-headers/lib/x86_64-linux-gnu:$(LIBRARY_PATH)
export LD_LIBRARY_PATH := $(HOME)/.local/lib/ruby-dev-headers/lib/x86_64-linux-gnu:$(LD_LIBRARY_PATH)
endif

.PHONY: run dev stop kill-port setup seed console status check-deps help

## help: Display available targets
help:
	@echo "Yebente Buna (የበንቴ ቡና) - Management Commands"
	@echo "==============================================="
	@echo "  make run        - Kill any process on port $(PORT), check dependencies, and start the app"
	@echo "  make dev        - Kill port $(PORT) and start with Hotwire/Tailwind asset watcher"
	@echo "  make stop       - Kill any process currently listening on port $(PORT)"
	@echo "  make kill-port  - Force kill any process holding port $(PORT) and remove PID files"
	@echo "  make check-deps - Verify whether gem bundle is installed"
	@echo "  make setup      - Prepare database and seed product taxonomy"
	@echo "  make seed       - Seed product taxonomy (Sidamo, Yirgacheffe, Jebenas, Frankincense)"
	@echo "  make console    - Launch Rails console in $(RAILS_ENV) mode"
	@echo "  make status     - Inspect any process currently bound to port $(PORT)"

## kill-port: Terminate any process occupying port $(PORT) and remove stale server.pid
kill-port:
	@echo "==> Checking and releasing port $(PORT)..."
	@PID=$$(lsof -ti:$(PORT) 2>/dev/null); \
	if [ -n "$$PID" ]; then \
		echo "Found active process(es) on port $(PORT) with PID: $$PID"; \
		kill -9 $$PID 2>/dev/null || true; \
		echo "Successfully terminated process(es) on port $(PORT)."; \
	else \
		fuser -k $(PORT)/tcp 2>/dev/null || true; \
		echo "Port $(PORT) is clear."; \
	fi
	@if [ -f tmp/pids/server.pid ]; then \
		echo "Removing stale tmp/pids/server.pid..."; \
		rm -f tmp/pids/server.pid; \
	fi

## check-deps: Check if gems are installed
check-deps:
	@if ! bundle check >/dev/null 2>&1; then \
		echo "==> Resolving gem dependencies..."; \
		bundle install; \
	fi

## run: Kill any process on port $(PORT), verify dependencies, then start Rails
run: kill-port check-deps
	@echo "==> Starting Yebente Buna application on http://localhost:$(PORT) (Env: $(RAILS_ENV))..."
	@PORT=$(PORT) bin/rails server -b 0.0.0.0 -p $(PORT)

## dev: Kill port $(PORT) and start development environment
dev: kill-port check-deps
	@echo "==> Launching Yebente Buna development environment..."
	@bin/dev

## stop: Stop any running application instances
stop: kill-port
	@echo "==> All processes on port $(PORT) have been stopped."

## status: Check port usage
status:
	@echo "==> Port $(PORT) status:"
	@lsof -i :$(PORT) || echo "No process currently listening on port $(PORT)."

## setup: Initial setup
setup:
	@echo "==> Running full application setup..."
	@bin/setup

## seed: Seed the database with the complete Ethiopian Buna taxonomy
seed:
	@echo "==> Seeding Ethiopian coffee and ceremony taxonomy..."
	@bin/rails db:seed

## console: Rails console
console:
	@bin/rails console
