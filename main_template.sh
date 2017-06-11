function usage(){
  echo "TODO: usuage"
}

function main(){
  declare script_dir
  script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  some_flag="foo_flag" #default

  while getopts "d:vh" opt; do
    case "${opt}" in
      d) some_flag="${OPTARG}";;
      v) set -x ;;
      h)
          usage
          exit 0
      ;;
      :)
          log ERROR "Option -${OPTARG} requires an argument."
          return 1
      ;;
      \?)
          log ERROR "Invalid option: -$OPTARG"
          return 1
      ;;
    esac
  done

  # do something
}

set -euo pipefail
main "$@"
