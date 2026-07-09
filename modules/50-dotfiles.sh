# Cria symlinks de dotfiles/ (que espelha a estrutura de $HOME) para ~/.
# O arquivo real fica no repo: editar aqui reflete no shell; git commit versiona.
# Arquivos pré-existentes que não sejam symlink viram backup .bak-<timestamp>.

log "linkando dotfiles em ~/"
link_tree "$REPO/dotfiles" "$HOME"
ok "dotfiles linkados"
