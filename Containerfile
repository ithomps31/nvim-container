FROM quay.io/centos/centos:stream10-minimal

#ARG NVIM_TAR_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
ARG NVIM_TAR_URL="https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz"
ARG NVIM_TAR="nvim-linux-x86_64.tar.gz"

USER 0:0
RUN microdnf install -y python3 python3-pip tar lua gettext curl git && microdnf clean all

RUN pip install python-lsp-server && pip install jedi

WORKDIR /app/install
RUN curl -LO  $NVIM_TAR_URL \
    && tar -C /opt -xzf $NVIM_TAR \
    && rm $NVIM_TAR

RUN useradd -ms /bin/bash prime
USER prime

WORKDIR /home/prime

RUN mkdir -p /home/prime/.config/nvim
RUN mkdir -p /home/prime/.config/nvim/lua/core
ENV PATH="$PATH:/opt/nvim-linux-x86_64/bin"

COPY --chown=prime ./examples/example.json ./example.json
COPY --chown=prime ./examples/example.py ./example.py
COPY ./init.lua /home/prime/.config/nvim/init.lua
# COPY ./lsp.lua /home/prime/.config/nvim/lua/core/lsp.lua

ENTRYPOINT ["bash"]
