#!/usr/bin/env bash

QUEUE_DIR=$HOME/.msmtpqueue
QUEUE_LENGTH=$(find "${QUEUE_DIR}" -iname "*.mail" | wc -l)

echo "${QUEUE_LENGTH} mails in ${QUEUE_DIR}"

find "${QUEUE_DIR}" -iname "*.mail" |
while read MAIL ; do
    echo
    echo "File: $(basename "${MAIL}")"
    egrep -s -h '^(From|To|Date|Subject|Size):' "${MAIL}"
    echo "Size:" $(du -h "${MAIL}" | awk '{ print $1 }')
done
