#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""

set -o pipefail && xcodebuild -workspace "Example/ObjectMapperAdditions.xcworkspace" -scheme "ObjectMapperAdditions-Example" -configuration "Release"  -sdk iphonesimulator | xcpretty

echo

xcodebuild -project "ObjectMapperAdditions.xcodeproj" -alltargets  -sdk iphonesimulator | xcpretty

echo ""
echo "SUCCESS!"
echo ""
