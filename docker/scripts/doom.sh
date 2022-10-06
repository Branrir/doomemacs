#!/usr/bin/env bash

# docker-desktop
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_HOME=/home/doomguy
VOLUMES="-v ${HOME}/.kube:${DOCKER_HOME}/.kube \
         -v ${HOME}/.docker:${DOCKER_HOME}/.docker \
         -v ${HOME}/.ssh:${DOCKER_HOME}/.ssh  \
         -v ${HOME}/.gitconfig:${DOCKER_HOME}/.gitconfig \
         -v ${HOME}:${DOCKER_HOME}/workdir \
         -v ${DOCKER_SOCKET}.raw:${DOCKER_SOCKET} \
         -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock"
VARS="-e TERM=xterm-256color"

# populate args if present
if [ $# -ne 0 ]; then
    if [ "${PWD}" != "${HOME}" ]; then
        ARG=$(pwd | sed "s,${HOME}/,,")/$1
    else
        ARG=$1
    fi
fi

# execute container
docker run -it -h emacs ${VARS} ${VOLUMES} branrir/doom-emacs ${ARG}
