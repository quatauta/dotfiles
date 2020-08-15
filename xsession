#!/bin/bash

_kill_and_start() {
    local TEST="${1}"
    shift
    local CMD="${@}"

    pkill -u "${USER}" "${TEST}" 1>/dev/null
    ( delay -d 1 -- ${CMD} & )
}

export PATH="${PATH}:/usr/libexec:${HOME}/bin"

cd "${HOME}"
source "${HOME}/.config/env"
source "${HOME}/.config/env.local"

# Determine the window manger to use
if [ -n "${WINDOW_MANAGER}" ]; then
    realstartup="${WINDOW_MANAGER}"
elif [ -n "${XSESSION}" ]; then
    realstartup="${XSESSION}"
elif [ -x /usr/bin/x-session-manager ]; then
    realstartup=x-session-manager
elif [ -x /usr/bin/x-window-manager ]; then
    realstartup=x-window-manager
elif [ -x /usr/bin/x-terminal-emulator ]; then
    realstartup=x-terminal-emulator
fi

if [ -n "$realstartup" ] ; then
    realstartup="$(which "${realstartup}")"
    realstartup="$(realpath "${realstartup}")"
fi

export DESKTOP_SESSION="${DESKTOP_SESSION:-gnome}"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-GNOME}"
systemctl --user import-environment DESKTOP_SESSION
systemctl --user import-environment XDG_CURRENT_DESKTOP

(
    for I in {0..4} ; do
        setxkbmap -layout "de" -model pc105 -variant "nodeadkeys" -option "terminate:ctrl_alt_bksp,caps:ctrl_modifier"
        setxkbmap -layout "de-daniel" -model pc105 -variant "nodeadkeys" -option "terminate:ctrl_alt_bksp,caps:ctrl_modifier"
        xmodmap "${HOME}/.Xmodmap"
        xrdb -merge "${HOME}/.Xresources"
        xset dpms 300 300 300
        xset m 1 10000
        xset r rate 250 30
        numlockx off
        numlockx on
        sleep 3
    done
) &

case "${realstartup}" in
    *box )
        # fbsetroot -solid black
        fbsetbg -l

        _kill_and_start conky conky
        _kill_and_start gsd gnome-settings-daemon
        #_kill_and_start redshift redshift-gtk -l 49.6:6.1
        _kill_and_start unclutter unclutter
        _kill_and_start xcape xcape -e 'Control_L=Escape'

        ( type systemctl 1>/dev/null && systemctl --failed --no-pager --no-legend >>"${HOME}/.xsession-errors" ) &
        (
            sleep 5
            fluxbox-generate-menu &

            ROOT_TAIL_OPTS="--fork --color '#9e9e92' --interval 5 --wordwrap --font '-misc-fixed-medium-r-normal-*-10-*-*-*-*-*-iso10646-1'"
            set -x
            root-tail ${ROOT_TAIL_OPTS} --geometry 1155x435+30+50 "${HOME}/.xsession-errors" &
            root-tail ${ROOT_TAIL_OPTS} --geometry 525x435+1215+50 --whole "${HOME}/.task/calendar" &
            root-tail ${ROOT_TAIL_OPTS} --geometry 1600x470+30-40 "/var/log/messages" &
            light-locker &
        ) &
    ;;
esac

# Start window manager
if [ -n "${realstartup}" ] ; then
    exec ${realstartup}
fi
