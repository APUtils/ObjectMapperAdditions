#!/bin/bash

base_dir=$(dirname "$0")
cd "$base_dir"

xcodebuild
xcodebuild -workspace Example/ObjectMapperAdditions.xcworkspace -scheme ObjectMapperAdditions-Example -destination 'platform=iOS Simulator,name=iPhone SE,OS=11.4'
