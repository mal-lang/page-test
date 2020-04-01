#!/bin/bash

set -e

cd "$(dirname "$0")/.."

if [ $# -ne 1 ]; then
  >&2 echo "Usage: $(basename "$0") PROPERTY"
  exit 1
fi

if [ ! -f "pom.xml" ]; then
  >&2 echo "pom.xml: No such file"
  exit 1
fi

xpath="$(echo "$1" | tr "." "\n" | xargs printf "/*:%s")"
echo "$xpath/text()" > "query.xq"
property="$(xqilla -i "pom.xml" "query.xq")"
rm "query.xq"
echo "$property"
