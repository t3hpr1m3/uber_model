#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.pattern = 'spec/**/*_spec.rb'
end

YARD::Rake::YardocTask.new do |t|
  t.options = ['--exclude', 'generators', '--list-undoc']
end
