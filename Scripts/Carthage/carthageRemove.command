#!/bin/bash

### Script to remove framework ###

# Assume scripts are placed in /Scripts/Carthage dir
_script_call_path="${BASH_SOURCE%/*}"
if [[ ! -d "${_script_call_path}" ]]; then _script_call_path=$(dirname "$0"); fi
cd "${_script_call_path}"

. "utils.sh"

# Font Constants
bold_text=$(tput bold)
normal_text=$(tput sgr0)

cd ..
cd ..

# Try one level up if didn't find Cartfile.
if [ ! -f "Cartfile" ]; then
    project_dir="${PWD##*/}"
    cd ..

    if [ ! -f "Cartfile" ]; then
        printf >&2 "\n${red_color}Unable to locate 'Cartfile'${no_color}\n\n"
        exit 1
    fi
fi

scripts_dir="Scripts/Carthage"

# Requires `xcodeproj` installed - https://github.com/CocoaPods/Xcodeproj
# sudo gem install xcodeproj
hash xcodeproj 2>/dev/null || { printf >&2 "\n${red_color}Requires xcodeproj installed - 'sudo gem install xcodeproj'${no_color}\n\n"; exit 1; }

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

echo ""

framework_name=$1

if [ -z $framework_name ]; then
    # Listing available frameworks
	getAllFrameworks

    # Asking which one to update
    read -p "Which framework to remove? " framework_name
fi

# Restore working directory
if [ ! -z "${project_dir}" ]; then
    cd "${project_dir}"
fi

if [ -z $framework_name ]; then
    printf >&2 "\n${red_color}Invalid framework name${no_color}\n\n"
    exit 1
elif [[ $frameworks_list = *$framework_name* ]]; then
    echo ""
    echo "Removing $framework_name from project..."

    ruby "$scripts_dir/carthageRemove.rb" $framework_name
else
    printf >&2 "\n${red_color}Invalid framework name${no_color}\n\n"
    exit 1
fi

# Update Carthage files
echo "Removing $framework_name from Carthage..."
sed -i '' "/\/$framework_name\"/d" Cartfile
sed -i '' "/\/$framework_name\"/d" Cartfile.resolved

# Update md5 check sum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
echo $cartSum > Carthage/cartSum.txt

printf >&2 "\n${bold_text}SUCCESSFULLY REMOVED FRAMEWORK${normal_text}\n\n"
