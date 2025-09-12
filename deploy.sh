#!/bin/bash
set -e

cd /var/www/sunu-blog

# --- Colors ---
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

log() {
  echo -e "${CYAN}[$(date '+%Y-%m-%d %H:%M:%S')]${RESET} $1"
}

fail() {
  echo -e "${RED}❌ ERROR:${RESET} $1"
  echo -e "${RED}Deployment aborted.${RESET}"
  exit 1
}

rollback() {
  echo -e "${RED}⚠️ Build failed — rolling back to previous commit...${RESET}"
  git reset --hard HEAD@{1} || echo -e "${RED}Rollback failed. Manual intervention required.${RESET}"
  if [ "$STASHED" = true ]; then
    git stash pop || echo -e "${YELLOW}⚠️ Could not reapply stashed changes. Resolve manually.${RESET}"
  fi
}

STASHED=false

# --- Deployment ---
log "${YELLOW}💾 Checking for local changes...${RESET}"
if ! git diff --quiet || ! git diff --cached --quiet; then
  log "${YELLOW}📥 Stashing local changes before pull...${RESET}"
  git stash push -m "Auto-stash before deploy"
  STASHED=true
fi

log "${YELLOW}🔄 Pulling latest code...${RESET}"
if ! git pull --rebase; then
  fail "Git pull failed. Check your repo or network connection."
fi

if [ "$STASHED" = true ]; then
  log "${YELLOW}📤 Reapplying stashed changes...${RESET}"
  if ! git stash pop; then
    log "${RED}⚠️ Conflicts detected while applying stash. Resolve manually!${RESET}"
    exit 1
  fi
fi

log "${YELLOW}📦 Installing dependencies...${RESET}"
if ! pnpm install --frozen-lockfile; then
  fail "Failed to install dependencies."
fi

log "${YELLOW}🏗️ Building project...${RESET}"
if ! pnpm build; then
  rollback
  fail "Build failed. Rolled back to previous commit."
fi

log "${GREEN}✅ Build complete. Starting preview server...${RESET}"
echo -e "${CYAN}------------------------------------------${RESET}"
echo -e "${CYAN}Server running! Press CTRL+C to stop.${RESET}"
echo -e "${CYAN}------------------------------------------${RESET}"

# Run preview in foreground (doesn't close)
exec pnpm run preview --host
