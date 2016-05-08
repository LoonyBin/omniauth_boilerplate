$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'omniauth/boilerplate/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'omniauth-boilerplate'
  s.version     = Omniauth::Boilerplate::VERSION
  s.authors     = ['Subhash Chandra']
  s.email       = ['TMaYaD@LoonyB.in']
  s.homepage    = 'http://github.com/LoonyBin/omniauth-boilerplate'
  s.description = 'An engine for omniauth boilerplate code'
  s.summary     = s.description
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2.6'

  s.add_development_dependency 'pg'
end
