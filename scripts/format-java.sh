#!/bin/sh

set -e

cd "$(dirname "$0")/.."
base_dir="$PWD"
scripts_dir="$base_dir/scripts"

fmt_jar_project="google-java-format"
fmt_jar_version="1.8"
fmt_jar_release="$fmt_jar_project-$fmt_jar_version"
fmt_jar_file="$fmt_jar_release-all-deps.jar"
fmt_jar_url="https://github.com/google/$fmt_jar_project/releases/download/$fmt_jar_release/$fmt_jar_file"

if [ ! -f "$scripts_dir/$fmt_jar_file" ]; then
  echo "Downloading $fmt_jar_file"
  curl -sSLf "$fmt_jar_url" -o "$scripts_dir/$fmt_jar_file"
fi

if [ $# -ne 0 ]; then
  java_files="$(printf "%s\n" "$@")"
else
  set +e
  java_files="$(
    git ls-tree -r --name-only --full-name --full-tree HEAD |
    grep "\.java$"
  )"
  set -e
fi

if [ -n "$java_files" ]; then
  echo "Formatting java"
  echo "$java_files" | tr "\n" "\0" | xargs -0 java -jar "$scripts_dir/$fmt_jar_file" -i
fi
