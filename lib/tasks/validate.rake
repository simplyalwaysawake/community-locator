# frozen_string_literal: true

require 'rubocop/rake_task'

desc 'Run rubocop and tests (except system)'
task validate: :environment do
  Rake::Task['rubocop'].invoke
  Rake::Task['test'].invoke
end

desc 'Run rubocop and all tests'
task validate_all: :environment do
  Rake::Task['rubocop'].invoke
  Rake::Task['test:all'].invoke
end

desc 'Run rubocop'
task rubocop: :environment do
  RuboCop::RakeTask.new
end
