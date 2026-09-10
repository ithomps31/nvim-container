FROM quay.io/centos/centos:stream10-minimal

USER 0:0
RUN microdnf install -y tar lua gettext curl git && microdnf clean all

WORKDIR /app/install
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && rm nvim-linux-x86_64.tar.gz

RUN useradd -ms /bin/bash prime
USER prime

WORKDIR /home/prime

RUN mkdir -p /home/prime/.config/nvim
ENV PATH="$PATH:/opt/nvim-linux-x86_64/bin"

COPY ./example.json ./example.json
COPY ./init.lua /home/prime/.config/nvim/init.lua

ENTRYPOINT ["bash"]
