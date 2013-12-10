#!/bin/sh

export PATH="${PATH}:/usr/libexec"

GSD="$(which gnome-settings-daemon)"

if [ -x "${GSD}" ] ; then
    while ! pgrep -u "${USER}" -f -x "${GSD}" ; do
        "${GSD}" --no-daemon --sync || "${GSD}"
        wmctrl -l 1>/dev/null 2>&1 || break
        sleep 1
    done
fi
