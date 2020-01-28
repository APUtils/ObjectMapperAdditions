#!/bin/bash

### Script to setup Cocoapods for a project target ###

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

_post_instal_phase="\npost_install do |installer|\n  # Add podInstall.command and podUpdate.command shell scripts to Pods project\n  pods_project = installer.pods_project\n  pods_project.new_file \"../Scripts/Cocoapods/podInstall.command\"\n  pods_project.new_file \"../Scripts/Cocoapods/podUpdate.command\"\n\n  # Silence Pods project warning\n  installer.pods_project.build_configurations.each do |config|\n    config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'\n  end\nend\n"
addPostIstallPhase() {
    printf "${_post_instal_phase}" >> "Podfile"
}

# Assume scripts are placed in /Scripts/Cocoapods dir
base_dir=$(dirname "$0")
cd "$base_dir"

. "utils"

cd ..
cd ..

# Podfile Update
printf >&2 "\n${blue_color}Updating Podfile...${no_color}\n"
touch "Podfile"
if ! $(grep -q -F 'pods_project.new_file "../Scripts/Cocoapods/podInstall.command"' "Podfile"); then
    # Need to update Podfile
    if ! $(grep -q -F 'post_install' "Podfile"); then
        # Need to create post_install phase
		addPostIstallPhase
		
    else
		askForContinue "${yellow_color}Your Podfile already have \'post_install\' phase. Do you want to override it? (Y/n) ${no_color}"
		if [ "${continue}" = "true" ]; then
			# Remove post_install phase first
			sed -i '' '/^post_install/,/^end/d' 'Podfile'
			addPostIstallPhase
			
		else
	        # Need to update post_install phase
		    printf >&2 "${yellow_color}You have to manually add those lines:${no_color}\n"
		    printf "${_post_instal_phase}\n"
		fi
    fi
fi

# .gitignore Update
printf >&2 "\n${blue_color}Updating .gitignore...${no_color}\n"
if ! grep -q -F "Pods/" ".gitignore"; then
    printf "\n/Pods/\n" >> ".gitignore"
elif ! grep -q -F "/Pods/" ".gitignore"; then
    sed -i '' 's/Pods\//\/Pods\//g' ".gitignore"
fi

printf >&2 "\n${blue_color}Executing 'pod install'...${no_color}\n"
bash "Scripts/Cocoapods/podInstall.command"

# Success
printf >&2 "\n${bold_text}PROJECT SETUP SUCCESS${normal_text}\n\n"
