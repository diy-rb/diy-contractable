require_relative 'lib/diy/contractable/version'

Gem::Specification.new do |specification|
  specification.name = 'diy-contractable'
  specification.version = DIY::Contractable::VERSION
  specification.summary = 'Yet another contract implementation'
  specification.authors = ['Evgeny Boyko', 'Timur Radzhabov']
  specification.email = %w[mailbox@redo.moscow]
  specification.license = 'MIT'

  specification.add_dependency 'diy-carrierable', '~> 1.0.0'
end
