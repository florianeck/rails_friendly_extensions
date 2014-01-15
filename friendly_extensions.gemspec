Gem::Specification.new do |s|
  s.name        = 'friendly_extensions'
  s.version     = '0.0.61'
  s.date        = '2014-01-14'
  s.summary     = "Collection of useful features for Ruby/Rails Classes"
  s.description = "Adds serveral cool features to your Ruby classes. Includes new features for Array, String, Hash, Numeric, Date/Datetime and some more."
  s.authors     = ["Florian Eck"]
  s.email       = 'it-support@friends-systems.de'

  s.files       = Dir.glob("lib/**/*")
  s.test_files  = Dir["test/**/*"]
  
  s.add_dependency "rails", "~> 3.2.9"
  
  s.homepage    = "https://github.com/florianeck/rails_friendly_extensions"
end