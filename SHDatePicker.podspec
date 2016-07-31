#
# Be sure to run `pod lib lint SHDatePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'SHDatePicker'
s.version          = '0.1.1'
s.summary          = 'A simple custom DatePicker.'
s.homepage         = 'https://github.com/harushuu/SHDatePicker'
s.screenshots      = 'https://github.com/harushuu/SHDatePicker/raw/master/Screenshots.gif'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '@harushuu' => 'hunter4n@gmail.com' }
s.source           = { :git => 'https://github.com/harushuu/SHDatePicker.git', :tag => s.version }
s.platform     = :ios, '8.0'
s.requires_arc = true
s.source_files = 'SHDatePicker/*'
s.frameworks = 'UIKit'
s.dependency 'Masonry', '~> 0.6.4'

end
