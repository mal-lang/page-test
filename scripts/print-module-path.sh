#!/bin/sh

set -e

cd "$(dirname "$0")/.."

artifact_id="$(scripts/print-pom-property.sh "project.artifactId")"
version="$(scripts/print-pom-property.sh "project.version")"

main_jar="$PWD/target/$artifact_id-$version.jar"

if [ ! -f "$main_jar" ]; then
  >&2 echo "$main_jar: No such file"
  exit 1
fi

mvn -B -q dependency:copy-dependencies

echo "$main_jar$(find "$PWD/target/dependency" -name "*.jar" -exec printf ":%s" {} +)"
