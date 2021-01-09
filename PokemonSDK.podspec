#
# Be sure to run `pod lib lint PokemonSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PokemonSDK'
  s.version          = '0.0.7'
  s.summary          = 'A short description of PokemonSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/abbassabeti/PokemonPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'TrueLayer', :file => 'LICENSE' }
  s.author           = { 'Abbas Sabeti' => 'abbassabetinejad@gmail.com' }
  s.source           = { :git => 'https://github.com/abbassabeti/PokemonPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'PokemonSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PokemonSDK' => ['PokemonSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreData', 'Foundation'
  s.dependency 'Kingfisher'
  s.dependency 'Moya/RxSwift', '14.0.0-beta.2'
  s.dependency 'RxCocoa'
  s.dependency 'RxGesture'
end
