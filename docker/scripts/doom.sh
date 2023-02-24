#!/usr/bin/env bash

# docker-desktop
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_HOME=/home/doomguy
VARS="-e TERM=xterm-256color"

# populate args if present
if [ $# -ne 0 ]; then
    if [ "${PWD}" != "${HOME}" ]; then
        ARG=workdir/$(pwd | sed "s,${HOME}/,,")/$1
    else
        ARG=workdir/$1
    fi
fi

# if macos
if [[ $OSTYPE == 'darwin'* ]]; then
    VOLUMES="-v ${HOME}/.kube:${DOCKER_HOME}/.kube \
             -v ${HOME}/.docker:${DOCKER_HOME}/.docker \
             -v ${HOME}/.ssh:${DOCKER_HOME}/.ssh_host  \
             -v ${HOME}/.gitconfig:${DOCKER_HOME}/.gitconfig \
             -v ${HOME}/.config/glab-cli:${DOCKER_HOME}/.config/glab-cli \
             -v ${HOME}/.config/argocd:${DOCKER_HOME}/.config/argocd \
             -v ${HOME}:${DOCKER_HOME}/workdir \
             -v ${DOCKER_SOCKET}:${DOCKER_SOCKET} \
             -v ${HOME}/.zsh:${DOCKER_HOME}/.zsh_override"
else
    VOLUMES="-v ${HOME}/.kube:${DOCKER_HOME}/.kube \
             -v ${HOME}/.docker:${DOCKER_HOME}/.docker \
             -v ${HOME}/.ssh:${DOCKER_HOME}/.ssh  \
             -v ${HOME}/.gitconfig:${DOCKER_HOME}/.gitconfig \
             -v ${HOME}/.config/glab-cli:${DOCKER_HOME}/.config/glab-cli \
             -v ${HOME}/.config/argocd:${DOCKER_HOME}/.config/argocd \
             -v ${HOME}:${DOCKER_HOME}/workdir \
             -v ${DOCKER_SOCKET}:${DOCKER_SOCKET} \
             -v ${SSH_AUTH_SOCK}:/run/host-services/ssh-auth.sock \
             -v ${HOME}/.zsh:${DOCKER_HOME}/.zsh_override"
fi    

docker run -it -h emacs ${VARS} ${VOLUMES} branrir/doom-emacs ${ARG}
