Pod::Spec.new do |s|
  name    = "glm"
  version = "0.0.1"
  libglm  = "glm"
  
  s.name                    = "#{name}"
  s.version                 = "#{version}"
  s.summary                 = "current project custom framework dependencies."
  s.description             = "custom dependencies"
  s.homepage                = "https://github.com/limitLiu"
  s.license                 = { :type => "MIT", :file => "LICENSE" }
  s.author                  = { "Limit" => "limitliu@qq.com" }
  s.requires_arc            = false
  s.source                  = { :git => "", :tag => "" }
  s.ios.deployment_target   = '15.0'
  s.ios.header_mappings_dir = "include"
  s.ios.preserve_paths      = "include"
  
  s.subspec libglm do |sub|
    sub.ios.source_files        = "include/**/*{.h,.hpp}"
    sub.ios.public_header_files = "include/**/*{.h,.hpp,.inl}"
  end
  
  s.frameworks              = ["OpenGLES", "GLKit"]

end
