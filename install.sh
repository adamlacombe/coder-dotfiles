#!/bin/bash

# vscode settings
mkdir -p $HOME/.local/share/code-server/User
cp keybindings.json $HOME/.local/share/code-server/User/keybindings.json
cp settings.json $HOME/.local/share/code-server/User/settings.json


# set git author
mkdir -p ~/.ssh
ssh_key=$(curl --request GET \
        --url "${CODER_AGENT_URL}api/v2/workspaceagents/me/gitsshkey" \
        --header "Coder-Session-Token: ${CODER_AGENT_TOKEN}")

jq --raw-output ".public_key" <<< "$ssh_key"  > ~/.ssh/id_ed25519.pub
jq --raw-output ".private_key" <<< "$ssh_key" > ~/.ssh/id_ed25519
chmod -R 400 ~/.ssh/id_ed25519
chmod -R 400 ~/.ssh/id_ed25519.pub
git config --global gpg.format ssh
git config --global commit.gpgsign true
git config --global user.signingkey ~/.ssh/id_ed25519
git config --global user.name "Adam LaCombe"
git config --global user.email "git@adamlacombe.com"
echo 'export GIT_AUTHOR_NAME="Adam LaCombe"' >> /home/${USER}/.bashrc
echo 'export GIT_COMMITTER_NAME="Adam LaCombe"' >> /home/${USER}/.bashrc
echo 'export GIT_AUTHOR_EMAIL="git@adamlacombe.com"' >> /home/${USER}/.bashrc
echo 'export GIT_COMMITTER_EMAIL="git@adamlacombe.com"' >> /home/${USER}/.bashrc

# decrypt secret envs
PASSWORD=$(sed -e '1d' -e '$d' ~/.ssh/id_ed25519 | tr -d '\n')
openssl aes-256-cbc -a -d -salt -in "secrets.sh.aes" -out "secrets.sh" -pass pass:"$PASSWORD" -pbkdf2 -iter 100000
if [ $? -eq 0 ];
then
    echo "Decrypted file: secrets.sh"
    cat secrets.sh >> ~/.bashrc
else
    echo "Error: Could not decrypt file! Check password!"
fi

source ~/.bashrc

# set codeium apiKey
mkdir -p ~/.codeium
cat >~/.codeium/config.json <<EOL
{"apiKey": "$CODEIUM_CONFIG_API_KEY"}
EOL

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
