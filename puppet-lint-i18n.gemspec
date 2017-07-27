Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-i18n'
  spec.version     = '0.1.0'
  spec.homepage    = 'https://github.com/puppetlabs/puppet-lint-i18n'
  spec.license     = 'Apache 2.0'
  spec.author      = 'puppet'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'Will check the decoration of your puppet code'
  spec.description = <<-EOF
    Will check the decoration of your puppet code
  EOF

  spec.add_dependency             'puppet-lint', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
