# json array -> bash array
function map_json_to_bash_array()
{
  input="${1}"
  echo -n "${input}" | jq -r '.[]'
}

function contains_element()
{
  declare -r in="${1}"
  declare -a array=("${!2}")
  for e in "${array[@]}"; do [[ "$e" == "${in}" ]] && echo -n "true"; done
  echo -n "false"
}

function log()
{
  level="${1}"
  message="${2}"
  if [ "DRYRUN" == "${1}" ]; then
    level=INFO
    message="DRYRUN:${message}"
  fi
  # all logs to stderr
  echo "${1}" "${2}" 1>&2
}

function how_to_pass_arrays()
{
  declare -ar foo=("${!1}")
  echo "${foo[@]}"
}

function error_if_empty()
{
  var_name="${2:-$1}"
  val="${!1}"
  if [ -z "${val}" ]; then
    log ERROR "variable '${var_name:-unknown}' is empty"
    return 1
  fi
}

function print_help_if_empty()
{
  if ! $(error_if_empty "${1}" "${2:-}"); then
    usage 2 && return 1
  fi
}

function tstamp()
{
  date -d "today" +"%Y%m%d%H%M"
}

function send_dd_event()
{
  #http://docs.datadoghq.com/guides/dogstatsd/
  #FORMAT: _e{title.length,text.length}:title|text|d:date_happened|h:hostname|p:priority|t:alert_type|#tag1,tag2
  declare -r text="${1}"
  declare -r source_type="${2}"
  declare -r alert_type="${2:-info}"
  declare -r title="${3}"
  declare -r hostname="$(hostname)"
  # TODO:  pass variable
  declare -r tags="env:foo,bar:meh"
  declare -r event_packet="_e{${#title},${#text}}:${title}|${text}|h:${hostname}|t:${alert_type}|${tags}"

  echo "${event_packet}" | nc -w 1 -u localhost 8125
}

function usage()
{
  echo "NOT Implemented"
}

# depends upon jq
# print_help_if_empty empty_var_name
# declare -a bar=('1' '2')
# how_to_pass_arrays bar[@]
# TODO: run by shellcheck
