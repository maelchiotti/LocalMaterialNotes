#!/usr/bin/env sh

# Pass no parameters to build mimir for all architectures,
# or pass the desired architectures (x86, x64, armv7, arm64)

mkdirJniLibs() {
  for dir in "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/; do
    echo "Creating directory $dir/android/src/main/jniLibs/$1"
    mkdir -p "${dir}android/src/main/jniLibs/$1"
  done
}

x86() {
  echo "Building mimir for x86"

  bash scripts/build-android.sh x86

  mkdirJniLibs x86
  mv platform-build/jniLibs/x86/libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/x86/
}

x64() {
  echo "Building mimir for x64"

  bash scripts/build-android.sh x64

  mkdirJniLibs x86_64
  mv platform-build/jniLibs/x86_64/libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/x86_64/
}

armv7() {
  echo "Building mimir for armv7"

  bash scripts/build-android.sh armv7

  mkdirJniLibs armeabi-v7a
  mv platform-build/jniLibs/armeabi-v7a/libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/armeabi-v7a/
}

arm64() {
  echo "Building mimir for arm64"

  bash scripts/build-android.sh arm64

  mkdirJniLibs arm64-v8a
  mv platform-build/jniLibs/arm64-v8a/libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/arm64-v8a/
}

test -d .mimir || exit
cp .mimir-cargo.lock .mimir/Cargo.lock

bash scripts/build-android.sh
(
  cd .mimir || exit
  if [ "$#" -eq 0 ]; then
    x86
    x64
    armv7
    arm64
  else
    for arch in "$@"
    do
      case $arch in
        "x86")
          x86
          ;;
        "x64")
          x64
          ;;
        "armv7")
          armv7
          ;;
        "arm64")
          arm64
          ;;
        *)
          echo "Invalid architecture: '$arch'"
      esac
    done
  fi
)
