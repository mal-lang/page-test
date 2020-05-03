#!/bin/sh

set -e

cd "$(dirname "$0")/.."

echo "Formatting pom.xml"
mvn -B -q -Dincludes="pom.xml" xml-format:xml-format tidy:pom
