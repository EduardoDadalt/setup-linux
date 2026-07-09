# Ajustes de sistema: locale e shell padrão.

# --- locale ------------------------------------------------------------------
if grep -q '^LANG=C.UTF-8' /etc/locale.conf 2>/dev/null; then
  ok "locale já é C.UTF-8"
else
  log "definindo LANG=C.UTF-8 em /etc/locale.conf"
  echo 'LANG=C.UTF-8' | sudo tee /etc/locale.conf >/dev/null
fi

# --- shell padrão = zsh ------------------------------------------------------
# Compara caminhos canônicos: no Arch /usr/sbin é symlink de /usr/bin (usrmerge),
# então /usr/sbin/zsh e /usr/bin/zsh são o mesmo binário.
_zsh="$(command -v zsh || true)"
_cur_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [ -z "$_zsh" ]; then
  warn "zsh não encontrado — pulei a troca de shell"
elif [ "$(readlink -f "$_cur_shell" 2>/dev/null)" = "$(readlink -f "$_zsh" 2>/dev/null)" ]; then
  ok "shell padrão já é zsh"
else
  # Usa o caminho de zsh registrado em /etc/shells (exigido pelo chsh) quando existir.
  _target="$(grep -m1 '/zsh$' /etc/shells 2>/dev/null || echo "$_zsh")"
  log "definindo zsh como shell padrão"
  sudo chsh -s "$_target" "$USER"
  ok "shell padrão agora é zsh (efetivo no próximo login)"
  unset _target
fi
unset _zsh _cur_shell
