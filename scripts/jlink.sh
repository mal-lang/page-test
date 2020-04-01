#!/bin/sh

set -e

cd "$(dirname "$0")/.."

artifact_id="$(scripts/print-pom-property.sh "project.artifactId")"
version="$(scripts/print-pom-property.sh "project.version")"

launcher="page-test"
main_module="org.mal_lang.page.test"
main_class="org.mal_lang.page.test.Main"

runtime_image="$PWD/$artifact_id-$version-runtime-image"
module_path="$(scripts/print-module-path.sh)"

jlink \
  --add-modules "$main_module" \
  --compress=2 \
  --launcher "$launcher=$main_module/$main_class" \
  --module-path "$module_path" \
  --output "$runtime_image" \
  --strip-debug
