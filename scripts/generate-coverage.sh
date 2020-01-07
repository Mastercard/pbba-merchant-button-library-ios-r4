#!/bin/bash
# Author: Alex Maimescu

BUILD_OUTPUT="build"
REPORTS_OTPUT="$BUILD_OUTPUT/reports"
COVERAGE_OUTPUT="$REPORTS_OTPUT/coverage"

WORKSPACE="ZappMerchantLib.xcworkspace"
PROJECT="ZappMerchantLib.xcodeproj"
SCHEME="ZappMerchantLibTests"

# Required tools
#  - xcodebuild: Xcode command line tool
#  - xcpretty: Install ruby gem (sudo gem install xcpretty)
#  - slather: Install ruby gem (sudo gem install slather)
REQUIRED_PROGRAMS_IN_PATH=(
	"xcodebuild"
 	"xcpretty"
 	"slather"
)

function validateTools() {

	count=0
	while [ "x${REQUIRED_PROGRAMS_IN_PATH[$count]}" != "x" ]
	do
	   	program=${REQUIRED_PROGRAMS_IN_PATH[$count]}

		hash $program 2>/dev/null
		if [ $? -eq 1 ]; then
			echo >&2 "ERROR - $program is not installed or not in your PATH"; exit 1;
		fi

	   count=$(( $count + 1 ))
	done
}

# Validate toolset
echo "[VALIDATE TOOLSET]"
validateTools

# Run tests
echo "[RUN TESTS]"
xcodebuild test -workspace $WORKSPACE -scheme $SCHEME -configuration "Debug" -sdk "iphonesimulator" -derivedDataPath "$BUILD_OUTPUT" -destination "platform=iOS Simulator,name=iPhone 6s" -enableCodeCoverage YES | xcpretty -c -r html
# Generate detailed code coverage
echo "[GENERATE COVERAGE REPORT]"
slather coverage --build-directory "$BUILD_OUTPUT" -i "Pods/*" -i "ZappMerchantLibTests/*" -i "../*" --output-directory "$COVERAGE_OUTPUT" --html --show "$PROJECT"