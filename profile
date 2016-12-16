#!/bin/sh

. "$SHVM_HOME/utils/utils.sh"

shvm_use() {
  install=
  target=

  while test $# != 0; do
    case "$1" in
    --help)
      "$SHVM_HOME/usr/shvm-use" --help
      return 0
      ;;
    --install)
      install=t
      ;;
    -*|--*)
      echo "Unrecognized option: $1" >&2
      return 1
      ;;
    *)
      target="$1"
      ;;
    esac
    shift
  done

  if [ -z "$target" ]; then
    "$SHVM_HOME/usr/shvm-use" --help
    return 1
  fi

  [ -n "$install" ] && "$SHVM_HOME/usr/shvm-install" "$target"

  if ! [ -d "$SHVM_HOME/lib/$target" ]; then
    echo "Unknown shell version: $target." >&2
    return 1
  fi

  export PATH="$SHVM_HOME/lib/$target/bin:$PATH"

  echo "Switched to $target"
}

shvm_select() {
  filter="$(shvm_filter "$SHVM_FILTER")"
  if [ -z "$filter" ]; then
    echo "SHVM_FILTER: no filter available" >&2
    return 1
  fi
  selected_shell="$("$SHVM_HOME/usr/shvm-list" "$@" | $filter | awk '{print $2}')"
  if [ -z "$selected_shell" ]; then
    return 0
  fi
  shvm_use "$selected_shell"
}

shvm() {
  case "$1" in
  select)
    shift
    shvm_select "$@"
    ;;
  list)
    shift
    "$SHVM_HOME/usr/shvm-list" "$@"
    ;;
  use)
    shift
    shvm_use "$@"
    ;;
  fetch)
    shift
    "$SHVM_HOME/usr/shvm-fetch" "$@"
    ;;
  install)
    shift
    "$SHVM_HOME/usr/shvm-install" "$@"
    ;;
  uninstall)
    shift
    "$SHVM_HOME/usr/shvm-uninstall" "$@"
    ;;
  help)
    shift
    "$SHVM_HOME/usr/shvm-help" "$@"
    ;;
  --help)
    shift
    "$SHVM_HOME/usr/shvm-help"
    ;;
  --version)
    shift
    echo "shvm version 0.0.0"
    ;;
  -*|--*)
    echo "Unrecognized option: $1" >&2
    return 1
    ;;
  "")
    "$SHVM_HOME/usr/shvm-help"
    return 1
    ;;
  *)
    subcmd="$SHVM_HOME/usr/shvm-$1"
    if [ -f "$subcmd" ]; then
      shift
      "$subcmd" "$@"
      return $?
    else
      echo "Unrecognized command: $1" >&2
      return 1
    fi
    ;;
  esac
}

export SHVM_HOME=${SHVM_HOME:-$HOME/.shvm}
export SHVM_FILTER="fzy:fzf-tmux:fzf:peco:percol"
