#!/bin/bash

### Script to setup Cocoapods for a project target ###

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

# Colors Constants
red_color='\033[0;31m'
green_color='\033[0;32m'
yellow_color='\033[0;33m'
blue_color='\033[0;34m'
no_color='\033[0m'

# Font Constants
bold_text=$(tput bold)
normal_text=$(tput sgr0)

# Assume scripts are placed in /Scripts/Cocoapods dir
base_dir=$(dirname "$0")
cd "$base_dir"
cd ..
cd ..

# Podfile Update
printf >&2 "${blue_color}Updating Podfile...${no_color}\n"
touch "Podfile"
if ! $(grep -q -F 'pods_project.new_file "../Scripts/Cocoapods/podInstall.command"' "Podfile"); then
    # Need to update Podfile
    if ! $(grep -q -F 'post_install' "Podfile"); then
        # Need to create post_install phase
        printf "\npost_install do |installer|\n    # Add podInstall.command and podUpdate.command shell scripts to Pods project\n    pods_project = installer.pods_project\n    pods_project.new_file \"../Scripts/Cocoapods/podInstall.command\"\n    pods_project.new_file \"../Scripts/Cocoapods/podUpdate.command\"\nend\n" >> "Podfile"
    else
        # Need to update post_install phase
    printf >&2 "\n${yellow_color}Your Podfile already have \'post_install\' phase. You have to manually add those lines:${no_color}\n"
    printf "post_install do |installer|\n    # Add podInstall.command and podUpdate.command shell scripts to Pods project\n    pods_project = installer.pods_project\n    pods_project.new_file \"../Scripts/Cocoapods/podInstall.command\"\n    pods_project.new_file \"../Scripts/Cocoapods/podUpdate.command\"\nend\n\n"
    fi
fi

# .gitignore Update
printf >&2 "${blue_color}Updating .gitignore...${no_color}\n"
if ! grep -q -F "Pods/" ".gitignore"; then
    printf "\n/Pods/\n" >> ".gitignore"
elif ! grep -q -F "/Pods/" ".gitignore"; then
    sed -i '' 's/Pods\//\/Pods\//g' ".gitignore"
fi

# Success
printf >&2 "\n${bold_text}PROJECT SETUP SUCCESS${normal_text}\n\n"
