# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet-lint/plugins/version'

Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-i18n'
  spec.version     = CheckI18n::VERSION
  spec.homepage    = 'https://github.com/puppetlabs/puppet-lint-i18n'
  spec.license     = 'Apache 2.0'
  spec.authors     = ['Puppet, Inc.']
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'Will check the decoration of your puppet code'
  spec.description = 'Will check the decoration of your puppet code'

  spec.add_dependency 'puppet-lint', '> 2.0'
end
