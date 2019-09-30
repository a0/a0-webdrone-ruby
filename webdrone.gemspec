# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webdrone/version'

Gem::Specification.new do |spec|
  spec.name          = 'webdrone'
  spec.version       = Webdrone::VERSION
  spec.authors       = ['Aldrin Martoq']
  spec.email         = ['a@a0.cl']

  spec.summary       = 'A simple selenium webdriver wrapper, ruby version.'
  spec.description   = 'See webpage for more info.'
  spec.homepage      = 'http://github.com/a0/a0-webdrone-ruby'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'ci_reporter_rspec'
  spec.add_development_dependency 'parallel_tests'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'solargraph'

  spec.add_runtime_dependency 'binding_of_caller'
  spec.add_runtime_dependency 'highline', '>= 2.0.0'
  spec.add_runtime_dependency 'os'
  spec.add_runtime_dependency 'pry'
  spec.add_runtime_dependency 'rubyXL'
  spec.add_runtime_dependency 'selenium-webdriver', '>= 3.5.0'
  spec.add_runtime_dependency 'xpath'
end
