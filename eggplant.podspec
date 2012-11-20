Pod::Spec.new do |s|
  s.name         = "eggplant"
  s.version      = "0.0.1"
  s.summary      = "Ingredients book, get all information from the ingredient term you gave."
  s.homepage     = "https://github.com/edwardinubuntu/eggplant"
  s.license      = 'MIT'
  s.author       = { "Edward Chiang" => "edward@thepolydice.com" }
  s.source       = { :git => "https://github.com/edwardinubuntu/eggplant.git", :tag => "Yahoo!OpenHack-FinalDemo" }
  s.source_files = 'eggplant', 'eggplant/**/*.{h,m}'
  s.frameworks = 'AVFoundation', 'CoreLocation'
  s.requires_arc = true
end
