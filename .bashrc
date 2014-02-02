#
# Daniels  $HOME/.bashrc
#

[ -r /etc/profile ] && source /etc/profile

BASH_CONF_DIR="$HOME/.bash"

for a in env functions prompt ; do
    for script in $(find "${BASH_CONF_DIR}/${a}" -maxdepth 1 -follow -type f) ; do
        source "${script}"
    done
done
