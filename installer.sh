#!/bin/sh
# This script downloads my config files to their correct file locations

base_url="https://raw.githubusercontent.com/ayuxsec/my_config_files/refs/heads/main"

mkdir -p "$HOME/.config/my_config_files"
mkdir -p "$HOME/.config/conky"

curl -o "$HOME/.config/conky/conky.conf" -fLsS "$base_url/conky.conf"

curl -o "$HOME/.config/my_config_files/ollama.bashrc" -fLsS "$base_url/ollama.sh" && \
 printf '\n# source my config files\nsource "$HOME/.config/my_config_files/ollama.bashrc"\n' >> "$HOME/.bashrc"

curl -o "$HOME/.config/my_config_files/pentesting.bashrc" -fLsS "$base_url/pentesting.sh" && \
 printf '\nsource "$HOME/.config/my_config_files/pentesting.bashrc"\n' >> "$HOME/.bashrc"

echo "[+] restart your shell."
