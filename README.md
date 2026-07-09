# setup-linux

Setup reproduzível do meu ambiente de dev no **Arch Linux (WSL2)**.
Um comando reinstala tudo numa máquina nova; os dotfiles são versionados via
**symlink**, então dá pra editar e acompanhar as mudanças no git.

## O que ele instala

- **Pacman** (`packages.txt`): `zsh git github-cli fzf zoxide unzip wget socat bubblewrap base-devel vim`
- **AUR**: `yay` (compilado a partir do AUR)
- **Shell**: oh-my-zsh + plugins `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`
- **Node**: nvm → node LTS, bun, pnpm
- **AI CLIs**: Claude Code, Codex
- **Dotfiles** (symlink → `~/`): `.zshrc`, `.gitconfig`, `.config/git/ignore`
- **Sistema**: locale `C.UTF-8`, zsh como shell padrão

## Bootstrap numa máquina nova

```bash
sudo pacman -S --needed git          # único pré-requisito
git clone https://github.com/eduardodadalt/setup-linux.git ~/repo/setup-linux
cd ~/repo/setup-linux
./install.sh
```

Depois, reabra o terminal (ou `exec zsh`) e faça os logins que **não** ficam no repo:

```bash
gh auth login          # autentica o GitHub CLI (grava token em ~/.config/gh)
claude                 # login do Claude Code
codex                  # login do Codex
```

## Uso

```bash
./install.sh           # roda todos os módulos (idempotente — pode repetir)
./install.sh 40        # roda só o módulo que começa com "40" (ex.: ferramentas)
```

Os módulos ficam em `modules/` e rodam em ordem numérica:

| Módulo             | O que faz                                              |
|--------------------|--------------------------------------------------------|
| `10-packages.sh`   | `pacman -Syu` + instala tudo de `packages.txt`         |
| `20-yay.sh`        | compila e instala o `yay` (AUR) se faltar              |
| `30-oh-my-zsh.sh`  | instala oh-my-zsh + plugins custom                     |
| `40-tools.sh`      | nvm/node, bun, pnpm, Claude Code, Codex                |
| `50-dotfiles.sh`   | cria os symlinks de `dotfiles/` para `~/`              |
| `60-system.sh`     | locale + define zsh como shell padrão                  |

Tudo é idempotente: cada passo checa se já está feito antes de agir.

## Editando os dotfiles

Os arquivos em `dotfiles/` são a **fonte da verdade** e são linkados para `~/`.
Editar o arquivo no repo já vale no shell (é symlink) — não precisa copiar nada:

```bash
$EDITOR ~/repo/setup-linux/dotfiles/.zshrc   # ou edite ~/.zshrc, é o mesmo arquivo
exec zsh                                      # recarrega
git -C ~/repo/setup-linux commit -am "zsh: novo alias"
git -C ~/repo/setup-linux push
```

Para adicionar um novo dotfile ao controle de versão: coloque-o em `dotfiles/`
espelhando o caminho relativo a `~/` (ex.: `dotfiles/.config/foo/bar.conf`) e
rode `./install.sh 50`.

Para adicionar um pacote: acrescente o nome em `packages.txt` e rode `./install.sh 10`.

## Segredos

Nada com credencial entra no repo. Tokens ficam só na máquina, gerados pelos
logins manuais acima:

- `~/.config/gh/hosts.yml` / `config.yml` — token do `gh`
- `~/.claude.json` — Claude Code
- `~/.codex/` — Codex
