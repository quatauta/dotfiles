#
# Daniels ~/.zshrc
#

ZSH_CONF_DIR="${HOME}/.zsh"

shopt() { }
test -r /etc/profile && source /etc/profile

for a in env options keys completion prompt functions ; do
    if [ -r "${ZSH_CONF_DIR}/${a}" ] ; then
        source "${ZSH_CONF_DIR}/${a}"
    fi
done
