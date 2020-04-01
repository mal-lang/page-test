#!/bin/sh

set -e

cd "$(dirname "$0")/.."

. "scripts/try.sh"

if [ $# -ne 0 ]; then
  xml_files="$(printf ",%s" "$@" | sed "s/^,//")"
else
  set +e
  xml_files="$(
    scripts/print-git-files.sh |
    grep "\.xml$" |
    grep -v "^pom\.xml$" |
    tr "\n" "\0" |
    xargs -0 printf ",%s" |
    sed "s/^,//"
  )"
  set -e
fi

if [ -n "$xml_files" ]; then
  try \
    "Formatting xml files" \
    "mvn -B -q -Dincludes=\"\$xml_files\" xml-format:xml-format"
fi
