#!/bin/bash -

cp mkdtoplg /usr/local/bin

cp ~/.bash_profile ~/.bash_profile_bkg

if ! grep "#mkdtoplg" ~/.bash_profile; then
echo "#mkdtoplg\nalias mkdtoplg=\"/usr/local/bin/mkdtoplg\"" >> ~/.bash_profile
echo "source ~/.bash_profile"
fi

