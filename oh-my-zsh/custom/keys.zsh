# ~/.zsh/keys
# vim:syntax=zsh:

bindkey -e
autoload -Uz zkbd

ZKBD_KEYS="${HOME}/.zsh/zkbd/${TERM}"

if [[ -r "${ZKBD_KEYS}" ]]; then
    source "${ZKBD_KEYS}"
else
    echo "WARNING: Keybindings may not be set correctly!"
    echo "Execute \`zkbd\` to create bindings."
fi

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
