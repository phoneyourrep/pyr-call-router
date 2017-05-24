# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.4.1'

gem 'pyr', '~> 0.4.0', '>= 0.4.0'
gem 'rake', '~> 12.0.0'
gem 'require_all', '~> 1.4.0'
gem 'sinatra', '~> 2.0.0'
gem 'twilio-ruby', '~> 4.13'

group :development, :test do
  gem 'coveralls', '~> 0.8.0', require: false
  gem 'pry', '~> 0.10.4'
  gem 'rubocop', '~> 0.48.0', '>= 0.48.1'
  gem 'shotgun', '~> 0.9.0', '>= 0.9.2'
  gem 'simplecov', '~> 0.14.0', require: false
end

group :test do
  gem 'capybara', '~> 2.14.0'
  gem 'rack-test', '~> 0.6.0', '>= 0.6.3'
  gem 'rspec', '~> 3.6.0'
end

group :production do
  gem 'puma', '~> 3.0'
end
