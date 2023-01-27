#!/usr/bin/env bash

# iterate through Windows $PATH for binaries to add to Linux ~/bin dir

declare -r __PATH_GLOBALS=~/'.config/sync-path-symlinks.conf'

if [[ ! -f "${__PATH_GLOBALS}" ]]
then
  echo "Unable to find '${__PATH_GLOBALS}'. Aborting!" >&2
  exit 1
fi

eval "$(cat "${__PATH_GLOBALS}")"


function main()
{
  local dir exe

  while read -d : dir
  do
    # check the primary directory where binaries are stored
    [ -d "${dir}" ] || continue

    if grep -Fqe "${__PATH_MAIN_UTILITIES}" <<< "${dir}"
    then
      find "${dir}" -mindepth 1 -maxdepth 1 -name '*.exe' -printf '%f\n' \
        | while read exe
        do
          if ! grep -qe '^bash' -e '^sh' \
            && [[ ! -e ~/"bin/${exe/\.exe/}" ]]
            then
              (
                set -x
                ln -s "${dir}/${exe}" ~/"bin/${exe/\.exe/}"
              )
            fi
        done
    fi
  done <<< "${PATH}"
}

main "${@}"
