Pod::Spec.new do |s|
s.name         = "ZWTitleScroll"
s.version      = "0.0.1"
s.summary      = "Title scroll for ios."
s.homepage     = "https://github.com/RobertZh/ZWTitleScroll.git"
s.license      = "MIT"
s.author             = { "Robert" => "zhangwei8256@icloud.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/RobertZh/ZWTitleScroll.git", :tag => "0.0.1" }
s.source_files  = "ZWTitleScroll", "ZWTitleScroll/**/*.{h,m}"
s.framework  = "UIKit"
end
