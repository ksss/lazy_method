# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_method/version'

Gem::Specification.new do |spec|
  spec.name          = "lazy_method"
  spec.version       = LazyMethod::VERSION
  spec.authors       = ["ksss"]
  spec.email         = ["co000ri@gmail.com"]

  spec.summary       = 'LazyMethod is the new way of get method class object'
  spec.description   = 'LazyMethod is the new way of get method class object'
  spec.homepage      = "https://github.com/ksss/lazy_method"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rgot"
end
