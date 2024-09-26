FROM ubuntu:24.04

RUN mkdir /usr/bin/micro
ENV MAMBA_ROOT_PREFIX=/usr/bin/micro

RUN apt-get update && apt-get install -y wget curl bzip2

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb && \
    dpkg -i quarto-*.deb && \
    rm quarto-*.deb

RUN curl -Ls https://github.com/prefix-dev/pixi/releases/download/v0.30.0/pixi-x86_64-unknown-linux-musl -o /usr/local/bin/pixi
RUN chmod +x /usr/local/bin/pixi

WORKDIR /repo
