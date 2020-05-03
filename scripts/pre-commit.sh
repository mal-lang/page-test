#!/bin/sh

set -e

cd "$(dirname "$0")/.."
base_dir="$PWD"
scripts_dir="$base_dir/scripts"

changed_files="$(git diff --cached --name-only --diff-filter=ACMR)"

set +e
changed_java="$(echo "$changed_files" | grep "\.java$")"
changed_pom="$(echo "$changed_files" | grep "^pom\.xml$")"
changed_xml="$(echo "$changed_files" | grep "\.xml$" | grep -v "^pom\.xml$")"
set -e

if [ -n "$changed_java" ]; then
  echo "$changed_java" | tr "\n" "\0" | xargs -0 "$scripts_dir/format-java.sh"
fi

if [ -n "$changed_pom" ]; then
  "$scripts_dir/format-pom.sh"
fi

if [ -n "$changed_xml" ]; then
  echo "$changed_xml" | tr "\n" "\0" | xargs -0 "$scripts_dir/format-xml.sh"
fi
