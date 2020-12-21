# ~/.zsh/completion
# vim:syntax=zsh:

# completion for 'g' as wrapper script for git
compdef _git g=git

for ENV in "${HOME}"/.{,config/}env{,.local} ; do
    [ -r "${ENV}" ] && source "${ENV}"
done

[[ -n ${key[Insert]} ]]   && bindkey "${key[Insert]}"   yank-pop
[[ -n ${key[Home]} ]]     && bindkey "${key[Home]}"     beginning-of-line
[[ -n ${key[PageUp]} ]]   && bindkey "${key[PageUp]}"   history-beginning-search-backward
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" history-beginning-search-forward
[[ -n ${key[Delete]} ]]   && bindkey "${key[Delete]}"   delete-char
[[ -n ${key[End]} ]]      && bindkey "${key[End]}"      end-of-line

[[ -n ${key[C-Left]} ]]  && bindkey "${key[C-Left]}"  backward-word
[[ -n ${key[A-Left]} ]]  && bindkey "${key[A-Left]}"  backward-word
[[ -n ${key[C-Right]} ]] && bindkey "${key[C-Right]}" forward-word
[[ -n ${key[A-Right]} ]] && bindkey "${key[A-Right]}" forward-word

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
