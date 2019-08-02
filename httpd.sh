#!/usr/bin/env bash
set -e
__DIR__="${0%/*}"
cd "${__DIR__}"

main() {
  # socat accepts connections, forks and starts the bash script with stdio connected to the connection
  socat tcp-listen:80,reuseaddr,fork "exec:bash ${__DIR__}/handler.sh"
}

main "$@"
