FROM archlinux:latest

# user creation
RUN useradd -m doomguy

# depencies and tools
RUN pacman -Sy && pacman -S --noconfirm\
    # dependencies
    base-devel \
    cmake \
    libvterm \
    emacs \
    ripgrep \
    xclip \
    fd \
    # git
    git \
    git-crypt \
    glab \
    # k8s
    kubectl \
    kubectx \
    argocd \
    kustomize \
    # etc
    docker \
    ansible \
    terraform \
    zsh \
    wget \
    openssh \
    gnupg \
    nano \
    # linting
    yamllint \
    ruby

# add user to group docker
RUN gpasswd -a doomguy docker

# doom emacs installation
COPY doom.d/* /home/doomguy/.doom.d/
RUN chown doomguy:doomguy /home/doomguy/.doom.d/*
USER doomguy
RUN git clone https://github.com/hlissner/doom-emacs /home/doomguy/.emacs.d
RUN /home/doomguy/.emacs.d/bin/doom install --force

# build modules
RUN mkdir /home/doomguy/.emacs.d/.local/straight/build-28.2/vterm/build
WORKDIR /home/doomguy/.emacs.d/.local/straight/build-28.2/vterm/build
RUN cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
RUN make

# zsh fzf installation
RUN wget -O /home/doomguy/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/doomguy/.fzf
RUN zsh -c "/home/doomguy/.fzf/install --all"

# fish syntax highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/doomguy/.zsh
RUN echo "source /home/doomguy/.zsh/zsh-syntax-highlighting.zsh" >> /home/doomguy/.zshrc

# krew
RUN (set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew)
RUN echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /home/doomguy/.zshrc

# install krew plugins
RUN export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && kubectl krew install oidc-login minio

# yay and rubocop
RUN echo 'export PATH="${HOME}/.local/share/gem/ruby/3.0.0/bin:$PATH"' >> /home/doomguy/.zshrc
RUN gem install rubocop

USER root

# argo-workflows
RUN curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.4.1/argo-linux-amd64.gz
RUN gunzip argo-linux-amd64.gz
RUN chmod +x argo-linux-amd64
RUN mv ./argo-linux-amd64 /usr/local/bin/argo

# host services
RUN mkdir -p /run/host-services/
RUN chown doomguy:doomguy /run/host-services/

# vars
RUN echo "SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock" >> /etc/environment

# shell
RUN usermod --shell=/bin/zsh doomguy
RUN echo 'source <(cat /home/doomguy/.zsh_override/doom_*)' >> /home/doomguy/.zshrc

# CMD
WORKDIR /home/doomguy
COPY scripts/entrypoint.sh /home/doomguy/entrypoint.sh
ENTRYPOINT ["/home/doomguy/entrypoint.sh", "emacs", "--no-window-system"]
