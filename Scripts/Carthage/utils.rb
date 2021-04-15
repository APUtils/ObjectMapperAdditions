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

class Xcodeproj::Project::Object::PBXNativeTarget
    def iOSSharedFramework?(framework_shared_schemes)
        isIOS = common_resolved_build_setting("SUPPORTED_PLATFORMS")&.include?("iphoneos") || platform_name == :ios
        
        # Check target configuration file also
        isIOS = isIOS || getConfigAttributes(self)&.dig("SUPPORTED_PLATFORMS")&.include?("iphoneos")
        
        # CHECK INCLUDES ALSO OMG WHY?! Defenitelly need to improve xcodeproj to resolve those settings properly. I'm out.
        
        isFramework = symbol_type == :framework
        isShared = framework_shared_schemes.include?(name)
        
        isIOS && isFramework && isShared
    end
end

# Returns file config attributes for a target
def getConfigAttributes(framework_target)
    default_configuration = framework_target.build_configuration_list[framework_target.build_configuration_list.default_configuration_name]
    base_configuration_reference = default_configuration.base_configuration_reference
    if !base_configuration_reference&.real_path.to_s.empty? && File.file?(base_configuration_reference.real_path)
        config = Xcodeproj::Config.new(base_configuration_reference.real_path)
        config.attributes
    else
        return nil
    end
end

# Returns shared iOS framework names
def getSharediOSFrameworkNames(framework_name)
    # TODO: Need to handle multiple projects
    framework_project_path = getCarthageProjectPath(framework_name)
    
    if framework_project_path.to_s.empty?
        return nil
    end
    
    framework_project = Xcodeproj::Project.open(framework_project_path)
    framework_shared_schemes = Xcodeproj::Project.schemes(framework_project_path)
    framework_targets = framework_project.native_targets.select { |framework_target| framework_target.iOSSharedFramework?(framework_shared_schemes) }
    all_framework_names = framework_targets.map { |framework_target|
        # Check target configuration file first
        framework_name = getConfigAttributes(framework_target)&.dig("PRODUCT_NAME")&.delete! ';'
        
        if framework_name.to_s.empty?
            framework_name = framework_target.common_resolved_build_setting("PRODUCT_NAME")
        end
        
        if framework_name == '$(TARGET_NAME)'
            framework_name = framework_target.name
        elsif framework_name == '$(TARGET_NAME:c99extidentifier)'
            # TODO: Add full support for 'c99extidentifier' if needed
            framework_name = framework_target.name
        elsif framework_name == '$(PROJECT_NAME)'
            framework_name = File.basename(framework_project_path, ".*")
        end
        
        framework_name
    }
    
    return all_framework_names
end

# Returns Project with shared iOS schemes
def getCarthageProjectPath(framework_name)
    framework_project_paths = Dir['Carthage/Checkouts/' + framework_name + '/**/*.xcodeproj']
    
    if framework_project_paths.empty?
        abort("\nCan't find framework project\n".red)
    end
    
    framework_project_paths.each { |framework_project_path|
        # Get proper targets
        framework_shared_schemes = Xcodeproj::Project.schemes(framework_project_path)
        framework_project = Xcodeproj::Project.open(framework_project_path)
        framework_targets = framework_project.native_targets.select { |framework_target| framework_target.iOSSharedFramework?(framework_shared_schemes) }
        
        if framework_targets.any?
            return framework_project_path
        end
    }
    
    return nil
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
