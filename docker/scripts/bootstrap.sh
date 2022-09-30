#!/usr/bin/env bash

# vars
read -p "Please enter doom-emacs repo path: " DOOM_REPO
SHELL=$(awk -F: -v user=$(whoami) '$1 == user {print $NF}' /etc/passwd)

if [ ${SHELL}="/bin/zsh" ]; then
    echo "adding alias to .zshrc"
    SHELL_RC=".zshrc"
elif [ ${SHELL}="/bin/bash" ]; then
    echo "adding alias to .bashrc"
    SHELL_RC=".bashrc"
fi

# add needed alias if not already present
grep -qxF "alias doom-emacs='${DOOM_REPO}/docker/scripts/doom.sh'" ${HOME}/.zshrc || echo -e "\n# Doom-emacs alias\nalias doom='${DOOM_REPO}/docker/scripts/doom.sh'" >> ${HOME}/.zshrc
