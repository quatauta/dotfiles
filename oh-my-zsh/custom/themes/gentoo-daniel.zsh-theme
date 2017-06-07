# daniel prompt theme
# vim:set syntax=zsh:

local prompt_cwd=${1:-'yellow'}
local prompt_user=${2:-'green'}
local prompt_root=${3:-'red'}
local prompt_ssh=${4:-'yellow'}

local prompt_user_style="${prompt_user}"
local prompt_host_style="gray"

[ "$EUID" = "0" ] && prompt_user_style="$prompt_root" # logged in as root
[ "$SSH_TTY" ]    && prompt_host_style="$prompt_ssh"  # connected via ssh

local base_prompt="%F{$prompt_user_style}%n%b%F{gray}@%F{$prompt_host_style}%m%{$reset_color%}"
local path_prompt="%F{$prompt_cwd}%4~%{$reset_color%}"
local rc_prompt="%(?.%F{$prompt_user_style}.%F{red})%(!.#.>)%{$reset_color%}"
local post_prompt="%b%f%k"

PROMPT='$base_prompt $path_prompt $rc_prompt $post_prompt'
PS2='$base_prompt$path_prompt %_> $post_prompt'
PS3='$base_prompt$path_prompt ?# $post_prompt'
RPS1='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{blue}(%F{red}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{blue})%F{yellow}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{blue})"
