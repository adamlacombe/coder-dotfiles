#!/bin/bash

mkdir -p $HOME/.local/share/code-server/User
cp keybindings.json $HOME/.local/share/code-server/User/keybindings.json
cp settings.json $HOME/.local/share/code-server/User/settings.json

myArray=("GitHub.copilot-chat" "GitHub.copilot")
for p in ${myArray[@]};
do
  P="$(cut -d'.' -f1 <<<"$p")"
  E="$(cut -d'.' -f2 <<<"$p")"
  DIR="$p"
  if [ ! -d $DIR ] || [ ! "$(ls -A $DIR)" ]; then
    echo "fetching $p to $(pwd)"

    if [ ! -f "$(pwd)/$p.vsix" ]; then
      curl "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$P/vsextensions/$E/latest/vspackage" \
      -H 'Upgrade-Insecure-Requests: 1' \
      -H 'DNT: 1' \
      -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36' \
      -H "Referer: https://marketplace.visualstudio.com/items?itemName=$p" \
      --compressed --output "$(pwd)/$p.vsix"

      sleep 3
    else
      echo "File $(pwd)/$p.vsix already exists, skipping download."
    fi
  else
    echo "skipping $p"
  fi
done


# TODO possible hacky solution to install copilot chat in code-server
# sudo apt-get install zip
# unzip GitHub.copilot-chat.vsix -d GitHub.copilot-chat

# replace 1.81.0 with 1.76.0 in source files
# find GitHub.copilot-chat -type f -exec sed -i 's/1\.81\.0/1.76.0/g' {} +

# zip up the folder
# cd GitHub.copilot-chat && zip -r ../GitHub.copilot-chat-final.vsix * && cd ..

code-server --install-extension GitHub.copilot.vsix

# code-server --install-extension GitHub.copilot-chat-final.vsix
# rm -rf ./GitHub.copilot-chat
