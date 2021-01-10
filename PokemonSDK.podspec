#
# Be sure to run `pod lib lint PokemonSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PokemonSDK'
  s.version          = '0.0.11'
  s.summary          = 'A Pod which is for utilizing Pokemon Open Source API'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A Pod which is for utilizing Pokemon Open Source API. This uses Moya as Networking Tools and RxSwift for stream of data flow in the app. It also uses CoreData as an ORM to store items in the database.
                       DESC

  s.homepage         = 'https://github.com/abbassabeti/PokemonPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'TrueLayer', :file => 'LICENSE' }
  s.author           = { 'Abbas Sabeti' => 'abbassabetinejad@gmail.com' }
  s.source           = { :git => 'https://github.com/abbassabeti/PokemonPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'

  s.source_files = 'PokemonSDK/Classes/**/*'
  #s.resources = 'PokemonSDK/Classes/**/*.xcdatamodeld',
  s.source_files  = 'PokemonSDK/Classes', 'PokemonSDK/Classes/Pokemon.xcdatamodeld', 'PokemonSDK/Classes/Pokemon.xcdatamodeld/*.xcdatamodel'
  s.resources = [ 'PokemonSDK/Classes/*.xcdatamodeld','PokemonSDK/Classes/Pokemon.xcdatamodeld/*.xcdatamodel']
  s.preserve_paths = 'PokemonSDK/Classes/Pokemon.xcdatamodeld'
  
  s.test_spec 'UnitTests' do |test_spec|
        test_spec.source_files = 'PokemonSDK/UnitTests/*'
        test_spec.dependency 'Nimble', '~> 8.0.9'
        test_spec.dependency 'Quick', '~> 2.2.1'
  end
  
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
