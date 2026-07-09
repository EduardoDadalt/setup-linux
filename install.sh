#!/usr/bin/env bash
# Orquestrador de setup do Arch Linux (WSL2).
# Idempotente: pode rodar quantas vezes quiser sem quebrar nada.
#
# Uso:
#   ./install.sh            roda todos os módulos em ordem
#   ./install.sh 40         roda só o módulo cujo nome começa com "40"
set -euo pipefail

# Raiz do repo = diretório deste script (resolve mesmo via symlink).
REPO="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
export REPO

# shellcheck source=lib.sh
source "$REPO/lib.sh"

if [ "$(id -u)" -eq 0 ]; then
  err "não rode como root. O script usa 'sudo' apenas onde é necessário."
  exit 1
fi

filter="${1:-}"

log "setup-linux — raiz: $REPO"

shopt -s nullglob
for module in "$REPO"/modules/*.sh; do
  name="$(basename "$module")"
  if [ -n "$filter" ] && [[ "$name" != "$filter"* ]]; then
    continue
  fi
  log "módulo: $name"
  # shellcheck source=/dev/null
  source "$module"
done
shopt -u nullglob

log "concluído."
echo
echo "Próximos passos manuais (não versionados, contêm segredos):"
echo "  • gh auth login"
echo "  • login do Claude Code (claude) e do Codex (codex)"
echo "  • reabra o terminal (ou 'exec zsh') para carregar o novo shell/dotfiles"
