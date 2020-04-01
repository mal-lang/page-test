#!/bin/sh

try() {
  echo "$1..." | tr -d "\n"
  set +e
  output="$(eval "$2" 2>&1)"
  if [ $? -ne 0 ]; then
    set -e
    echo " ERROR"
    >&2 echo "$output"
    exit 1
  fi
  set -e
  echo " OK"
  if [ -n "$output" ]; then
    echo "$output"
  fi
}
