Pod::Spec.new do |s|
    s.name         = 'OTPlayerCache'
    s.version      = '0.0.1'
    s.summary      = 'a video cache for avplayer'
    s.homepage     = 'https://github.com/irobbin1024/OTPlayerCache.git'
    s.license      = 'Apache'
    s.authors      = { 'irobbin1024' => 'irobbin1024@gmail.com' }
    s.platform     = :ios, '6.0'
    s.source       = { :git => 'https://github.com/irobbin1024/OTPlayerCache.git', :tag => s.version.to_s }
    s.source_files = 'OTPlayerCache/*.{h,m}'
    s.framework    = 'UIKit'
    s.requires_arc = true
end
