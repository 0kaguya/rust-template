#!/bin/bash

# set project name to directory name
tmp=$(mktemp); trap "rm $tmp" EXIT SIGINT
awk -v name=$(basename $(pwd)) \
	'/^name =/ { printf "name = \"%s\"\n", name; next } { print $0 }' \
	Cargo.toml >$tmp
tee Cargo.toml <$tmp >/dev/null

# remove template's readme file
rm README.md

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

# add some rustup components.
for component in rust-analyzer rustfmt clippy; do
    rustup component list --installed | grep -q $component ||
	rustup component add $component
done

# sccache optimizes space usage & compile time.
command -v sccache >&- ||
    cargo install sccache --locked

# taplo formats .toml files.
command -v taplo >&- ||
    cargo install taplo-cli --features lsp --locked
