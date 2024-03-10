#!/bin/env bash
modules=("vterm")
version=$(pacman -Q emacs | awk '{print $2}'|cut -d- -f1)

for module in $modules; do
    mkdir /home/doomguy/.emacs.d/.local/straight/build-${version}/${module}/build
    cd /home/doomguy/.emacs.d/.local/straight/build-${version}/${module}/build
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
    make
done