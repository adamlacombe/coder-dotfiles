#!/bin/bash

# encrypt files with aes-256-cbc cipher using openssl
# Get the content of the id_ed25519 file, remove line breaks, headers, and footers.
PASSWORD=$(sed -e '1d' -e '$d' ~/.ssh/id_ed25519 | tr -d '\n')

if [ "$1" == "-e" ];
then
    if [ -f "secrets.sh" ];
    then
        openssl aes-256-cbc -a -e -salt -in "secrets.sh" -out "secrets.sh.aes" -pass pass:"$PASSWORD" -pbkdf2 -iter 100000
        if [ $? -eq 0 ];
        then
            echo "Encrypted file: secrets.sh.aes"
        else
            echo "Error: Could not encrypt file!"    
        fi
    else
       echo "This file does not exist!" 
    fi

elif [ "$1" == "-d" ];
then
    if [ -f "secrets.sh.aes" ];
    then
        openssl aes-256-cbc -a -d -salt -in "secrets.sh.aes" -out "secrets.sh" -pass pass:"$PASSWORD" -pbkdf2 -iter 100000
        if [ $? -eq 0 ];
        then
            echo "Decrypted file: secrets.sh"
        else
            echo "Error: Could not decrypt file! Check password!"
        fi
    else
        echo "This file does not exist!" 
    fi

else 
    echo "This software uses openssl for encrypting files with the aes-256-cbc cipher"
    echo "Usage for encrypting: ./manage-secrets -e [file]"
    echo "Usage for decrypting: ./manage-secrets -d [file]"
fi
