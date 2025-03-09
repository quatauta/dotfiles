#!/bin/bash

PATH="${HOME}/.dotfiles/bin:${HOME}/local/bin:${PATH}"

if command -v devbox 1>/dev/null 2>&1 && command -v nix 1>/dev/null 2>&1 ; then
  eval "$(devbox global shellenv)"
fi
