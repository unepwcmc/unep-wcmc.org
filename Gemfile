source 'https://rubygems.org'


gem 'rails', '4.0.13'
gem 'sprockets', '2.11.3' # to reconcile CVE-2014-7819 and a breaking change in sprockets 2.12
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'compass-rails', '~> 1.1.3'
gem 'font-awesome-rails'
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
                              :github => 'anjlab/bootstrap-rails'
gem 'select2-rails'
gem 'modernizr-rails'
gem 'placeholder-gem'

gem 'angularjs-rails'
gem 'underscore-rails'
gem 'rails-observers'
gem 'tinymce-rails'
gem 'letter_opener'
gem 'email_validator'
gem 'whenever', '~> 0.9.0'
gem 'backup'
gem 'bundle'
gem 'rails-secrets' # should be obsolete after rails upgrade
gem 'dotenv-rails'
gem 'devise'
gem 'test-unit', '~> 3.1' # annoyingly, rails console won't start without it in staging / production


group :production, :staging do
  gem 'exception_notification', :git => 'https://github.com/smartinez87/exception_notification.git'
  gem 'slack-notifier', '~> 1.0'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'terminal-notifier-guard'
  gem 'pry-remote'
end

group :development do
  gem 'capistrano', '~> 3.0', require: false
  gem 'capistrano-rvm',   '~> 0.1', require: false
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-passenger', '~> 0.1.1', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'git_pretty_accept'
#  gem 'capistrano-slack', :git => 'https://github.com/nextupdate/capistrano-slack.git'
  gem 'capistrano-maintenance', '~> 1.0', require: false
end

group :doc do
  gem 'sdoc', require: false
end

gem 'comfortable_mexican_sofa', '~> 1.11.0'

gem "geoip", "~> 1.6.1"
gem "yajl-ruby", "1.2.0"

