# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_bunny/version'

Gem::Specification.new do |spec|
  spec.name          = "json_bunny"
  spec.version       = JsonBunny::VERSION
  spec.authors       = ["Jan Filipowski"]
  spec.email         = ["jachuf@gmail.com"]
  spec.summary       = %q{Bunny wrapper supporting JSON as messages content type}
  spec.description   = %q{Use JSON as message content type}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency "bunny"
  spec.add_dependency "multi_json"
end
