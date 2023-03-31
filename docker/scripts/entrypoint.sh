#!/usr/bin/env sh

# set docker socker group
groupmod -g $(stat -c '%g' /var/run/docker.sock) docker
chgrp docker /var/run/docker.sock
chown -R doomguy:doomguy /run/host-services

#git file permissions fix
git config --add --system core.fileMode false

# run all concurent commands
exec sudo --preserve-env=SSH_AUTH_SOCK -i -u doomguy "$@"
