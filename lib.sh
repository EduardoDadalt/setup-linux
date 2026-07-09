#!/usr/bin/env bash
# Helpers compartilhados por install.sh e pelos módulos em modules/.
# Não executa nada sozinho; é feito para ser "sourceado".

# --- logging -----------------------------------------------------------------
if [ -t 1 ]; then
  _C_RESET=$'\033[0m'; _C_BLUE=$'\033[34m'; _C_GREEN=$'\033[32m'
  _C_YELLOW=$'\033[33m'; _C_RED=$'\033[31m'; _C_BOLD=$'\033[1m'
else
  _C_RESET=; _C_BLUE=; _C_GREEN=; _C_YELLOW=; _C_RED=; _C_BOLD=
fi

log()  { printf '%s==>%s %s\n'  "$_C_BLUE$_C_BOLD" "$_C_RESET" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$_C_GREEN" "$_C_RESET" "$*"; }
warn() { printf '%swarn%s %s\n' "$_C_YELLOW" "$_C_RESET" "$*" >&2; }
err()  { printf '%s err%s %s\n' "$_C_RED" "$_C_RESET" "$*" >&2; }

# --- utilitários -------------------------------------------------------------

# has_cmd <comando> -> 0 se existe no PATH
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# clone_or_pull <url> <dir>: clona se ausente, senão atualiza com fast-forward.
clone_or_pull() {
  local url="$1" dir="$2"
  if [ -d "$dir/.git" ]; then
    ok "já existe: $dir (git pull --ff-only)"
    git -C "$dir" pull --ff-only --quiet || warn "não foi possível atualizar $dir"
  else
    log "clonando $url -> $dir"
    git clone --depth 1 "$url" "$dir"
  fi
}

# link_tree <src_dir> <dest_dir>: para cada arquivo em src_dir, cria um symlink
# no caminho correspondente em dest_dir (preservando subpastas). Se o destino já
# existir e não for symlink, faz backup em <arquivo>.bak-<timestamp> antes.
link_tree() {
  local src="$1" dest="$2" f rel target dir
  local stamp; stamp="$(date +%Y%m%d-%H%M%S)"
  # find -print0 para lidar com nomes com espaço; caminhos relativos a $src
  while IFS= read -r -d '' f; do
    rel="${f#"$src"/}"
    target="$dest/$rel"
    dir="$(dirname "$target")"
    mkdir -p "$dir"
    if [ -L "$target" ]; then
      # já é symlink: reaponta (idempotente)
      ln -sfn "$f" "$target"
      ok "link  ~/${rel}"
    elif [ -e "$target" ]; then
      mv "$target" "$target.bak-$stamp"
      warn "backup ~/${rel} -> ${rel}.bak-$stamp"
      ln -sfn "$f" "$target"
      ok "link  ~/${rel}"
    else
      ln -sfn "$f" "$target"
      ok "link  ~/${rel}"
    fi
  done < <(find "$src" -type f -print0)
}
