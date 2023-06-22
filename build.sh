#!/bin/sh

# Warning: pipefail is not a POSIX compatible option, but on OS X it works just fine.
#          OS X uses a POSIX complain version of bash as /bin/sh, but apparently it does
#          not strip away this feature. Also, this will fail if somebody forces the script
#          to be run with zsh.
set -o pipefail
set -e

source_root="$(dirname "$0")"

# You can override the xcmode used
: ${XCMODE:=xcodebuild} # must be one of: xcodebuild (default), xcpretty, xctool

# Provide a fallback value for TMPDIR, relevant for Xcode Bots
: ${TMPDIR:=$(getconf DARWIN_USER_TEMP_DIR)}

PATH=/usr/libexec:$PATH

usage() {
cat <<EOF
Usage: sh $0 command [argument]
command:
  clean:                clean up/remove all generated files
  build:                builds iOS framework

environment variables:
  CONFIGURATION: Debug or Release (default)
EOF
}

######################################
# Xcode Helpers
######################################

xcode() {
    mkdir -p build/DerivedData
    CMD="xcodebuild -IDECustomDerivedDataLocation=build/DerivedData BITCODE_GENERATION_MODE=bitcode $@"
    echo "Building with command:" $CMD
    eval "$CMD"
}


build_framework() {
    local target="$1"
    local os="$2"
    local framework_path="$3"
    local config="$CONFIGURATION"

    # Archive for each platform
    eval "xcodebuild -target $target -configuration $config -sdk $os ONLY_ACTIVE_ARCH=NO BUILD_DIR=$framework_path"
}

######################################
# Variables
######################################

COMMAND="$1"

# Use Debug config if command ends with -debug, otherwise default to Release
case "$COMMAND" in
    *-debug)
        COMMAND="${COMMAND%-debug}"
        CONFIGURATION="Debug"
        ;;
    *) CONFIGURATION=${CONFIGURATION:-Release}
esac
export CONFIGURATION

case "$COMMAND" in

    ######################################
    # Clean
    ######################################
    "clean")
        find . -type d -name build -exec rm -r "{}" +\;
        exit 0
        ;;

    ######################################
    # Building for simulator
    ######################################
    "build-simulator")
        build_framework ZappMerchantLib iphonesimulator './build'
        exit 0
        ;;

    ######################################
    # Building for device
    ######################################
    "build-device")
        build_framework ZappMerchantLib iphoneos './build'
        exit 0
        ;;

    ######################################
    # Release packaging
    ######################################

    "package-ios-simulator")
        sh build.sh build-simulator
        current_dir="$(pwd)"

        pushd build/
        rm -rf package/Release-iphonesimulator
        mkdir -p package
        cd package
        cp "$current_dir/README.md" .

        cp -r ../Release-iphonesimulator .
        rm -rf ../Release-iphonesimulator
        rm -rf ../ZappMerchantLib.build
        rm -rf ../XCBuildData
        printf "\n\nFramework created for simulator in package -> Release-iphonesimulator directory\n\n\n"

        package_dir=$(pwd)

        popd

    exit 0
    ;;

    "package-ios-device")
        sh build.sh build-device
        current_dir="$(pwd)"

        pushd build/

        rm -rf package/Release-iphoneos
        mkdir -p package
        cd package
        cp "$current_dir/README.md" .

        cp -r ../Release-iphoneos .
        rm -rf ../Release-iphoneos
        rm -rf ../ZappMerchantLib.build
        rm -rf ../XCBuildData

        printf "\n\nFramework created for device in package -> Release-iphoneos directory\n\n\n"

        package_dir=$(pwd)

        popd

        ;;

    *)
    echo "Unknown command '$COMMAND'"
    usage
    exit 1
    ;;
esac
