#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
#  Smart Insti App — Full Setup Script
#  Installs Node.js deps, Flutter SDK, and
#  project dependencies in one go.
# ─────────────────────────────────────────────

FLUTTER_DIR="$HOME/.flutter-sdk"
FLUTTER_BIN="$FLUTTER_DIR/bin"
FLUTTER_VERSION="stable"  # Change to a specific version if needed

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()    { echo -e "${CYAN}ℹ  $*${NC}"; }
success() { echo -e "${GREEN}✅ $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $*${NC}"; }
error()   { echo -e "${RED}❌ $*${NC}" >&2; }

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# ── 1. Check system dependencies ────────────

info "Checking system dependencies..."

check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    error "$1 is not installed."
    return 1
  fi
  return 0
}

MISSING=0

if ! check_cmd git; then
  error "Please install git first."
  MISSING=1
fi

if ! check_cmd curl && ! check_cmd wget; then
  error "Please install curl or wget."
  MISSING=1
fi

if ! check_cmd node; then
  warn "Node.js is not installed."
  warn "Install it from https://nodejs.org/ or via your package manager:"
  warn "  Arch:   sudo pacman -S nodejs npm"
  warn "  Ubuntu: sudo apt install nodejs npm"
  warn "  macOS:  brew install node"
  MISSING=1
fi

if ! check_cmd npm; then
  warn "npm is not installed (usually comes with Node.js)."
  MISSING=1
fi

if [ "$MISSING" -eq 1 ]; then
  error "Please install the missing system dependencies above, then re-run this script."
  exit 1
fi

success "System dependencies OK (git, node, npm)"

# ── 2. Install Flutter SDK ──────────────────

if command -v flutter &>/dev/null; then
  EXISTING_FLUTTER="$(command -v flutter)"
  success "Flutter already installed at $EXISTING_FLUTTER"
  flutter --version
else
  info "Flutter not found. Installing Flutter SDK to $FLUTTER_DIR..."

  if [ -d "$FLUTTER_DIR" ]; then
    warn "Directory $FLUTTER_DIR already exists but flutter not in PATH."
    warn "Adding existing installation to PATH."
  else
    info "Cloning Flutter SDK ($FLUTTER_VERSION channel)..."
    git clone --depth 1 --branch "$FLUTTER_VERSION" \
      https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi

  # Add to PATH for this session
  export PATH="$FLUTTER_BIN:$PATH"

  # Persist to shell profile
  SHELL_NAME="$(basename "$SHELL")"
  case "$SHELL_NAME" in
    zsh)  PROFILE="$HOME/.zshrc" ;;
    bash) PROFILE="$HOME/.bashrc" ;;
    fish) PROFILE="$HOME/.config/fish/config.fish" ;;
    *)    PROFILE="$HOME/.profile" ;;
  esac

  EXPORT_LINE="export PATH=\"$FLUTTER_BIN:\$PATH\""

  if [ "$SHELL_NAME" = "fish" ]; then
    EXPORT_LINE="set -gx PATH $FLUTTER_BIN \$PATH"
  fi

  if ! grep -qF "$FLUTTER_BIN" "$PROFILE" 2>/dev/null; then
    echo "" >> "$PROFILE"
    echo "# Flutter SDK" >> "$PROFILE"
    echo "$EXPORT_LINE" >> "$PROFILE"
    success "Added Flutter to PATH in $PROFILE"
    warn "Run 'source $PROFILE' or open a new terminal for PATH changes to take effect globally."
  else
    success "Flutter PATH entry already in $PROFILE"
  fi

  # Run flutter precache to download artifacts
  info "Running Flutter precache (downloading SDK artifacts)..."
  flutter precache

  success "Flutter SDK installed!"
  flutter --version
fi

# ── 3. Flutter doctor ───────────────────────

info "Running flutter doctor..."
flutter doctor --verbose || true
echo ""

# ── 4. Set up .env files ────────────────────

info "Setting up environment files..."

if [ ! -f "$PROJECT_ROOT/backend/.env" ]; then
  cp "$PROJECT_ROOT/backend/.env.example" "$PROJECT_ROOT/backend/.env"
  success "Created backend/.env from .env.example"
  warn "Edit backend/.env with your MongoDB URI and secrets before starting."
else
  success "backend/.env already exists"
fi

if [ ! -f "$PROJECT_ROOT/frontend/.env" ]; then
  cp "$PROJECT_ROOT/frontend/.env.example" "$PROJECT_ROOT/frontend/.env"
  success "Created frontend/.env from .env.example"
else
  success "frontend/.env already exists"
fi

# ── 5. Install backend dependencies ────────

info "Installing backend dependencies..."
cd "$PROJECT_ROOT/backend"
npm install
success "Backend dependencies installed"

# ── 6. Install frontend dependencies ───────

info "Installing frontend dependencies..."
cd "$PROJECT_ROOT/frontend"
flutter pub get
success "Frontend dependencies installed"

# ── 7. Done ─────────────────────────────────

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Setup complete! 🚀${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo "  Quick start:"
echo "    make dev              — Start backend (hot-reload)"
echo "    make start-frontend   — Run Flutter app"
echo "    make help             — See all commands"
echo ""
if ! command -v flutter &>/dev/null 2>&1; then
  warn "Remember to run: source $PROFILE"
fi
