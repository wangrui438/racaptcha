require "bundler/gem_tasks"
require 'rake/extensiontask'

Rake::ExtensionTask.new "racaptcha" do |ext|
  ext.lib_dir = "lib/racaptcha"
end

task :default => :spec

task :preview do
  require 'racaptcha'

  res = RaCaptcha.create(1, 5, 1, 0)
  $stderr.puts res[0]
  puts res[1]
end
