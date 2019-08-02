#!/usr/bin/env bash
# Script executed by socat
set -e

. ./functions.sh

declare -gA req_headers
declare -g method
declare -g path
declare -g version

init() {
  return
}

parse-head() {
  # First HTTP line is method, path and version e.g.: GET /no HTTP/1.1
  "${HTTP_READ[@]}" -r method path version
  # If one is missing it's invalid.
  if [ -z "$method" ] || [ -z "$path" ] || [ -z "$version" ]; then
    respond 400
    echo "Invalid request."
    close
  fi

  # Read headers
  while "${HTTP_READ[@]}" -r line; do
    # If line is empty, it's the end of the head. read no further.
    # shellcheck disable=SC2154
    if [ -z "$line" ]; then
      break
    fi

    # Read header line
    IFS=":" read -r name value <<<"$line"
    # Transform header name to lowercase since headers should be case insensitive
    req_headers["${name,,}"]="$value"
  done
}

close() {
  wait
  clean
  exit
}

handle() {
  local -a args=()

  # Add all headers to awk variables
  for name in "${!req_headers[@]}"; do
    args+=("-v")
    args+=("header_${name//[^a-z0-9_]/_}=${req_headers[name]}")
  done

  local awk_out
  # Run awk router, lib.awk contains the helper functions
  awk_out="$(awk -v "hostname=${req_headers["host"]}" -v "method=${method}" -v "path=${path}" "${args[@]}" -f lib.awk -f src/router.awk)"
  # First line contains action and variables of said action
  IFS=":" read -r action variables <<<"$(head -1 <<<"$awk_out")"
  # Line after contains rest, e.g. with write the body
  handle-action "$action" "$variables" "$(tail +2 <<<"$awk_out")"
}

handle-redirect() {
  local variables="$1"
  IFS=":" read -r code location <<<"$variables"
  header "Location" "$location"
  header "Connection" "close"
  respond "$code"
  close
}

handle-write() {
  local variables="$1"
  local rest="$2"

  header "Content-Type" "$variables"
  header "Content-Length" "$(wc -c <<<"$rest")"
  respond "200"
  echo "$rest"
  close
}

handle-handler() {
  # Just YOLO run that script, figure it out yourself.
  # shellcheck disable=SC1090
  . "./src/handlers/$1.sh"
}

handle-action() {
  local action="$1"
  local variables="$2"
  local rest="$3"

  case "$action" in
  redirect)
    handle-redirect "$variables"
    ;;
  write)
    handle-write "$variables" "$rest"
    ;;
  handler)
    handle-handler "$variables"
    ;;
  *)
    respond 500
    echo "Server error."
    close
    ;;
  esac
}

clean() {
  return
}

main() {
  init
  parse-head
  handle
}

main
