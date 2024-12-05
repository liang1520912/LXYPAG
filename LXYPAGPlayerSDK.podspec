#
#  Be sure to run `pod spec lint LXYPAGPlayerSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  
  spec.name         = "LXYPAGPlayerSDK"
  spec.version      = "1.2.5"
  spec.summary      = "pag player"

 
  #spec.description  = <<-DESC DESC

  spec.homepage     = "https://github.com/liang1520912"
  

  #spec.license      = "MIT (example)"

  spec.author             = { "liang" => "422892962@qq.com" }
  

  spec.source       = { :git => "https://github.com/liang1520912/LXYPAG.git", :tag => "#{spec.version}" }


 
  spec.source_files  = 'LXYPAGPlayerSDK/**/*.{h,m,swift}'#"Classes", "Classes/**/*.{h,m}"
  #spec.exclude_files = "Classes/Exclude"

  spec.dependency 'libpag'

end
