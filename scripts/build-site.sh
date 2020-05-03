#!/bin/sh

set -e

release_tags() {
  git tag --list "release/*" --sort=-version:refname
}

tag_date() {
  git log -1 --format="%aI" "$1"
}

head_date() {
  tag_date "HEAD"
}

get_old_site() {
  repo_url="$(echo "$1" | sed "s/^scm:git://g")"
  site_dir="$2"

  git clone \
    --quiet \
    --branch "gh-pages" \
    --depth 1 \
    -- \
    "$repo_url" \
    "$site_dir"

  rm -rf "$site_dir/.git"
  rm -rf "$site_dir/snapshot"
  rm -rf "$site_dir/css"
  rm -rf "$site_dir/fonts"
  rm -rf "$site_dir/images"
  rm -rf "$site_dir/img"
  rm -rf "$site_dir/js"
  rm -f "$site_dir/index.html"
  rm -f "$site_dir/releases.html"
}

generate_releases_css() {
  site_css="$1"
  mkdir -p "$(dirname "$site_css")"
  {
    echo ".sidebar-nav {"
    echo "  display: none;"
    echo "}"
  } > "$site_css"
}

restore_releases_css() {
  site_css="$1"
  git checkout -- "$site_css"
}

generate_releases_apt() {
  releases_apt="$1"
  url="$2"
  tag="$3"

  mkdir -p "$(dirname "$releases_apt")"
  {
    echo "                                    --------"
    echo "                                    Releases"
    echo "                                    --------"
    echo
    echo "Releases"
    echo
    echo "*--*--*"
    echo " <<Release>> | <<Date>>"
    echo "*--*--*"
    echo " {{{${url}snapshot/}SNAPSHOT}} | $(head_date)"
    echo "*--*--*"
  } > "$releases_apt"

  if [ "$tag" != "HEAD" ]; then
    version="$(echo "$tag" | cut -d "/" -f 2)"
    {
      echo " {{{${url}$version/}$version}} | $(head_date)"
      echo "*--*--*"
    } >> "$releases_apt"
  fi

  for release_tag in $(release_tags); do
    version="$(echo "$release_tag" | cut -d "/" -f 2)"
    {
      echo " {{{${url}$version/}$version}} | $(tag_date "$release_tag")"
      echo "*--*--*"
    } >> "$releases_apt"
  done
}

restore_releases_apt() {
  releases_apt="$1"
  rm -rf "$(dirname "$releases_apt")"
}

generate_releases_page() {
  base_dir="$1"
  site_dir="$2"
  url="$3"
  tag="$4"

  site_css="$base_dir/src/site/resources/css/site.css"
  generate_releases_css "$site_css"

  releases_apt="$base_dir/src/site/apt/releases.apt"
  generate_releases_apt "$releases_apt" "$url" "$tag"

  mvn -B -q clean verify site
  cp "$base_dir/target/site/releases.html" "$site_dir"
  cp -r "$base_dir/target/site/css" "$site_dir"
  cp -r "$base_dir/target/site/fonts" "$site_dir"
  cp -r "$base_dir/target/site/images" "$site_dir"
  cp -r "$base_dir/target/site/img" "$site_dir"
  cp -r "$base_dir/target/site/js" "$site_dir"

  restore_releases_css "$site_css"
  restore_releases_apt "$releases_apt"
}

build_release_site() {
  base_dir="$1"
  site_dir="$2"
  url="$3"
  tag="$4"

  version="$(echo "$tag" | cut -d "/" -f 2)"

  # Add version to url in pom.xml
  sed -i "s|^  <url>$url</url>$|  <url>$url$version/</url>|g" "$base_dir/pom.xml"

  # Add version to breadcrumbs in site.xml
  cat << EOF | ed -s "$base_dir/src/site/site.xml"
/<breadcrumbs>/+2a
      <item name="$version" href="$url$version/"/>
.
wq
EOF

  # Build release site
  mvn -B -q clean verify site
  cp -r "$base_dir/target/site" "$site_dir/$version"

  # Remove version from url in pom.xml
  sed -i "s|^  <url>$url$version/</url>$|  <url>$url</url>|g" "$base_dir/pom.xml"

  # Remove version from breadcrumbs in site.xml
  cat << EOF | ed -s "$base_dir/src/site/site.xml"
/<breadcrumbs>/+3d
wq
EOF
}

build_snapshot_site() {
  base_dir="$1"
  site_dir="$2"
  url="$3"
  project_name="$4"

  # Add snapshot to url in pom.xml
  sed -i "s|^  <url>$url</url>$|  <url>${url}snapshot/</url>|g" "$base_dir/pom.xml"

  # Add snapshot to breadcrumbs in site.xml
  cat << EOF | ed -s "$base_dir/src/site/site.xml"
/<breadcrumbs>/+2a
      <item name="SNAPSHOT" href="${url}snapshot/"/>
.
wq
EOF

  # Build snapshot site
  mvn -B -q clean verify site
  cp -r "$base_dir/target/site" "$site_dir/snapshot"
  {
    echo "<!DOCTYPE html>"
    echo "<meta charset=\"utf-8\">"
    echo "<title>$project_name</title>"
    echo "<meta http-equiv=\"refresh\" content=\"0; URL=${url}snapshot/\">"
    echo "<link rel=\"canonical\" href=\"${url}snapshot/\">"
  } > "$site_dir/index.html"

  # Remove snapshot from url in pom.xml
  sed -i "s|^  <url>${url}snapshot/</url>$|  <url>$url</url>|g" "$base_dir/pom.xml"

  # Remove snapshot from breadcrumbs in site.xml
  cat << EOF | ed -s "$base_dir/src/site/site.xml"
/<breadcrumbs>/+3d
wq
EOF
}

build_site() {
  cd "$(dirname "$0")/.."
  base_dir="$PWD"
  scripts_dir="$base_dir/scripts"
  site_dir="$base_dir/site"
  rm -rf "$site_dir"

  project_name="$("$scripts_dir/pom-property.sh" "project.name")"
  project_url="$("$scripts_dir/pom-property.sh" "project.url")"
  project_scm_connection="$("$scripts_dir/pom-property.sh" "project.scm.connection")"
  project_scm_tag="$("$scripts_dir/pom-property.sh" "project.scm.tag")"

  if [ -n "$(release_tags)" ]; then
    # There are releases to preserve
    get_old_site "$project_scm_connection" "$site_dir"
  else
    # There are no releases to preserve
    mkdir -p "$site_dir"
  fi

  generate_releases_page "$base_dir" "$site_dir" "$project_url" "$project_scm_tag"

  if [ "$project_scm_tag" != "HEAD" ]; then
    build_release_site "$base_dir" "$site_dir" "$project_url" "$project_scm_tag"
  fi

  build_snapshot_site "$base_dir" "$site_dir" "$project_url" "$project_name"
}

build_site
