# ~/.zshrc
# vim:set syntax=zsh:

ZSH_CONF_DIR="${HOME}/.zsh"

fpath=(~/.zsh/functions ~/.zsh/functions/** $fpath)

shopt() { }
test -r /etc/profile && source /etc/profile

for a in env functions options keys completion prompt ; do
    if [ -r "${ZSH_CONF_DIR}/${a}" ] ; then
        source "${ZSH_CONF_DIR}/${a}"
    fi
done
