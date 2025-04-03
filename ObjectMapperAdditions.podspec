#
# Be sure to run `pod lib lint ObjectMapperAdditions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ObjectMapperAdditions'
  s.version          = '14.0.1'
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

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '5.0'
  
  # 1.12.0: Ensure developers won't hit CocoaPods/CocoaPods#11402 with the resource
  # bundle for the privacy manifest.
  # 1.13.0: visionOS is recognized as a platform.
  s.cocoapods_version = '>= 1.13.0'
  
  s.default_subspec = 'Core'
  s.frameworks = 'Foundation'
  s.dependency 'ObjectMapper', '>= 4.4.2'
  s.dependency 'RoutableLogger', '>= 12.0'

  s.subspec 'Core' do |core|
    core.source_files = 'ObjectMapperAdditions/Classes/Core/**/*'
    core.resource_bundle = {"ObjectMapperAdditions.Core.privacy"=>"ObjectMapperAdditions/Privacy/ObjectMapperAdditions.Core/PrivacyInfo.xcprivacy"}
  end

  s.subspec 'Realm' do |realm|
    realm.source_files = 'ObjectMapperAdditions/Classes/Realm/**/*'
    realm.resource_bundle = {"ObjectMapperAdditions.Realm.privacy"=>"ObjectMapperAdditions/Privacy/ObjectMapperAdditions.Realm/PrivacyInfo.xcprivacy"}
    realm.dependency 'ObjectMapperAdditions/Core'
    realm.dependency 'RealmSwift', '< 20.0'
  end
end
