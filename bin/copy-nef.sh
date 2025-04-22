#!/bin/bash

set -eu

SRC_DIR="$1"
DST_DIR="${HOME}/Pictures"
LAST_RUN_FILE="${DST_DIR}/.$(basename "$0").last_run"
EXT="NEF"

if [ -f "${LAST_RUN_FILE}" ]; then
  LAST_RUN="$(cat "${LAST_RUN_FILE}")"
else
  LAST_RUN="$(find "${DST_DIR}" -iname "*.${EXT}" 2>/dev/null |
              sort |
              tail -n20 |
              xargs -r exiftool -if '$DateTimeOriginal' -DateTimeOriginal -d "%Y:%m:%d %H:%M:%S" -s3 2>/dev/null |
              sort |
              tail -n1)"
fi

if [ -z "${LAST_RUN}" ]; then
  LAST_RUN="1970:01:01 00:00:00"
fi

exiftool -r -P -progress -ext "${EXT}" \
    -if "\${CreateDate} gt \"${LAST_RUN}\"" \
    "-FileName<${DST_DIR}/\${createdate;DateFmt(\"%Y/%m/%d/%Y-%m-%d\")}_\${Filename}" \
    "-SubjectDistance<FocusDistance" \
    "$SRC_DIR" || true

date +"%Y:%m:%d %H:%M:%S" >"${LAST_RUN_FILE}"
