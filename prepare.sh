#!/bin/bash

git config --local include.path ../.gitconfig
git config --local core.hooksPath .githooks/

if [[ -z $(grep "$HOME/.cargo/bin" <<< $PATH) ]]; then
    echo "# added by ./prepare.sh\nPATH=~/.cargo/bin:\$PATH" >> ~/.bash_profile
    PATH=~/.cargo/bin:$PATH
fi

rustup component add rust-analyzer rustfmt clippy
command -v sccache >&- || cargo install sccache --locked
command -v taplo >&- || cargo install taplo-cli --locked
