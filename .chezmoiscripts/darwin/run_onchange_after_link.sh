#!/bin/bash

# Create symlinks for lazygit and aichat configs on Mac
# They look for configs in ~/Library/Application Support/ but we manage in ~/.config/

LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
LAZYGIT_CONFIG_DIR="$HOME/.config/lazygit"

AICHAT_DIR="$HOME/Library/Application Support/aichat"
AICHAT_CONFIG_DIR="$HOME/.config/aichat"

# Lazygit
if [ ! -L "$LAZYGIT_DIR" ] && [ ! -d "$LAZYGIT_DIR" ]; then
  mkdir -p "$HOME/Library/Application Support"
  ln -s "$LAZYGIT_CONFIG_DIR" "$LAZYGIT_DIR"
elif [ -d "$LAZYGIT_DIR" ] && [ ! -L "$LAZYGIT_DIR" ]; then
  mv "$LAZYGIT_DIR"/* "$LAZYGIT_CONFIG_DIR"/ 2>/dev/null || true
  rm -rf "$LAZYGIT_DIR"
  ln -s "$LAZYGIT_CONFIG_DIR" "$LAZYGIT_DIR"
fi

# Aichat
if [ ! -L "$AICHAT_DIR" ] && [ ! -d "$AICHAT_DIR" ]; then
  mkdir -p "$HOME/Library/Application Support"
  ln -s "$AICHAT_CONFIG_DIR" "$AICHAT_DIR"
elif [ -d "$AICHAT_DIR" ] && [ ! -L "$AICHAT_DIR" ]; then
  mv "$AICHAT_DIR"/* "$AICHAT_CONFIG_DIR"/ 2>/dev/null || true
  rm -rf "$AICHAT_DIR"
  ln -s "$AICHAT_CONFIG_DIR" "$AICHAT_DIR"
fi

