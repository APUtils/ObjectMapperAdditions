#!/bin/bash

base_dir=$(dirname "$0")
cd "$base_dir"

# Checking lib lint
pod lib lint --verbose --no-clean

# Checking spec lint
pod spec lint --verbose --no-clean
