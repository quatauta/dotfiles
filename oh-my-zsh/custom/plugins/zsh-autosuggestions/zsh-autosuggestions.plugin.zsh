#!/bin/bash

DEVBOX_PREFIX="${HOME}/.local/share/devbox/global/default/.devbox/nix/profile/default"
ZSH_AUTOSUGGESTIONS="${DEVBOX_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [[ -r "${ZSH_AUTOSUGGESTIONS}" ]] ; then
  source "${ZSH_AUTOSUGGESTIONS}"
fi
