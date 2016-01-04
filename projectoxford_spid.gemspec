# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'projectoxford_spid/version'

Gem::Specification.new do |spec|
  spec.name          = "projectoxford_spid"
  spec.version       = ProjectoxfordSpid::VERSION
  spec.authors       = ["litenup"]
  spec.email         = ["alanhsu@mycallhero.com"]

  spec.summary       = %q{Wrapper for Microsoft Project Oxford Speaker Identification & Verification API}
  spec.homepage      = "https://github.com/litenup/projectoxford_spid"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency "rest-client", "~> 1.8"
  spec.add_dependency "json", "~> 1.8"
  spec.add_dependency "audio_hero", "~> 0.1"
end
