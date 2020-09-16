#
# Be sure to run `pod lib lint ECPhotoBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ECPhotoBrowser'
  s.version          = '0.1.0'
  s.summary          = '一个简单易用的图片浏览器、支持缩放、点击、长按事件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '一个轻量级、简单易用的图片浏览器、支持图片的缩放、点击、长按事件'

  s.homepage         = 'https://github.com/RunningMan528/ECPhotoBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RunningMan528' => 'peixu@weli.cn' }
  s.source           = { :git => 'https://github.com/RunningMan528/ECPhotoBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ECPhotoBrowser/Classes/**/*'
  
  s.resource_bundles = {
      'ECPhotoBrowser' => ['ECPhotoBrowser/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
