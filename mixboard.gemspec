# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'mixboard/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = 'mixboard'
  spec.version = Mixboard::VERSION
  spec.authors = ['Zach McCormick']
  spec.email = ['zach.mccormick@braze.com']
  spec.homepage = 'https://github.com/braze-inc/mixboard'
  spec.summary = 'Mixboard is a framework for routing signals from sources to sinks.'
  spec.description = <<~HEREDOC
    Mixboard is a framework for routing signals from sources to sinks. Signals can be metrics,
    log messages, errors, or any other similar piece of information one might want to route
    from a source to a sink. Conditional routing is available via filters, and transformation
    of signals is possible via signal processors.
  HEREDOC
  spec.license = 'MIT'
  spec.required_ruby_version = '> 2.6'

  spec.files = Dir['{app,config,db,lib}/**/*', 'LICENSE.md', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 5'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
