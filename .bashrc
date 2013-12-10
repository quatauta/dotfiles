#
# Daniels  $HOME/.bashrc
#

BASH_CONF_DIR="$HOME/.bash"

test -r /etc/profile && source /etc/profile

for a in env functions prompt ; do
    for script in $(find "${BASH_CONF_DIR}/${a}" -maxdepth 1 -follow -type f) ; do
        source "${script}"
    done
done
