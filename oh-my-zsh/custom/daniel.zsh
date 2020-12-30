# ~/.zsh/completion
# vim:syntax=zsh:

# completion for 'g' as wrapper script for git
compdef _git g=git

test -r /etc/profile && source /etc/profile

for ENV in "${HOME}"/.{,config/}env{,.local} ; do
    [ -r "${ENV}" ] && source "${ENV}"
done

[[ -n ${terminfo[kpp]} ]] && bindkey "${terminfo[kpp]}" history-beginning-search-backward
[[ -n ${terminfo[knp]} ]] && bindkey "${terminfo[knp]}" history-beginning-search-forward

setopt append_history
setopt auto_continue
# setopt auto_resume
# setopt check_jobs
# setopt complete_aliases
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history
setopt list_ambiguous
setopt list_packed
# setopt list_rows_first
# setopt no_auto_remove_slash
setopt numeric_glob_sort
# setopt print_exit_value
# setopt pushd_to_home
# setopt sh_word_split

export REPORTTIME=60
export TMPPREFIX="${TMP}/zsh"
export WORDCHARS='!%^(){}'
export ZSH_COMPDUMP="${HOME}/.cache/zcompdump"
