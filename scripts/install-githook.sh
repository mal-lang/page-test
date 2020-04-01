#!/bin/sh

set -e

cd "$(dirname "$0")/.."

. "scripts/try.sh"

try \
  "Installing githook..." \
  "cp \"scripts/pre-commit\" \".git/hooks/pre-commit\""
