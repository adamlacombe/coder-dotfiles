#!/bin/bash

mkdir -p $HOME/.local/share/code-server/User
cp keybindings.json $HOME/.local/share/code-server/User/keybindings.json
cp settings.json $HOME/.local/share/code-server/User/settings.json

# Check if install_vscode_extensions exists
if ! command -v install_vscode_extensions &> /dev/null; then
    echo "install_vscode_extensions command not found! Installing..."
    
    # Download the script from the gist
    wget https://gist.github.com/adamlacombe/102d223df7a3d659b5055fd3e0c85c4f/raw/install_vscode_extensions.sh -O /tmp/install_vscode_extensions.sh
    
    # Make sure it's executable
    chmod +x /tmp/install_vscode_extensions.sh
    
    # Move it to a directory in the PATH, or you can symlink it as shown before
    sudo mv /tmp/install_vscode_extensions.sh /usr/local/bin/install_vscode_extensions

    echo "install_vscode_extensions installed successfully!"
else
    echo "install_vscode_extensions is already installed."
fi

# install extensions.json
install_vscode_extensions

# set git author
echo 'export GIT_AUTHOR_NAME="Adam LaCombe"' >> /home/${USER}/.bashrc
echo 'export GIT_COMMITTER_NAME="Adam LaCombe"' >> /home/${USER}/.bashrc
echo 'export GIT_AUTHOR_EMAIL="git@adamlacombe.com"' >> /home/${USER}/.bashrc
echo 'export GIT_COMMITTER_EMAIL="git@adamlacombe.com"' >> /home/${USER}/.bashrc
source ~/.bashrc
git config --global user.name "Adam LaCombe"
git config --global user.email "git@adamlacombe.com"

