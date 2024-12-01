#!/bin/bash

# git filters.
git config --local include.path ../.gitconfig

# local git hooks.
git config --local core.hooksPath .githooks/

# add cargo installed programs to path.
if [[ -z $(grep "$HOME/.cargo/bin" <<< $PATH) ]]; then
    printf "# added by ./prepare.sh\nPATH=~/.cargo/bin:\$PATH" \
	     >> ~/.bash_profile
    PATH=~/.cargo/bin:$PATH
fi

# add these components.
for component in rust-analyzer rustfmt clippy; do
    rustup component list --installed | grep -q $component ||
	rustup component add $component
done

# use sccache for optimized compile time & space usage.
command -v sccache >&- ||
    cargo install sccache --locked

# use taplo for toml formatting.
command -v taplo >&- ||
    cargo install taplo-cli --locked
