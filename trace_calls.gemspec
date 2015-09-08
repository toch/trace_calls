# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trace_calls/version'

Gem::Specification.new do |spec|
  spec.name          = "trace_calls"
  spec.version       = TraceCalls::VERSION
  spec.authors       = ["Christophe Philemotte"]
  spec.email         = ["christophe.philemotte@8thcolor.com"]
  spec.summary       = %q{Trace the whole chain of method calls.}
  spec.description   = %q{Trace the whole chain of method calls.}
  spec.homepage      = "https://github.com/toch/trace_calls"
  spec.license       = "GPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "minitest"
end
