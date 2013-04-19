Gem::Specification.new do |s|
  s.name          = 'restful_api'
  s.version       = '0.0.2'
  s.date          = '2013-04-17'
  s.summary       = "Hola!"
  s.description   = "Create a RESTful API for a resource in one line."
  s.authors       = ["Samuel Scully"]
  s.email         = 'sbscully@gmail.com'
  s.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/sbscully/restful_api'
  s.add_dependency('multi_json', '~> 1.7')
  s.add_dependency('active_support', '~> 3.0')
  s.add_dependency('virtus')
end