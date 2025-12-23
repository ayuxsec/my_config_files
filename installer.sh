#!/bin/bash
# This script downloads my config files to their correct file locations

base_url="https://raw.githubusercontent.com/ayuxsec/my_config_files/refs/heads/main"
mkdir -p "$HOME/.config/my_config_files"

curl -s -o "~/.config/conky/conky.conf" "${base_url}/conky.conf"
curl -s -o "~/.config/my_config_files/ollama.bashrc" "${base_url}/ollama.bashrc" && \
  echo "source ~/.config/my_config_files/ollama.bashrc" >> "$HOME/.bashrc"

echo "[+] restart your shell."
