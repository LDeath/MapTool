#
#  Be sure to run `pod spec lint MAFMapTool.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MAFMapTool"
  s.version      = "0.1.1"
  s.summary      = "高德地图常用方法封装"
  
  s.homepage     = "https://github.com/LDeath/MapTool"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "高赛" => "395765302@qq.com" }
  s.source       = { :git => "https://github.com/LDeath/MapTool.git", :tag => s.version }

  s.ios.deployment_target = '7.0'

  s.source_files  = 'MAFMapTool', 'MAFMapTool/**/*.{h,m}'

  s.frameworks = 'MAMapKit','AMapLocationKit','AMapSearchKit'

  s.dependency 'AMap3DMap', '~> 5.0.0'
  s.dependency 'AMapSearch', '~> 5.0.0'
  s.dependency 'AMapLocation', '~> 2.3.1'

end
