#!/bin/bash

function _which() {
    env PATH="${PATH}":/usr/libexec which "${1}" 2>/dev/null
}

function _start() {
    local CMD="$(_which "${1}" 2>/dev/null)"

    if [ -x "${CMD}" ] ; then
        shift
        "${CMD}" "${@}"
    else
        echo "Can't start '${@}'." 1>&2
    fi
}

function _start_with_delay() {
    local DELAY="$(_which delay)"
    local CMD="$(_which "${1}" 2>/dev/null)"

    if [ -x "${DELAY}" ] && [ -x "${CMD}" ] ; then
        shift
        "${DELAY}" -d 3 -- "${CMD}" "${@}" &
    else
        echo "Can't start '${@}'." 1>&2
    fi
}

cd "${HOME}"
source "${HOME}/.bashrc"

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

case "${realstartup}" in
    *box )
        [ -z "${DESKTOP_SESSION}" ] && export DESKTOP_SESSION="gnome"
        _start_with_delay gnome-settings-daemon &
        _start_with_delay fluxbox-generate-menu &
        _start_with_delay conky -d &
        _start_with_delay polkit-gnome-authentication-agent-1 &

        _start_with_delay nice ionice -c3 liferea -w hidden 1>/dev/null 2>&1 &
        _start_with_delay nice ionice -c3 opera-developer 1>/dev/null 2>&1 &
        _start_with_delay unclutter &

        ROOT_TAIL_OPTS="--fork --font \"-misc-fixed-medium-r-normal--10-*-*-*-*-*-iso10646-1\" --interval 5 --wordwrap --cont \"» \""

        _start_with_delay root-tail ${ROOT_TAIL_OPTS} --color '"#9e9e92"' --geometry 1055x435+30+50  "${HOME}/.xsession-errors" ">/dev/null"
        _start_with_delay root-tail ${ROOT_TAIL_OPTS} --color '"#9e9e92"' --geometry 525x435+1215+50 --whole "${HOME}/.task/calendar" ">/dev/null"
        _start_with_delay root-tail ${ROOT_TAIL_OPTS} --color '"#9e9e92"' --geometry 1600x470+30-40 --cont "\"                `hostname | sed -e 's/./ /g'`» \"" /var/log/messages ">/dev/null"

        type systemctl 1>/dev/null && systemctl --failed --no-pager --no-legend >>"${HOME}/.xsession-errors"
    ;;
esac

_start fbsetroot -solid black
_start xmodmap "${HOME}/.Xmodmap"
_start xrdb -merge "${HOME}/.Xresources"
_start xset dpms 600 600 600
_start xset m 1 10000
_start xset r rate 250 30
_start numlockx off
_start numlockx on

_start_with_delay xmodmap "${HOME}/.Xmodmap"
_start_with_delay xrdb -merge "${HOME}/.Xresources"
_start_with_delay xset dpms 600 600 600
_start_with_delay xset m 1 10000
_start_with_delay xset r rate 250 30
_start_with_delay numlockx on

# Start window manager
if [ -n "${realstartup}" ] ; then
    exec ${realstartup}
fi
