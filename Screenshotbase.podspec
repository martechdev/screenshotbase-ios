Pod::Spec.new do |s|
  s.name             = 'Screenshotbase'
  s.version          = '0.1.0'
  s.summary          = 'Swift client for screenshotbase.com API.'
  s.description      = <<-DESC
Lightweight Swift client for the Screenshotbase API to render website screenshots or PDFs.
Supports async/await and completion handlers. See docs at https://screenshotbase.com/docs/
  DESC
  s.homepage         = 'https://screenshotbase.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EverAPI' => 'support@screenshotbase.com' }
  s.source           = { :git => 'https://github.com/everapihq/screenshotbase-ios.git', :tag => s.version.to_s }

  s.swift_version    = '5.9'
  s.ios.deployment_target = '12.0'
  s.macos.deployment_target = '10.15'

  s.source_files     = 'Sources/**/*.{swift}'
  s.frameworks       = 'Foundation'
end


