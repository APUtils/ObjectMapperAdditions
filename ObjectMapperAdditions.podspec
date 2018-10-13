#
# Be sure to run `pod lib lint ObjectMapperAdditions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ObjectMapperAdditions'
  s.version          = '4.2.1'
  s.summary          = 'ObjectMapper Extensions and Transforms'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
- Adds simple calls to include NULL values in output JSON.
- Adds ability to simply type cast JSON values to specified type.
                       DESC

  s.homepage         = 'https://github.com/APUtils/ObjectMapperAdditions'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/ObjectMapperAdditions.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'ObjectMapperAdditions/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ObjectMapperAdditions' => ['ObjectMapperAdditions/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'ObjectMapper'

  s.subspec 'Core' do |core|
    core.source_files = 'ObjectMapperAdditions/Classes/Core/**/*'
  end

  s.subspec 'Realm' do |realm|
    realm.source_files = 'ObjectMapperAdditions/Classes/Realm/**/*'
    realm.dependency 'ObjectMapperAdditions/Core'
    realm.dependency 'RealmSwift'
  end
end
