#!/bin/bash

# Colors Constants
red_color='\033[0;31m'
green_color='\033[0;32m'
yellow_color='\033[0;33m'
blue_color='\033[0;34m'
no_color='\033[0m'

# Font Constants
bold_text=$(tput bold)
normal_text=$(tput sgr0)

# First parameter - message
# Second parameter - retype message. Optional.
askForContinue() {
	local message="${1}"
	local retype_message="${2}"
	while true; do
		printf "${message}"
		read yn
		case $yn in
		    [Yy]* ) continue=true; break;;
		    [Nn]* ) continue=fase; break;;
		    * ) [ -n "${retype_message}" ] && echo "${retype_message}";;
		esac
	done
}

fixWarnings() {
    # Project last update check fix
    sed -i '' -e $'s/LastUpgradeCheck = [0-9]*;/LastUpgradeCheck = 9999;\\\n\t\t\t\tLastSwiftMigration = 9999;/g' 'Pods/Pods.xcodeproj/project.pbxproj'
    
    # Schemes last update verions fix
    find Pods/Pods.xcodeproj/xcuserdata -type f -name '*.xcscheme' -exec sed -i '' -e 's/LastUpgradeVersion = \"[0-9]*\"/LastUpgradeVersion = \"9999\"/g' {} +
}
