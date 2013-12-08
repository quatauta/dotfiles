#
# Daniels  $HOME/.bashrc
#

BASH_CONF_DIR="$HOME/.bash"

test -r /etc/profile && source /etc/profile

for a in env prompt functions ; do
    if [ -r "${BASH_CONF_DIR}/${a}" ] ; then
        source "${BASH_CONF_DIR}/${a}"
    fi
done
