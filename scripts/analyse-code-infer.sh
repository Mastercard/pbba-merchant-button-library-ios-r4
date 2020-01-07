#!/bin/bash
# Author: Alex Maimescu

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

REQUIRED_PROGRAMS_IN_PATH=(
	"infer"
	"xcodebuild"
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

infer -- xcodebuild clean build -project ZappMerchantLib.xcodeproj -scheme ZappMerchantLib -configuration Debug -sdk iphonesimulator

