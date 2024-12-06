#!/usr/bin/env sh

# Pass no parameters to build libisar for all architectures,
# or pass the desired architectures (x86, x64, armv7, arm64)

x86() {
  echo "Building libisar for x86"

  bash tool/build_android.sh x86

  mv libisar_android_x86.so libisar.so
  mv libisar.so "$PUB_CACHE"/hosted/pub.isar-community.dev/isar_flutter_libs-*/android/src/main/jniLibs/x86/
}

x64() {
  echo "Building libisar for x64"

  bash tool/build_android.sh x64

  mv libisar_android_x64.so libisar.so
  mv libisar.so "$PUB_CACHE"/hosted/pub.isar-community.dev/isar_flutter_libs-*/android/src/main/jniLibs/x86_64/
}

armv7() {
    echo "Building libisar for armv7"

    bash tool/build_android.sh armv7

    mv libisar_android_armv7.so libisar.so
    mv libisar.so "$PUB_CACHE"/hosted/pub.isar-community.dev/isar_flutter_libs-*/android/src/main/jniLibs/armeabi-v7a/
}

arm64() {
    echo "Building libisar for arm64"

    bash tool/build_android.sh arm64

    mv libisar_android_arm64.so libisar.so
    mv libisar.so "$PUB_CACHE"/hosted/pub.isar-community.dev/isar_flutter_libs-*/android/src/main/jniLibs/arm64-v8a/
}

test -d .isar || exit
cp .isar-cargo.lock .isar/Cargo.lock
(
  cd .isar || exit
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
