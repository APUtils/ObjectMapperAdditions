#!/bin/bash

### Script to install frameworks ###

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

# Assume scripts are placed in /Scripts/Carthage dir
_script_call_path="${BASH_SOURCE%/*}"
if [[ ! -d "${_script_call_path}" ]]; then _script_call_path=$(dirname "$0"); fi
cd "${_script_call_path}"

# includes
. ./utils.sh

cd ..
cd ..

applyXcode12Workaround

# Try one level up if didn't find Cartfile.
if [ ! -f "Cartfile" ]; then
    cd ..

    if [ ! -f "Cartfile" ]; then
        printf >&2 "\n${red_color}Unable to locate 'Cartfile'${no_color}\n\n"
        exit 1
    fi
fi

cart_sum_file="Carthage/cartSumTests.txt"

mkdir -p "Carthage"
touch "$cart_sum_file"
if [ ! -f "$cart_sum_file" ]; then
    prevSum="null"
else
    prevSum=`cat $cart_sum_file`
fi

# Get checksum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`

if [ "$prevSum" != "$cartSum" ] || [ ! -d "Carthage/Build/iOS" ]; then
    echo "Carthage frameworks are outdated. Updating..."
    rm "$cart_sum_file" 2> /dev/null || :

    # Install needed frameworks.
    carthage bootstrap --platform iOS,tvOS --cache-builds

    # Update checksum file
    cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
    echo "$cartSum" > "$cart_sum_file"
else
    echo "Carthage frameworks up to date"
fi
