#!/usr/bin/env rake
require 'rake'
require 'rake/clean'
require 'rake/rdoctask'

task :default => :build
task :default => :spec

task :release => [:'git:push', :'git:merge:stable']

task :build => :'gen:install'

task :install => :build do
  sh 'sudo ruby install.rb'
end

namespace :gen do
  
  # TODO use git ls-tree or whatever to do this using repo knowledge.
  self_installer_mtime = File.stat('lib/source_ports/self_installer.rb').mtime
  install_rb_mtime = File.stat('install.rb').mtime
  if self_installer_mtime > install_rb_mtime
    warn "Looks like it's time to rebuild install.rb `rake gen:install`"
  end
  
  desc 'regenerate install.rb from self_installer.rb'
  task :install do
    installer = File.read('lib/source_ports/self_installer.rb')
    open('install.rb', 'r+') do |file|
      line = file.readline until line =~ /# __MARK__/ rescue nil
      file << installer
      file.truncate(file.pos)
    end
  end
  
end

task :spec do
  sh 'spec/runner' # XXX win32
end

namespace :spec do
  
end

namespace :git do
  task :pull do
    sh 'git pull'
  end
  
  task :push do
    sh 'git push'
  end
  
  namespace :merge do
    task :stable do
      sh 'git push origin HEAD:refs/heads/stable'
    end
  end
end

Rake::RDocTask.new do |rd|
  rd.title = 'source_ports'
  rd.rdoc_dir = 'rdoc'
  rd.main = "README.rdoc"
  rd.rdoc_files.include(rd.main, "lib/**/*.rb", 'install.rb')
end
task :clobber => :clobber_rdoc

desc 'Generate and open documentation'
task :docs => :rdoc do
  case RUBY_PLATFORM
  when /darwin/       ; sh 'open rdoc/index.html'
  when /mswin|mingw/  ; sh 'start rdoc\index.html'
  else 
    sh 'firefox rdoc/index.html'
  end
end