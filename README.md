# Page Test

A page test.

## Release

To make a release, run:

```shell
git checkout master

release_version=1.0.0
development_version=1.0.1-SNAPSHOT

mvn release:prepare \
  -DpushChanges=false \
  -DreleaseVersion=$release_version \
  -Dtag=release/$release_version \
  -DdevelopmentVersion=$development_version
```

This will create two commits and one tag, e.g.

```
53d50c2 (HEAD -> master) [maven-release-plugin] prepare for next development iteration
ffaf61c (tag: release/1.0.0) [maven-release-plugin] prepare release release/1.0.0
```

Push the release commit to github and wait for the CI build to finish:

```shell
git push origin release/$release_version:master
```

Push the release tag and development commit to github:

```shell
git push origin release/$release_version
git push origin master
```

## License

Copyright © 2020 [Foreseeti AB](https://www.foreseeti.com/)

Licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
