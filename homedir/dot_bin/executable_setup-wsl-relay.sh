#!/usr/bin/env bash

# extract wsl-relay to the windows filesystem

declare -r __PATH_WSLRELAY_ARCHIVE=~/'.chezmoi/wsl-relay.tar' \
 __PATH_WINHOME_BIN=~/'winhome/.bin'

if [[ ! -f "${__PATH_WSLRELAY_ARCHIVE}" ]]
then
  echo "Unable to find '${__PATH_WSLRELAY_ARCHIVE}'. Aborting!" >&2
  exit 1
fi


[ -d "${__PATH_WINHOME_BIN}" ] \
  || mkdir --mode 0755 -pv "${__PATH_WINHOME_BIN}"
[ -f "${__PATH_WINHOME_BIN}/wsl-relay.exe" ] \
  || tar -xf "${__PATH_WSLRELAY_ARCHIVE}" -C "${__PATH_WINHOME_BIN}" wsl-relay.exe
