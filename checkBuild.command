#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""
echo ""
echo "Building Pods project..."
set -o pipefail && xcodebuild -workspace "Example/ObjectMapperAdditions.xcworkspace" -scheme "ObjectMapperAdditions-Example" -configuration "Release" -sdk iphonesimulator | xcpretty

echo -e "\nBuilding Carthage project..."
set -o pipefail && xcodebuild -project "ObjectMapperAdditions.xcodeproj" -sdk iphonesimulator -target "ObjectMapperAdditions-iOS" | xcpretty
set -o pipefail && xcodebuild -project "ObjectMapperAdditions.xcodeproj" -sdk macosx -target "ObjectMapperAdditions-macOS" | xcpretty
set -o pipefail && xcodebuild -project "ObjectMapperAdditions.xcodeproj" -sdk appletvsimulator -target "ObjectMapperAdditions-tvOS" | xcpretty
set -o pipefail && xcodebuild -project "ObjectMapperAdditions.xcodeproj" -sdk watchsimulator -target "ObjectMapperAdditions-watchOS" | xcpretty

echo -e "\nBuilding with Carthage..."
carthage build --no-skip-current --cache-builds

echo -e "\nPerforming tests..."
simulator_id="$(xcrun simctl list devices available | grep "iPhone SE" | tail -1 | sed -e "s/.*iPhone SE (//g" -e "s/).*//g")"
if [ -z "${simulator_id}" ]; then
    echo "error: Please install 'iPhone SE' simulator."
    echo " "
    exit 1
else
    echo "Using iPhone SE simulator with ID: '${simulator_id}'"
fi

set -o pipefail && xcodebuild -workspace "Example/ObjectMapperAdditions.xcworkspace" -sdk iphonesimulator -scheme "ObjectMapperAdditions-Example" -destination "platform=iOS Simulator,id=${simulator_id}" test | xcpretty

echo ""
echo "SUCCESS!"
echo ""
echo ""
