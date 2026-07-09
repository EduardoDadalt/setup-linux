# Atualiza o sistema e instala os pacotes de packages.txt via pacman.
# Sourceado por install.sh (REPO, log/ok/warn e has_cmd já disponíveis).

log "atualizando o sistema (pacman -Syu)"
sudo pacman -Syu --noconfirm

# Lê packages.txt ignorando comentários e linhas vazias.
mapfile -t _pkgs < <(grep -vE '^\s*(#|$)' "$REPO/packages.txt")

if [ "${#_pkgs[@]}" -gt 0 ]; then
  log "instalando pacotes: ${_pkgs[*]}"
  sudo pacman -S --needed --noconfirm "${_pkgs[@]}"
  ok "pacotes em dia"
else
  warn "packages.txt vazio — nada a instalar"
fi
unset _pkgs
