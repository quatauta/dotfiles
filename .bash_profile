# ~/.bash_profile: executed by bash(1) for login shells.

umask 027

# include .bashrc if it exists
if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi

if tty | grep -q "/tty[0-9]" ; then
    $HOME/bin/s
fi
