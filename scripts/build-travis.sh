#!/bin/sh

set -e

expected_os="linux"
expected_dist="bionic"
expected_jdk="openjdk11"
expected_slug="mal-lang/page-test"
expected_branch="master"

if [ "$TRAVIS_BRANCH" = "gh-pages" ]; then
  echo "Skipping build and deploy, current branch is \"$TRAVIS_BRANCH\""
  exit 0
fi

mvn -B -V clean install site

if [ "$TRAVIS_OS_NAME" != "$expected_os" ]; then
  echo "Skipping deploy, current os \"$TRAVIS_OS_NAME\" != \"$expected_os\""
  exit 0
fi

if [ "$TRAVIS_DIST" != "$expected_dist" ]; then
  echo "Skipping deploy, current dist \"$TRAVIS_DIST\" != \"$expected_dist\""
  exit 0
fi

if [ "$TRAVIS_JDK_VERSION" != "$expected_jdk" ]; then
  echo "Skipping deploy, current jdk \"$TRAVIS_JDK_VERSION\" != \"$expected_jdk\""
  exit 0
fi

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Skipping deploy, pull request"
  exit 0
fi

if [ "$TRAVIS_REPO_SLUG" != "$expected_slug" ]; then
  echo "Skipping deploy, current slug \"$TRAVIS_REPO_SLUG\" != \"$expected_slug\""
  exit 0
fi

if [ "$TRAVIS_BRANCH" != "$expected_branch" ]; then
  echo "Skipping deploy, current branch \"$TRAVIS_BRANCH\" != \"$expected_branch\""
  exit 0
fi

sudo apt -y update
sudo apt -y install xqilla
scripts/build-site.sh
