# Instala o Oh My Zsh (modo não-interativo, sem trocar shell nem mexer no .zshrc)
# e clona os plugins custom usados no .zshrc.

if [ -d "$HOME/.oh-my-zsh" ]; then
  ok "oh-my-zsh já instalado"
else
  log "instalando oh-my-zsh"
  # RUNZSH=no: não abre um zsh no fim. KEEP_ZSHRC=yes: não sobrescreve o .zshrc
  # (o nosso .zshrc entra como symlink no módulo 50).
  RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ok "oh-my-zsh instalado"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

log "plugins custom do zsh"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull https://github.com/Aloxaf/fzf-tab                     "$ZSH_CUSTOM/plugins/fzf-tab"
