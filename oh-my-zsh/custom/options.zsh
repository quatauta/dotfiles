# ~/.zsh/options
# vim:syntax=zsh:

setopt always_to_end
setopt append_history
setopt auto_cd
setopt auto_continue
setopt auto_pushd
setopt auto_resume
setopt bg_nice
setopt check_jobs
setopt complete_aliases
setopt complete_in_word
setopt correct
# setopt extended_glob
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
setopt list_ambiguous
setopt list_packed
setopt list_rows_first
setopt no_auto_remove_slash
setopt numeric_glob_sort
setopt print_exit_value
setopt prompt_subst
setopt pushd_ignore_dups
setopt pushd_to_home
setopt rm_star_wait
setopt sh_word_split

export REPORTTIME=60
export WORDCHARS='!%^(){}'
export TMPPREFIX="${TMP}/zsh"
export ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&|'
export ZLE_SPACE_SUFFIX_CHARS=$';&|'
