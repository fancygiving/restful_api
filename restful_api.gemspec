Gem::Specification.new do |s|
  s.name          = 'restful_api'
  s.version       = '0.2.14'
  s.date          = '2014-01-22'
  s.summary       = "Create a RESTful API for a resource in one line."
  s.description   = "Create a RESTful API for a resource in one line."
  s.authors       = ["Samuel Scully"]
  s.email         = 'dev@fancygiving.com'
  s.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/fancygiving/restful_api'
  s.add_dependency('multi_json')
  s.add_dependency('activesupport')
end