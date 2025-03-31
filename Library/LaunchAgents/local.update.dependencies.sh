#!/usr/bin/env bash

export PATH="/Users/daniel/.local/share/mise/shims:/Users/daniel/.local/bin:/Users/daniel/.dotfiles/bin:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/sbin:/Applications/iTerm.app/Contents/Resources/utilities"

_network_has_ip_address() {
  for IF in $(ipconfig getiflist); do
    if ipconfig getifaddr "${IF}" >&/dev/null; then
      return 0
    fi
  done

  return 1
}

_network_is_expensive() {
  for IF in $(ipconfig getiflist); do
    if ipconfig getsummary "${IF}" | grep -iq 'IsExpensive *: *TRUE' ; then
      return 0
    fi
  done

  return 1
}

_wait_for_inexpensive_network() {
  local SECONDS="$1"

  for COUNT in $(seq "${SECONDS}"); do
    if _network_has_ip_address && ! _network_is_expensive; then
      return 0
    else
      sleep 1
    fi
  done

  return 1
}

exit

cd "$HOME"
_wait_for_inexpensive_network 10 || exit
sleep 60
# eval "$(devbox global shellenv)"
# set -x
# update-dependencies --find --maxdepth 2 -exclude 'dotfiles' --printer null "$HOME/work/q"
