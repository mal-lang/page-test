#!/bin/sh

set -e

cd "$(dirname "$0")/.."

git ls-tree -r --name-only --full-name --full-tree HEAD
