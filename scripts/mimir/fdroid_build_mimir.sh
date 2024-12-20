#!/usr/bin/env sh

test -d .mimir || exit
(
  cd .mimir || exit

  echo "Building mimir"

  for dir in "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*; do
    echo "Creating directory $dir/android/src/main/jniLibs"
    mkdir "$dir"/android/src/main/jniLibs
  done

  bash scripts/build-android.sh


  mv platform-build/EmbeddedMilliAndroid.tar.gz "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/
)