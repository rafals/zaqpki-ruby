# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'

require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

desc 'GitHub push'
task :commit do
  system "git add -A"
  if ENV['m']
    system "git commit -a -m \"#{ENV['m']}\""
  else
    system "git commit -a -m \"`git status | ruby git_reader.rb`\""
  end
  system "git push"
end
