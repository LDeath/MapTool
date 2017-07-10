#
#  Be sure to run `pod spec lint MAFMapTool.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MAFMapTool"
  s.version      = "0.0.2"
  s.summary      = "测试"
  
  s.homepage     = "https://github.com/LDeath/MapTool"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "高赛" => "395765302@qq.com" }
  s.source       = { :git => "https://github.com/LDeath/MapTool.git", :commit => 'da24338' }

  s.ios.deployment_target = '7.0'

  s.source_files  = 'MAFMapTool/**/*.{h,m}'
  s.dependency 'AMap3DMap'
  s.dependency 'AMapSearch'
  s.dependency 'AMapLocation'

end
