#!/usr/bin/env bash

QUEUE_DIR=$HOME/.msmtpqueue
QUEUE_LENGTH=$(find "${QUEUE_DIR}" -iname "*.mail" | wc -l)

find "${QUEUE_DIR}" -iname "*.mail" |
while read -r MAIL ; do
    echo
    echo "File: $(basename "${MAIL}")"
    grep -Es --color -h '^(From|To|Date|Subject|Size):' "${MAIL}"
    echo "Size:" "$(du -h "${MAIL}" | awk '{ print $1 }')"
done

echo "${QUEUE_LENGTH} mail(s) in msmtp queue ${QUEUE_DIR}"
