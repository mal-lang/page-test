#!/bin/sh

set -e

cd "$(dirname "$0")/.."

echo "Formatting pom.xml..."
mvn \
  --batch-mode \
  --quiet \
  -Dincludes="pom.xml" \
  xml-format:xml-format \
  tidy:pom
echo "Done"
