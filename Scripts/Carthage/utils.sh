#!/bin/bash

### Script to remove framework ###

# Colors Constants
red_color='\033[0;31m'
green_color='\033[0;32m'
blue_color='\033[0;34m'
no_color='\033[0m'

getFrameworks() {
	file_name="${1}"
	grep -o -E "^git.*|^binary.*" "${file_name}" | sed -E "s/(github \"|git \"|binary \")//" | sed -e "s/\".*//" | sed -e "s/^.*\///" -e "s/\".*//" -e "s/.json//"
}

getAllFrameworks() {
    echo ""
    echo "Frameworks list:"

    # Blue color
    printf '\033[0;34m'

    if [ -f "Cartfile" ]; then
        public_frameworks=$(getFrameworks Cartfile)
    fi
    
    if [ -f "Cartfile.private" ]; then
        private_frameworks=$(getFrameworks Cartfile.private)
    fi
    
	frameworks_list=$(echo -e "${public_frameworks}\n${private_frameworks}" | sort -fu | sed '/^$/d')
    printf "$frameworks_list\n"

    # No color
    printf '\033[0m'
    echo ""
}

# https://github.com/mapbox/mapbox-navigation-ios/blob/master/scripts/wcarthage.sh
applyXcode12Workaround() {
    echo "Applying Xcode 12 workaround..."

    echo "Cleanup Carthage temporary items"
    for i in {1..1000}; do
        dir_name="${TMPDIR}TemporaryItems/(A Document Being Saved By carthage ${i})"
        [ -e "${dir_name}" ] && rm -rf "${dir_name}" || true
    done
    
    xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
    trap 'rm -f "${xcconfig}"' INT TERM HUP EXIT
    
    # For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
    # the build will fail on lipo due to duplicate architectures.
    echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
    echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

    export XCODE_XCCONFIG_FILE="${xcconfig}"
    echo "Workaround applied. xcconfig here: ${XCODE_XCCONFIG_FILE}"
}
