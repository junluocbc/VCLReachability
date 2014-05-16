#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "VCLReachability"
  s.version          = "1.0.0"
  s.summary          = "VCLReachability is a reachability library for iOS. It is designed to help you interface with network activity events by allowing all object to pub and subscribe with reachability events. Based on Apples Reachability project."
  #s.description      = <<-DESC
                       An optional longer description of VCLReachability

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/VerticodeLabs/VCLReachability"
  #s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "adrianmaurer" => "adrian@verticodelabs.com" }
  s.source           = { :git => "https://github.com/VerticodeLabs/VCLReachability.git", :tag => 1.0.0 }
  s.social_media_url = 'https://twitter.com/verticodelabs'

   s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes', 'Example', 'Tests'
  s.resources = 'Assets/*.png'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
