#!/usr/bin/env rake

require 'foodcritic'

FoodCritic::Rake::LintTask.new do |t|
    t.options = { :fail_tags => ['any'] }
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts "* Kitchen gem not loaded, omitting tasks"
end

task :default => [ :foodcritic ]

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
