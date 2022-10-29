# ~/.bash_profile: executed by bash(1) for login shells.

umask 027
[ -f $HOME/.bashrc ] && source $HOME/.bashrc
tty | grep -q "/tty[0-9]" && $HOME/bin/s

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/daniel/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)