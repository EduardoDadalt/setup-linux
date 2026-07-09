# Instala o yay (AUR helper) compilando a partir do AUR, se ainda não existir.
# makepkg roda como usuário normal e chama sudo só na etapa de instalação.

if has_cmd yay; then
  ok "yay já instalado"
  return 0 2>/dev/null || true
else
  log "compilando yay a partir do AUR"
  # base-devel e git já vêm de packages.txt, mas garantimos aqui.
  sudo pacman -S --needed --noconfirm git base-devel

  _yaydir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$_yaydir"
  ( cd "$_yaydir" && makepkg -si --noconfirm )
  rm -rf "$_yaydir"
  unset _yaydir
  ok "yay instalado"
fi
