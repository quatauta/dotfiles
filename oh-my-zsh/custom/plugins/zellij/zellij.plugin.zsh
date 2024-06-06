#!/bin/bash
# Initialize [zellij](https://github.com/zellij-org/zellij/)
#
# | Environment variable | Default | Description                                      |
# | -------------------- | ------- | ------------------------------------------------ |
# | ZELLIJ_AUTO_START    | (unset) | if `true`: start zellji automatically            |
# | ZELLIJ_AUTO_ATTACH   | (unset) | if `true`: attach to existing zellij session     |
# | ZELLIJ_AUTO_EXIT     | (unset) | if `true`: Exit shell after auto-starting zellij |

if (( $+commands[zellij] )); then
  if [[ -z "$ZELLIJ" ]] && [[ "$ZELLIJ_AUTO_START" == "true" ]]; then
    if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
      ZJ_SESSIONS=$(zellij list-sessions)
      NO_SESSIONS=$(echo "${ZJ_SESSIONS}" | wc -l)

      if [[ "${NO_SESSIONS}" -ge 2 ]]; then
        zellij attach "$(echo "${ZJ_SESSIONS}" | sk)"
      else
        zellij attach -c
      fi
    else
      zellij
    fi

    if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
      exit
    fi
  fi
fi
