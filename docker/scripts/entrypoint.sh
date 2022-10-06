#!/usr/bin/env sh

# set docker socker group
groupmod -g $(stat -c '%g' /var/run/docker.sock) docker
chgrp docker /var/run/docker.sock
chown -R doomguy:doomguy /run/host-services

# workdir
cd workdir

# run all concurent commands
exec sudo -u doomguy "$@"
