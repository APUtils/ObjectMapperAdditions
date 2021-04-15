#!/bin/bash

fixWarnings() {
    # Project last update check to 12.0
    sed -i '' -e 's/LastUpgradeCheck = 1100;/LastUpgradeCheck = 9999;/g' 'Pods/Pods.xcodeproj/project.pbxproj'
    
    # Schemes last update verions to 11.2
    find Pods/Pods.xcodeproj/xcuserdata -type f -name '*.xcscheme' -exec sed -i '' -e 's/LastUpgradeVersion = \"1100\"/LastUpgradeVersion = \"9999\"/g' {} +
}
