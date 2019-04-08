Pod::Spec.new do |s|
  s.name             = "PullToDismiss"
  s.version          = "2.2"
  s.summary          = "Dismiss ViewController by pulling scroll view or navigation bar in Swift."
  s.homepage         = "https://github.com/sgr-ksmt/PullToDismiss"
  # s.screenshots     = ""
  s.license          = 'MIT'
  s.author           = { "Suguru Kishimoto" => "melodydance.k.s@gmail.com" }
  s.source           = { :git => "https://github.com/sgr-ksmt/PullToDismiss.git", :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.source_files     = "Sources/**/*"
  s.swift_version    = '5.0'
end
