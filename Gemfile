source 'https://rubygems.org'


gem 'rails', '4.2.4'
gem 'sprockets'
gem 'pg'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.5'
gem 'turbolinks', '~> 2.5.3'
gem 'jbuilder', '~> 2.3.1'
gem 'compass-rails', '~> 2.0.5'
gem 'font-awesome-rails', '~> 4.4.0.0'
# gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
#                               :github => 'anjlab/bootstrap-rails'
gem 'select2-rails'
gem 'modernizr-rails'
gem 'placeholder-gem'

gem 'angularjs-rails', '~> 1.2.3'
gem 'underscore-rails', '~> 1.8.3'
gem 'rails-observers'
gem 'tinymce-rails'
gem 'letter_opener'
gem 'email_validator'
gem 'whenever', '~> 0.9.0'
gem 'backup'
gem 'bundle'
gem 'dotenv-rails'
gem 'devise', '~> 3.5.0'
gem 'test-unit', '~> 3.1' # annoyingly, rails console won't start without it in staging / production


group :production, :staging do
  gem 'exception_notification', :git => 'https://github.com/smartinez87/exception_notification.git'
  gem 'slack-notifier', '~> 1.0'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.14.2'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'terminal-notifier-guard'
  gem 'pry-remote'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'simplecov', '>=0.9', require: false
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

gem 'comfortable_mexican_sofa', '1.12.8'
gem 'kaminari'

gem "geoip", "~> 1.6.1"
gem "yajl-ruby", "~> 1.2.1"

