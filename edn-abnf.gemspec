Gem::Specification.new do |s|
  s.name = "edn-abnf"
  s.version = "0.1.5"
  s.summary = "CBOR Extended Diagnostic Notation (EDN) implemented in ABNF"
  s.description = %q{edn-abnf implements converters and miscellaneous tools for CBOR EDN's ABNF}
  s.author = "Carsten Bormann"
  s.email = "cabo@tzi.org"
  s.license = "MIT"
  s.homepage = "http://github.com/cabo/edn-abnf"
  s.files = Dir['lib/**/*.rb'] + %w(edn-abnf.gemspec) + Dir['bin/**/*.rb']
  s.executables = Dir['bin/*'].map {|x| File.basename(x)}
  s.required_ruby_version = '>= 1.9.2'

  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler', '~>1'
  s.add_development_dependency 'abnftt', '~>0.2'
  s.add_dependency 'treetop', '~>1'
  s.add_dependency 'json', '~>2'
  s.add_dependency 'neatjson', '~>0.10'
end
