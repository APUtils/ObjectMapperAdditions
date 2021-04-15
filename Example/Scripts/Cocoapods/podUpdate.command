#!/bin/bash

# Assume scripts are placed in /Scripts/Cocoapods dir
base_dir=$(dirname "$0")
cd "$base_dir"

. utils.sh

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
if grep -cq "\- ${pod_name}.*(from " Podfile.lock; then
    # Pod has git repository attached. No need to fetch pods repo.
    pod update $pod_name --no-repo-update
else
    # Trigger specific or all pod update
    pod update $pod_name
fi

exit_code=$?

# Check if repo needs update
# * `31` Spec not found (i.e out-of-date source repos, mistyped Pod name etc...)
echo "Exit code: ${exit_code}"
if [ ${exit_code} -eq 31 ]; then
    echo "Fixing outdated repo"
    pod repo update
    pod update $pod_name
    
elif [ ${exit_code} -eq 0 ]; then
    # Break
    :
    
else
    exit ${exit_code}
fi

echo "Fixing warnings"
fixWarnings
