#!/bin/sh

set -e

cd "$(dirname "$0")/.."

. "scripts/try.sh"

fmt_jar_version="1.7"
fmt_jar_release="google-java-format-$fmt_jar_version"
fmt_jar_file="$fmt_jar_release-all-deps.jar"
fmt_jar="scripts/$fmt_jar_file"
fmt_jar_url="https://github.com/google/google-java-format/releases/download/$fmt_jar_release/$fmt_jar_file"

if [ ! -f "$fmt_jar" ]; then
  try \
    "Downloading $fmt_jar_file" \
    "curl -sSLf \"\$fmt_jar_url\" -o \"\$fmt_jar\""
fi

if [ $# -ne 0 ]; then
  java_files="$(printf "%s\n" "$@")"
else
  set +e
  java_files="$(
    scripts/print-git-files.sh |
    grep "\.java$"
  )"
  set -e
fi

if [ -n "$java_files" ]; then
  try \
    "Formatting java files" \
    "echo \"\$java_files\" | tr \"\\n\" \"\\0\" | xargs -0 java -jar \"\$fmt_jar\" -i"
fi
