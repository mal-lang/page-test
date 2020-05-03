#!/bin/sh

set -e

cd "$(dirname "$0")/.."
base_dir="$PWD"
pre_commit="$base_dir/.git/hooks/pre-commit"

{
  echo "#!/bin/sh"
  echo
  echo "cd \"\$(dirname \"\$0\")/../..\""
  echo "base_dir=\"\$PWD\""
  echo "pre_commit=\"\$base_dir/scripts/pre-commit.sh\""
  echo
  echo "\"\$pre_commit\""
} > "$pre_commit"

chmod a+x "$pre_commit"
