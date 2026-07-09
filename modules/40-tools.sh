# Ferramentas instaladas via scripts oficiais (fora do pacman).
# Cada bloco checa o caminho de instalação (não o PATH) para ser idempotente,
# já que estas ferramentas só entram no PATH pelo .zshrc, não neste shell bash.
#
# Os instaladores mexem em arquivos de rc e PATH e podem tropeçar em
# 'set -euo pipefail'; por isso relaxamos as flags dentro deste módulo.
set +eu

# --- nvm + node LTS ----------------------------------------------------------
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  ok "nvm já instalado"
else
  log "instalando nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Checa se já existe alguma versão de node instalada pelo nvm (não depende do PATH).
if [ -n "$(ls -A "$NVM_DIR/versions/node" 2>/dev/null)" ]; then
  ok "node já instalado ($(ls -1 "$NVM_DIR/versions/node" | tr '\n' ' '))"
else
  log "instalando node LTS via nvm"
  nvm install --lts
fi

# --- bun ---------------------------------------------------------------------
if [ -x "$HOME/.bun/bin/bun" ]; then
  ok "bun já instalado"
else
  log "instalando bun"
  curl -fsSL https://bun.sh/install | bash
fi

# --- pnpm (via script oficial; popula ~/.local/share/pnpm como o .zshrc espera) ---
_pnpm_home="${PNPM_HOME:-$HOME/.local/share/pnpm}"
if [ -x "$_pnpm_home/bin/pnpm" ] || [ -x "$_pnpm_home/pnpm" ]; then
  ok "pnpm já instalado"
else
  log "instalando pnpm"
  curl -fsSL https://get.pnpm.io/install.sh | sh -
fi
unset _pnpm_home

# --- Claude Code -------------------------------------------------------------
if [ -x "$HOME/.local/bin/claude" ]; then
  ok "claude já instalado"
else
  log "instalando Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

# --- Codex -------------------------------------------------------------------
if [ -x "$HOME/.local/bin/codex" ]; then
  ok "codex já instalado"
else
  log "instalando Codex"
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

set -eu
