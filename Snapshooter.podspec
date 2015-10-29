#
# Be sure to run `pod lib lint Snapshooter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Snapshooter"
  s.version          = "0.1.2"
  s.summary          = "Snapshooter makes it easy to share screenshots with developers and testers."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  Take a screenshot with the two-finger bottom edge swipe gesture. Also, tap to add markers anywhere on the screen.
                       DESC

  s.homepage         = "https://github.com/goodpatch/Snapshooter"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Seiya Shimokawa" => "shimokawa.1987@gmail.com" }
  s.source           = { :git => "https://github.com/goodpatch/Snapshooter.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.1'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = ['Pod/Assets/images.xcassets','Pod/Assets/*.{storyboard}']

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
