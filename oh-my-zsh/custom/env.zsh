# ~/.zsh/env
# vim:syntax=zsh:

shopt() { }

for ENV in "${HOME}"/.{,config/}env{,.local} ; do
    [ -r "${ENV}" ] && source "${ENV}"
done
