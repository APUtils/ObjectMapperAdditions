require_relative 'utils.rb'

def removeFramework(project, framework_name)
    framework_full_name = framework_name + ".framework"
    framework_path = "Carthage/Build/iOS/" + framework_full_name
    frameworks_reference = project.frameworks_group
    framework_reference = frameworks_reference[framework_full_name]
    
    # Enumerate each app target
    project.targets.each do |target|
        target.build_phases.each do |build_phase|
            if build_phase.display_name == "Carthage Copy"
                # Deleting framework from output paths and sorting
                build_phase.output_paths.delete("$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/" + framework_full_name)
                build_phase.output_paths.sort_by!(&:downcase)
                
                # Deleting framework from input paths and sorting
                build_phase.input_paths.delete("$(SRCROOT)/" + framework_path)
                build_phase.input_paths.sort_by!(&:downcase)
                
                # Deleting framewok from building phase and sorting
                target.frameworks_build_phase.remove_file_reference(framework_reference)
                target.frameworks_build_phase.sort
            end
        end
    end
    
    # Removing from Frameworks folder and sorting
    framework_reference.build_files.each { |file| file.remove_from_project }
    framework_reference&.remove_from_project
    frameworks_reference.sort
end

framework_name = ARGV[0]

if !framework_name
    framework_name = prompt "Framework name (e.g. Alamofire): "
end

if framework_name.to_s.empty?
    abort("\nFramework name is required\n".red)
end

project_path = Dir['*.xcodeproj'].first
project = Xcodeproj::Project.open(project_path)

all_framework_names = getSharediOSFrameworkNames(framework_name)
if all_framework_names.empty?
    abort("\nFramework wasn't found\n".red)
    
elsif all_framework_names.count == 1
    removeFramework(project, all_framework_names.first)
    
else
    print "\n"
    print "Available frameworks:\n"
    print all_framework_names.join("\n").blue
    print "\n"
    print "\n"
    
    framework_names_string = prompt "Please specify frameworks you want to remove separating by space (press enter to remove all): "
    
    if framework_names_string.to_s.empty?
        framework_names_string = all_framework_names.join(" ")
    end
    
    framework_names = framework_names_string.split(" ")
    framework_names.each { |framework_name| removeFramework(project, framework_name) }
end

framework_project_path = getCarthageProjectPath(framework_name)
project_dir = File.dirname(framework_project_path)
framework_cartfile = Dir[project_dir + '/Cartfile'].first
if !framework_cartfile.to_s.empty?
    data = File.read(framework_cartfile)
    unless data.nil?
        print "\nFramework dependencies:\n"
        cmd = "grep -o -E '^git.*|^binary.*' #{framework_cartfile} | sed -E 's/(github \"|git \"|binary \")//' | sed -e 's/\".*//' | sed -e 's/^.*\\\///' -e 's/\".*//' -e 's/.json//' | sort -fu"
        print (%x[ #{cmd} ]).blue
        print "\n"
        framework_names_string = prompt "Please specify dependencies you want to remove separating by space (press enter to skip): "
        framework_names = framework_names_string.split(" ")
        framework_names.each { |framework_name| removeFramework(project, framework_name) }
    end
end

# Save
project.save
