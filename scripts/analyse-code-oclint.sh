#!/bin/bash
# Author: Alex Maimescu

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

REQUIRED_PROGRAMS_IN_PATH=(
	"oclint"
	"xcpretty"
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

xcodebuild -project ZappMerchantLib.xcodeproj -scheme ZappMerchantLib -configuration Debug -sdk iphonesimulator | xcpretty -r json-compilation-database --output './compile_commands.json'
oclint-json-compilation-database " \
	-disable-rule UnusedMethodParameter \
	-disable-rule LongLine \
	-disable-rule LongMethod \
	-disable-rule LongVariableName \
	-disable-rule TooManyMethods \
	-disable-rule HighNcssMethod \
	-disable-rule TooFewBranchesInSwitchStatement \
	-disable-rule UseEarlyExitsAndContinue"
rm compile_commands.json