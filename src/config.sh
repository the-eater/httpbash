#!/usr/bin/env bash

# Don't load config twice
if [ "$config" = 1 ]; then
  return
fi
declare config=1

# Default headers
declare -gA headers=(
  ["Server"]="bash"
  ["Connection"]="close"
)
