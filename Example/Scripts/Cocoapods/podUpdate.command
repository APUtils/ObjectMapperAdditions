#!/bin/bash

# Assume scripts are placed in /Scripts/Cocoapods dir
_script_call_path="${BASH_SOURCE%/*}"
if [[ ! -d "${_script_call_path}" ]]; then _script_call_path=$(dirname "$0"); fi
cd "${_script_call_path}"

. ./utils.sh

cd ..
cd ..

# Listing available pods
echo ""
echo "Pods list:"

# Blue color
printf '\033[0;34m'

# Pods list
grep -o "pod \'[a-zA-Z0-9\.\/-]*\'" Podfile | sed -e "s/^pod \'//" -e "s/\'$//" | sort -fu

# No color
printf '\033[0m'
echo ""

# Asking which one to update
read -p "Which pod to update? Press enter to update all: " pod_name

# Check if pod has git repository attached
if [ -n "${pod_name}" ] && grep -cq "\- ${pod_name}.*(from " Podfile.lock; then
    # Pod has git repository attached. No need to fetch pods repo.
    pod update ${pod_name} --no-repo-update
else
    # Trigger specific or all pod update
    pod update ${pod_name}
fi

echo "Fixing warnings"
fixWarnings
