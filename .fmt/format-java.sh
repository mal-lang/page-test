#!/bin/sh

set -e

cd "$(dirname "$0")/.."
fmt_jar="$(echo "$PWD/.fmt"/google-java-format-*.jar)"

echo "Formatting java files..."
if [ $# -ne 0 ]; then
  java -jar "$fmt_jar" -i "$@"
else
  find "$PWD" -name "*.java" | tr "\n" "\0" | xargs -0 java -jar "$fmt_jar" -i
fi
echo "Done"
