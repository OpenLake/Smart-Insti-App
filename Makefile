.PHONY: help setup install install-backend install-frontend \
       start start-backend start-frontend \
       dev dev-backend dev-frontend \
       build-frontend clean clean-backend clean-frontend \
       lint-frontend setup-env

# ─────────────────────────────────────────────
#  Smart Insti App — Makefile
# ─────────────────────────────────────────────

FLUTTER := $(shell command -v flutter 2>/dev/null)
NPM     := $(shell command -v npm 2>/dev/null)

define check_npm
	@if [ -z "$(NPM)" ]; then echo "❌ npm not found. Install Node.js first."; exit 1; fi
endef

define check_flutter
	@if [ -z "$(FLUTTER)" ]; then echo "❌ flutter not found. Install Flutter SDK and add it to PATH."; exit 1; fi
endef

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ── Database (Docker) ───────────────────────

start-db: ## Start MongoDB in Docker (background)
	@docker run -d -p 27017:27017 --name smart-insti-mongo mongo:latest 2>/dev/null || docker start smart-insti-mongo
	@echo "✅ MongoDB started on port 27017"

stop-db: ## Stop MongoDB container
	@docker stop smart-insti-mongo
	@echo "🛑 MongoDB stopped"


# ── Full Setup (first time) ─────────────────

setup: ## First-time setup: install Flutter, deps, create .env files
	@bash setup.sh

# ── Install ──────────────────────────────────

install: install-backend install-frontend ## Install all dependencies

install-backend: ## Install backend (Node.js) dependencies
	$(call check_npm)
	cd backend && npm install

install-frontend: ## Install frontend (Flutter) dependencies
	$(call check_flutter)
	cd frontend && flutter pub get

# ── Start (production) ───────────────────────

start: start-backend ## Start backend server

start-backend: ## Start backend with node
	$(call check_npm)
	cd backend && npm start

start-frontend: ## Run Flutter app (debug mode)
	$(call check_flutter)
	cd frontend && flutter run

# ── Dev (hot-reload) ─────────────────────────

dev: dev-backend ## Start backend with nodemon (auto-reload)

dev-backend: ## Start backend with nodemon
	$(call check_npm)
	cd backend && npm run start-nodemon

dev-frontend: ## Run Flutter app in debug mode
	$(call check_flutter)
	cd frontend && flutter run

# ── Build ────────────────────────────────────

build-frontend: ## Build Flutter APK (release)
	$(call check_flutter)
	cd frontend && flutter build apk --release

build-frontend-ios: ## Build Flutter iOS app (release)
	$(call check_flutter)
	cd frontend && flutter build ios --release

build-frontend-web: ## Build Flutter web app (release)
	$(call check_flutter)
	cd frontend && flutter build web --release

# ── Lint / Analyze ───────────────────────────

lint-frontend: ## Run Flutter static analysis
	$(call check_flutter)
	cd frontend && flutter analyze

# ── Setup ────────────────────────────────────

setup-env: ## Create .env files from examples (won't overwrite existing)
	@test -f backend/.env || (cp backend/.env.example backend/.env && echo "✅ Created backend/.env")
	@test -f backend/.env && echo "⏭  backend/.env already exists" || true
	@test -f frontend/.env || (cp frontend/.env.example frontend/.env && echo "✅ Created frontend/.env")
	@test -f frontend/.env && echo "⏭  frontend/.env already exists" || true

# ── Clean ────────────────────────────────────

clean: clean-backend clean-frontend ## Remove all generated/installed files

clean-backend: ## Remove backend node_modules
	rm -rf backend/node_modules

clean-frontend: ## Remove Flutter build artifacts
	$(call check_flutter)
	cd frontend && flutter clean
