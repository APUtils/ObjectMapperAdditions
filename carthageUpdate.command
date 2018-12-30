#!/bin/bash

base_dir=$(dirname "$0")
cd "$base_dir"

carthage update --platform iOS --cache-builds --use-ssh
