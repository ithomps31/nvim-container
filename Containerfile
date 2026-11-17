FROM quay.io/centos/centos:stream10-minimal

ARG NVIM_TAR_URL="https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz"
ARG NVIM_TAR="nvim-linux-x86_64.tar.gz"

USER 0:0
RUN microdnf install -y \
    python3 python3-pip tar lua gettext curl git \
    gcc unzip \
    && microdnf clean all

RUN ARCH="x86_64" \
    && curl -fsSL "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-${ARCH}-unknown-linux-musl.tar.gz" -o /tmp/ripgrep.tar.gz \
    && tar -xzf /tmp/ripgrep.tar.gz -C /tmp \
    && mv /tmp/ripgrep-14.1.0-${ARCH}-unknown-linux-musl/rg /usr/local/bin/rg \
    && rm -rf /tmp/ripgrep*

RUN pip install --no-cache-dir python-lsp-server jedi

RUN curl -fsSL "$NVIM_TAR_URL" -o "/tmp/$NVIM_TAR" \
    && tar -C /opt -xzf "/tmp/$NVIM_TAR" \
    && rm "/tmp/$NVIM_TAR"

RUN useradd -ms /bin/bash prime
USER prime
WORKDIR /home/prime

ENV PATH="$PATH:/opt/nvim-linux-x86_64/bin"

RUN mkdir -p /home/prime/.config/nvim/lua/core

COPY --chown=prime:prime ./init.lua /home/prime/.config/nvim/init.lua
# COPY --chown=prime:prime ./lsp.lua /home/prime/.config/nvim/lua/core/lsp.lua
COPY --chown=prime:prime ./examples/example.json ./example.json
COPY --chown=prime:prime ./examples/example.py ./example.py

# Pre-sync plugins (adjust command if not using lazy.nvim)
RUN nvim --headless "+Lazy! sync" +qa

CMD ["bash"]
