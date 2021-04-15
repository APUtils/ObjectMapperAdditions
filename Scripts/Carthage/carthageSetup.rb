begin
  require 'xcodeproj'
rescue LoadError => e
  raise unless e.message =~ /some_gem/
  puts 'please install xcodeproj first!'
end

# Input
def prompt(*args)
    print(*args)
    STDIN.gets.strip
end

def setupTarget(target)
    puts "Updating '#{target.name}' target...".blue
    # Framework search path
    puts "Updating framework search paths...".blue
    if !target.common_resolved_build_setting("FRAMEWORK_SEARCH_PATHS")&.include?("$(PROJECT_DIR)/Carthage/Build/iOS")
        target.build_configurations.each { |build_configuration|
            framework_search_paths = build_configuration.build_settings["FRAMEWORK_SEARCH_PATHS"]
            if framework_search_paths
                framework_search_paths << "$(PROJECT_DIR)/Carthage/Build/iOS"
                puts framework_search_paths
                build_configuration.build_settings["FRAMEWORK_SEARCH_PATHS"] = framework_search_paths
            else
                build_configuration.build_settings["FRAMEWORK_SEARCH_PATHS"] = ["$(inherited)", "$(PROJECT_DIR)/Carthage/Build/iOS"]
            end
        }
    end
    
    # Carthage Install
    puts "Updating 'Carthage Install' build phase...".blue
    carthage_install_build_phase = target.shell_script_build_phases.detect { |x| x.name == "Carthage Install" || x.shell_script.include?("carthageInstall.command") }
    if !carthage_install_build_phase
        carthage_install_build_phase = target.new_shell_script_build_phase("Carthage Install")
    end
    carthage_install_build_phase.name = "Carthage Install"
    carthage_install_build_phase.shell_path = '/bin/bash'
    carthage_install_build_phase.shell_script = "source ~/.bash_profile\nenv -i GITHUB_ACCESS_TOKEN=\"$GITHUB_ACCESS_TOKEN\" DEVELOPER_DIR=\"$DEVELOPER_DIR\" PATH=\"$PATH\" bash \"Scripts/Carthage/carthageInstall.command\"\n"
    target.build_phases.move(carthage_install_build_phase, 0)
    
    
    # Carthage Copy
    puts "Updating 'Carthage Copy' build phase...".blue
    carthge_copy_build_phase = target.shell_script_build_phases.detect { |x| x.name == "Carthage Copy" || x.shell_script.include?("/usr/local/bin/carthage copy-frameworks") }
    if !carthge_copy_build_phase
        carthge_copy_build_phase = target.new_shell_script_build_phase("Carthage Copy")
    end
    carthge_copy_build_phase.name = "Carthage Copy"
    carthge_copy_build_phase.shell_path = '/bin/sh'
    carthge_copy_build_phase.shell_script = "/usr/local/bin/carthage copy-frameworks\n"
end

# Colorization
class String
    def colorize(color_code)
        "\e[#{color_code}m#{self}\e[0m"
    end
    
    def red
        colorize(31)
    end
    
    def green
        colorize(32)
    end
    
    def yellow
        colorize(33)
    end
    
    def blue
        colorize(34)
    end
    
    def light_blue
        colorize(36)
    end
end

target_names = ARGV[0]&.split(' ')

project_path = Dir['*.xcodeproj'].first
project = Xcodeproj::Project.open(project_path)

# Create _Carthage folder with script files
puts "Updating '_Carthage' directory and scripts...".blue
carthage_folder = project.frameworks_group['_Carthage'] || project.frameworks_group.new_group('_Carthage')
project.frameworks_group.sort()
if !carthage_folder['carthageAdd.command']
    carthage_folder.new_file('Scripts/Carthage/carthageAdd.command')
end
if !carthage_folder['carthageRemove.command']
    carthage_folder.new_file('Scripts/Carthage/carthageRemove.command')
end
if !carthage_folder['carthageUpdate.command']
    carthage_folder.new_file('Scripts/Carthage/carthageUpdate.command')
end
carthage_folder.sort

if !target_names
    all_target_names = project.native_targets.map { |native_target| native_target.name }

    print "\n"
    print "Available targets:\n"
    print all_target_names.join("\n").blue
    print "\n"
    print "\n"

    target_names_to_setup = prompt "Please specify targets you want to setup separating by comma: "
    target_names = target_names_to_setup.split(',')
    
    if target_names.to_s.empty?
        abort("\Target name is required\n".red)
    end
end

targets_to_setup = project.native_targets.select { |native_target| target_names.include?(native_target.name) }
targets_to_setup.each { |target| setupTarget(target) }

# Save
project.save
