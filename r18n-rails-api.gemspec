# frozen_string_literal: true

require_relative 'lib/r18n-rails-api/version'

Gem::Specification.new do |s|
  s.name     = 'r18n-rails-api'
  s.version  = R18n::Rails::API::VERSION

  s.summary     = 'Rails I18n compatibility for R18n'
  s.description = <<-DESC
    R18n backend for Rails I18n and R18n filters and loader to support Rails
    translation format.
    R18n has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra and desktop applications.
  DESC

  s.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE', 'ChangeLog.md']
  s.extra_rdoc_files = ['README.md', 'LICENSE']

  s.authors  = ['Andrey Sitnik', 'Alexander Popov']
  s.email    = ['andrey@sitnik.ru', 'alex.wayfer@gmail.com']
  s.license  = 'LGPL-3.0'

  github_uri = "https://github.com/r18n/#{s.name}"

  s.homepage = github_uri

  s.metadata = {
    'bug_tracker_uri' => "#{github_uri}/issues",
    'changelog_uri' => "#{github_uri}/blob/#{s.version}/ChangeLog.md",
    'documentation_uri' => "http://www.rubydoc.info/gems/#{s.name}/#{s.version}",
    'homepage_uri' => s.homepage,
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => github_uri
  }

  s.required_ruby_version = '>= 2.6', '< 4'

  s.add_dependency 'i18n', '~> 1.0'
  s.add_dependency 'r18n-core', '~> 5.0'

  s.add_development_dependency 'pry-byebug', '~> 3.9'

  s.add_development_dependency 'gem_toys', '~> 0.12.1'
  s.add_development_dependency 'toys', '~> 0.13.0'

  s.add_development_dependency 'rubocop', '~> 1.32.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.9'
  s.add_development_dependency 'rubocop-rails', '~> 2.15.0'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'

  s.add_development_dependency 'codecov', '~> 0.6.0'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'simplecov', '~> 0.21.0'
end
