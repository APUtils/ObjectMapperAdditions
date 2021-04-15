require 'pathname'
require_relative 'utils.rb'

def addFrameworkToProject(project, framework_name)
    framework_full_name = framework_name + ".framework"
    framework_path = "Carthage/Build/iOS/" + framework_full_name
    
    if !File.exist?(framework_path)
        abort("\nFramework '#{framework_name}' doesnot exist at path '#{framework_path}'.\n".red)
    end
    
    # Adding to Frameworks folder and sorting
    frameworks_group = project.frameworks_group
    framework_reference = frameworks_group.new_file framework_path
    frameworks_group.sort
    
    # Enumberate each app target
    found_carthage_copy_phase = false
    project.targets.each do |target|
        target.build_phases.each do |build_phase|
            if build_phase.display_name == "Carthage Copy"
                # Adding framewok to building phase and sort
                target.frameworks_build_phase.add_file_reference(framework_reference)
                target.frameworks_build_phase.sort
                
                # Adding framework to input paths and sort
                build_phase.input_paths.push("$(SRCROOT)/" + framework_path)
                build_phase.input_paths.sort_by!(&:downcase)
                
                # Adding framework to output paths and sort
                build_phase.output_paths.push("$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/" + framework_full_name)
                build_phase.output_paths.sort_by!(&:downcase)
                
                found_carthage_copy_phase = true
            end
        end
    end
    
    if !found_carthage_copy_phase
        abort("\n'Carthage Copy' phase doesn't exist.\n".red)
    end
end

def addFrameworkWithDependenciesToProject(project, framework_name)
    if !framework_name
        framework_name = prompt "Framework name (e.g. Alamofire): "
    end
    
    if framework_name.to_s.empty?
        abort("\nFramework name is required\n".red)
    end
    
    all_framework_names = getSharediOSFrameworkNames(framework_name)
    
    if all_framework_names.to_s.empty?
        print "\n"
        framework_names_string = prompt "Unable to automatically locate frameworks. Please specify frameworks you want to add separating by space: "
        
        if framework_names_string.to_s.empty?
            abort "Framework names are required".red
        end
        
        framework_names = framework_names_string.split(" ")
        framework_names.each { |framework_name| addFrameworkToProject(project, framework_name) }
        
    elsif all_framework_names.count == 1
        addFrameworkToProject(project, all_framework_names.first)
        
    else
        print "\n"
        print "Available frameworks:\n"
        print all_framework_names.join("\n").blue
        print "\n"
        print "\n"
        
        framework_names_string = prompt "Please specify frameworks you want to add separating by space (press enter to add all): "
        
        if framework_names_string.to_s.empty?
            framework_names_string = all_framework_names.join(" ")
        end
        
        framework_names = framework_names_string.split(" ")
        framework_names.each { |framework_name| addFrameworkToProject(project, framework_name) }
    end
    
    framework_project_path = getCarthageProjectPath(framework_name)
    
    if framework_project_path.to_s.empty?
        return
    end
    
    project_dir = File.dirname(framework_project_path)
    framework_cartfile = Dir[project_dir + '/Cartfile'].first
    
    # Handle symlink case
    if !framework_names_string.to_s.empty? && File.exist?(framework_cartfile) && File.symlink?(framework_cartfile)
        framework_cartfile = Pathname.new(framework_cartfile).realpath
    end
    
    if !framework_cartfile.to_s.empty?
        data = File.read(framework_cartfile)
        unless data.nil?
            print "\nFramework dependencies:\n"
            cmd = "grep -o -E '^git.*|^binary.*' #{framework_cartfile} | sed -E 's/(github \"|git \"|binary \")//' | sed -e 's/\".*//' | sed -e 's/^.*\\\///' -e 's/\".*//' -e 's/.json//' | sort -fu"
            print (%x[ #{cmd} ]).blue
            print "\n"
            framework_names_string = prompt "Please specify dependencies you want to add separating by space (press enter to skip): "
            framework_names = framework_names_string.split(" ")
            framework_names.each { |framework_name| addFrameworkWithDependenciesToProject(project, framework_name) }
        end
    end
end


project_path = Dir['*.xcodeproj'].first
project = Xcodeproj::Project.open(project_path)

framework_name = ARGV[0]

if framework_name.end_with?('.framework')
    addFrameworkToProject(project, framework_name.gsub('.framework', ''))
else
    addFrameworkWithDependenciesToProject(project, framework_name)
end

# Save
project.save
