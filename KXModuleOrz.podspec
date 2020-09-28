
Pod::Spec.new do |s|
  s.name             = 'KXModuleOrz'
  s.version          = '0.0.1'
  s.summary          = 'A short description of KXModuleOrz.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/XiangqiTu/KXModuleOrz'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XiangqiTu' => '110293734@qq.com', 'XiangqiTu' => 'xiangqitu@gmail.com' }
  s.source           = { :git => 'git@github.com:XiangqiTu/KXModuleOrz.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'KXModuleOrz/Classes/**/*'
  
  s.frameworks   =  [
    "UIKit",
    "Foundation",
  ]
  s.libraries    = [
    "z",
    "c++",
  ]
end
