# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

require_relative './config/environment'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: %i[spec rubocop]
rescue LoadError
  # no rspec available
end

desc 'Open a pry console'
task :console do
  Pry.start
end
