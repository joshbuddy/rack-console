require 'rubygems'
require 'lib/rack-console'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "Rack Console"
    s.description = s.summary = "Rack::Console gives you insight into a running rack app"
    s.email = "joshbuddy@gmail.com"
    s.homepage = "http://github.com/joshbuddy/rack-console"
    s.authors = ["Joshua Hull"]
    s.files = FileList["[A-Z]*", "{lib,spec,rails,bin}/**/*"]
    s.executables = ['rack-console']
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'spec'
require 'spec/rake/spectask'

task :spec => 'spec:all'
namespace(:spec) do
  Spec::Rake::SpecTask.new(:all) do |t|
    t.spec_opts ||= []
    t.spec_opts << "-rubygems"
    t.spec_opts << "--options" << "spec/spec.opts"
    t.spec_files = FileList['spec/**/*_spec.rb']
  end

end

