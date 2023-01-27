#!/usr/bin/env bash

# __PIPE        get named pipe from Sysinternals pipelist
# __NAME_RELAY  wsl-relay.exe should be in $PATH, such as in ~/bin
declare __PATH_BASE='/tmp/relay-gpg-agent' \
  __NAME_RELAY='wsl-relay'
declare __PATH_SOCKET="${HOME}/.gnupg/S.gpg-agent" \
  __PATH_PID="${__PATH_BASE}/agent.pid" \
  __PATH_LOG="${__PATH_BASE}/relay.log"
declare __PATH_GLOBALS=~/'.config/wsl-relay.conf'

if [[ ! -f "${__PATH_GLOBALS}" ]]
then
  echo "Unable to find '${__PATH_GLOBALS}'. Aborting!" >&2
  exit 1
fi

eval "$(cat "${__PATH_GLOBALS}")"


function _stop()
{
  local pid="$(_get_pid)"

  _status && kill "${pid}"
  [[ -e "${__PATH_SOCKET}" ]] && rm -f "${__PATH_SOCKET}"

  _status
}

function _status()
{
  local pid="$(_get_pid)"

  # check if pid is running on proc tree
  if [[ -n "${pid}" && -d "/proc/${pid}" ]]
  then
    return 0
  else
    return 1
  fi
}

function _get_pid()
{
  local pid

  # get pid if exists
  if [[ -f "${__PATH_PID}" ]]
  then
    pid="$(< "${__PATH_PID}")"
  else
    return 1
  fi

  echo "${pid}"
  return 0
}

function _start()
{
  local socat_agent_pid
  local -i chmod_tries=0

  # run agent via wsl-relay pipe
  rm -f "${__PATH_SOCKET}"
  setsid \
    socat -lf "${__PATH_LOG}" \
      "UNIX-LISTEN:${__PATH_SOCKET},fork" \
      'EXEC:wsl-relay --input-closes --pipe-closes --gpg,nofork' &
  socat_agent_pid="${!}"
  
  # secure perms on the socket
  while sleep 0.333 && [[ "${chmod_retries}" != 3 ]]
  do
    chmod 600 "${__PATH_SOCKET}" \
      && break
    (( chmod_retries++ ))
  done

  # save agent pid
  echo "${socat_agent_pid}" > "${__PATH_PID}"
}

function main()
{
  # this sh var can be used to disable the script
  [[ "${__TOGGLE_GPG_RELAY}" == '0' ]] || return 255

  [[ ! -d "${__PATH_BASE}" ]] && mkdir -p "${__PATH_BASE}"

  if ! _status
  then
    _stop
    _start
  fi
}

main "${@}"
