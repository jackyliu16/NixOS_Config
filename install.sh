#!/bin/bash
# ubuntu setting

read -p "Enter Distribute Linux Version: " distribution
if [ $distribution = "ubuntu" ] 
then 
	echo "start ubuntu mirror configuration(china area)"
	sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
	sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
	sudo apt update
fi

# install nix package manager
echo "now we are running nix install for Single-user installation(WSL) or Multi-user installation (recommended)(wasn't wsl)"
read -p "Are you in WSL environment ?[y/n]" ifWSL
if [ ! $ifWSL -o "$ifWSL" = y]
then
sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install) --no-daemon
# TODO copy the file from /nix/nix.conf -> /etc/nix/nix.conf
# TODO to create some useful  ~/.config folder
else
sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install) --daemon	
fi

# source Nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install package
nix-env -iA \
	nixpkgs.zsh	\
	nixpkgs.antibody\
	nixpkgs.git	\
	nixpkgs.neovim	\
	nixpkgs.tmux	\
	nixpkgs.stow	\
	nixpkgs.yarn	\
	nixpkgs.fzf	\
	nixpkgs.ripgrep	\
	nixpkgs.bat	\
	nixpkgs.direnv	

# stow
stow git
stow zsh
stow nvim

# tell computer zsh is a available shell
command -v zsh | sudo tee -a /etc/shells

# using zsh as default shell
# TODO need to specify the single user installation
sudo chsh -s $(which zsh) $USER

echo "you should exit the terminal and create a new one"

# bundle zsh plugins
antibody bundle < ./.zsh_plugins.txt > ./.zsh_plugins.sh

# install vim-plug
curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim



