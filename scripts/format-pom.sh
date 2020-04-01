#!/bin/sh

set -e

cd "$(dirname "$0")/.."

. "scripts/try.sh"

try \
  "Formatting pom.xml" \
  "mvn -B -q -Dincludes=\"pom.xml\" xml-format:xml-format tidy:pom"
