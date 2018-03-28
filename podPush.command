#!/bin/bash

base_dir=$(dirname "$0")
cd "$base_dir"

# Pushing latest version to cocoapods
pod trunk push --allow-warnings
