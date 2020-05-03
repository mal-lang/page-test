#!/bin/sh

set -e

cd "$(dirname "$0")/.."

if [ $# -ne 0 ]; then
  xml_files="$(printf ",%s" "$@" | sed "s/^,//")"
else
  set +e
  xml_files="$(
    git ls-tree -r --name-only --full-name --full-tree HEAD |
    grep "\.xml$" |
    grep -v "^pom\.xml$" |
    tr "\n" "\0" |
    xargs -0 printf ",%s" |
    sed "s/^,//"
  )"
  set -e
fi

if [ -n "$xml_files" ]; then
  echo "Formatting xml"
  mvn -B -q -Dincludes="$xml_files" xml-format:xml-format
fi
