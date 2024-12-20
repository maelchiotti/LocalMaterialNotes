#!/usr/bin/env sh

test -d .mimir || exit
(
  cd .mimir || exit

  echo "Building mimir"

  bash scripts/build-android.sh

  mv platform-build/EmbeddedMilliAndroid.tar.gz "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs
)