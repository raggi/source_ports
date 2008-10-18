#!/usr/bin/env rake

task :default => :build
task :default => :spec

task :build => :'gen:install'

namespace :gen do
  
  task :install do
    installer = File.read('lib/source_ports/self_installer.rb')
    open('install.rb', 'r+') do |file|
      line = file.readline until line =~ /# __MARK__/ rescue nil
      file << installer
    end
  end
  
end

task :spec do
  sh 'spec/runner' # XXX win32
end

namespace :spec do
  
end