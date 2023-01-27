#!/usr/bin/env bash

# rsync music from Windows home user to remote Plex dir

declare -r __PATH_LOCAL=~/'winhome/Music' \
  __PATH_EXCLUDE_FILE=~/'.config/music-to-plex/exclude_patterns.txt' \
  __PATH_GLOBALS=~/'.config/music-to-plex/global_vars.sh'

if [[ ! -d "${__PATH_LOCAL}" || ! -f "${__PATH_EXCLUDE_FILE}" || ! -f "${__PATH_GLOBALS}" ]]
then
  echo "Unable to find '${__PATH_LOCAL}', '${__PATH_EXCLUDE_FILE}' or '${__PATH_GLOBALS}'. Aborting!" >&2
  exit 1
fi

eval "$(cat "${__PATH_GLOBALS}")"


rsync \
  "--exclude-from=${__PATH_EXCLUDE_FILE}" \
  --delete-after \
  -Prv "${__PATH_LOCAL}/" "${__HOST_PLEX}:${__PATH_PLEX_MUSIC}/"
