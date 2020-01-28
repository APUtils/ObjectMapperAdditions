#!/bin/bash

# Assume scripts are placed in /Scripts/Cocoapods dir
base_dir=$(dirname "$0")
cd "$base_dir"

. utils

cd ..
cd ..

pod install

# Check if repo needs update
# * `31` Spec not found (i.e out-of-date source repos, mistyped Pod name etc...)
if [ $? -eq 31 ]; then
    pod repo update
    pod install
fi

echo "Fixing warnings"
fixWarnings
