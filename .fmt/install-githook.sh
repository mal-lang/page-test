#!/bin/sh

set -e

cd "$(dirname "$0")/.."

fmt_jar_version="1.7"
fmt_jar_release="google-java-format-$fmt_jar_version"
fmt_jar_file="$fmt_jar_release-all-deps.jar"
fmt_jar="$PWD/.fmt/$fmt_jar_file"
fmt_jar_url="https://github.com/google/google-java-format/releases/download/$fmt_jar_release/$fmt_jar_file"

if [ ! -f "$fmt_jar" ]; then
  echo "Downloading $fmt_jar_file..."
  curl -sSL "$fmt_jar_url" -o "$fmt_jar"
  echo "Done"
fi

echo "Installing githook..."
cp "$PWD/.fmt/pre-commit" "$PWD/.git/hooks/pre-commit"
echo "Done"
