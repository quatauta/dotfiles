#!/bin/bash

ZSH_AUTOSUGGESTIONS="${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [[ -r "${ZSH_AUTOSUGGESTIONS}" ]] ; then
  source "${ZSH_AUTOSUGGESTIONS}"
fi
