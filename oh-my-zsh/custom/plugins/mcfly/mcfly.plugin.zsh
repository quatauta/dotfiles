#!/bin/bash
# Initialize [mcfly](https://github.com/cantino/mcfly/)

export HISTFILE="${XDG_CACHE_HOME:-${HOME}/.cache}/shell-history"

if command -v mcfly 1>/dev/null 2>&1 ; then
    eval "$(mcfly init zsh)"
fi
