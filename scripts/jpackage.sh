#!/bin/sh

set -e

cd "$(dirname "$0")/.."

artifact_id="$(scripts/print-pom-property.sh "project.artifactId")"
version="$(scripts/print-pom-property.sh "project.version")"
description="$(scripts/print-pom-property.sh "project.description")"

main_module="org.mal_lang.page.test"
main_class="org.mal_lang.page.test.Main"

app_image="$PWD/$artifact_id-$version-app-image"
module_path="$(scripts/print-module-path.sh)"

jpackage \
  --type app-image \
  --app-version "$version" \
  --copyright "Copyright © 2020 Foreseeti AB, Licensed under the Apache License, Version 2.0." \
  --description "$description" \
  --name "$artifact_id" \
  --dest "$app_image" \
  --add-modules "$main_module" \
  --module-path "$module_path" \
  --module "$main_module/$main_class"
