require 'rdoc/task'
require "./lib/facetious/version"
require "bundler/gem_tasks"

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "facetious #{Facetious::VERSION::STRING}"
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
task :spec => :test

require 'rake/testtask'
desc 'Test the facetious gem'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

#desc 'Generate website files'
#task :website_generate do
#  sh %q{ruby script/txt2html website/index.txt > website/index.html}
#end

#desc 'Upload website files via rsync'
#task :website_upload do
#  rfconfig = YAML.load_file("#{ENV['HOME']}/.rubyforge/user-config.yml")
#  ENV['RSYNC_PASSWORD'] = rfconfig['password']
#  sh %{rsync -aCv website #{rfconfig['username']}@rubyforge.org:/var/www/gforge-projects/polyglot}
#end
