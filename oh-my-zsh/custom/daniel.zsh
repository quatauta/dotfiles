# ~/.zsh/completion
# vim:syntax=zsh:

# completion for 'g' as wrapper script for git
compdef _git g=git

for ENV in "${HOME}"/.{,config/}env{,.local} ; do
    [ -r "${ENV}" ] && source "${ENV}"
done

# bindkey -e
# autoload -Uz zkbd
#
# ZKBD_KEYS="${HOME}/.zsh/zkbd/${TERM}"
#
# if [[ -r "${ZKBD_KEYS}" ]]; then
#     source "${ZKBD_KEYS}"
# else
#     echo "WARNING: Keybindings may not be set correctly!"
#     echo "Execute \`zkbd\` to create bindings."
# fi

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

# setopt always_to_end
# setopt append_history
# setopt auto_cd
# setopt auto_continue
# setopt auto_pushd
# setopt auto_resume
# setopt bg_nice
# setopt check_jobs
# setopt complete_aliases
# setopt complete_in_word
# setopt correct
# # setopt extended_glob
# setopt hist_find_no_dups
# setopt hist_ignore_all_dups
# setopt hist_ignore_dups
# setopt hist_ignore_space
# setopt hist_reduce_blanks
# setopt hist_save_no_dups
# setopt hist_verify
# setopt inc_append_history
# setopt list_ambiguous
# setopt list_packed
# setopt list_rows_first
# setopt no_auto_remove_slash
# setopt numeric_glob_sort
# setopt print_exit_value
# setopt prompt_subst
# setopt pushd_ignore_dups
# setopt pushd_to_home
# setopt rm_star_wait
# setopt sh_word_split

# export REPORTTIME=60
export TMPPREFIX="${TMP}/zsh"
# export WORDCHARS='!%^(){}'
# export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&|'
# export ZLE_SPACE_SUFFIX_CHARS=$';&|'
export ZSH_COMPDUMP="${HOME}/.cache/zcompdump"
