#!/bin/bash

mkdir -p $HOME/.local/share/code-server/User
cp keybindings.json $HOME/.local/share/code-server/User/keybindings.json
cp settings.json $HOME/.local/share/code-server/User/settings.json

install_extension(){
  publisher="$1"
  extension_name="$2"
  version="$3"
  download_url="https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${extension_name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
  wget "$download_url" -O "${extension_name}.VSIX"
  /tmp/code-server/bin/code-server --install-extension "${extension_name}.VSIX"
  rm "${extension_name}.VSIX"
}

# 1.2.63
install_extension Codeium codeium latest

# set git author
echo 'export GIT_AUTHOR_NAME="Adam LaCombe"' >> /home/${USER}/.bashrc
echo 'export GIT_COMMITTER_NAME="Adam LaCombe"' >> /home/${USER}/.bashrc
echo 'export GIT_AUTHOR_EMAIL="git@adamlacombe.com"' >> /home/${USER}/.bashrc
echo 'export GIT_COMMITTER_EMAIL="git@adamlacombe.com"' >> /home/${USER}/.bashrc
source ~/.bashrc
git config --global user.name "Adam LaCombe"
git config --global user.email "git@adamlacombe.com"

