#!/usr/bin/env sh

# Pass no parameters to build mimir for all architectures,
# or pass the desired architectures (x86, x64, armv7, arm64)

x86() {
  echo "Building mimir for x86"

  bash scripts/build-android.sh x86

  cd platform-build
  mv libembedded_milli_android_x86.so libembedded_milli.so
  mv libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/x86/
}

x64() {
  echo "Building mimir for x64"

  bash scripts/build-android.sh x64

  cd platform-build
  mv libembedded_milli_android_x64.so libembedded_milli.so
  mv libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/x86_64/
}

armv7() {
  echo "Building mimir for armv7"

  bash scripts/build-android.sh armv7

  cd platform-build
  mv libembedded_milli_android_armv7.so libembedded_milli.so
  mv libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/armeabi-v7a/
}

arm64() {
  echo "Building mimir for arm64"

  bash scripts/build-android.sh arm64

  cd platform-build
  mv libembedded_milli_android_arm64.so libembedded_milli.so
  mv libembedded_milli.so "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/arm64-v8a/
}

test -d .mimir || exit
cp .mimir-cargo.lock .mimir/Cargo.lock

for dir in "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*; do
  echo "Creating directory $dir/android/src/main/jniLibs"
  mkdir "$dir"/android/src/main/jniLibs
done

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




  echo "Building mimir"

  bash scripts/build-android.sh

  for dir in "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*; do
    echo "Creating directory $dir/android/src/main/jniLibs"
    mkdir "$dir"/android/src/main/jniLibs
  done
  mv platform-build/EmbeddedMilliAndroid.tar.gz "$PUB_CACHE"/hosted/pub.dev/flutter_mimir-*/android/src/main/jniLibs/