sudo apt update && sudo apt upgrade -y
sudo apt install -y zsh unzip 

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install bun
curl -fsSL https://bun.sh/install | bash

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash