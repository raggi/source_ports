#!/usr/bin/env ruby
# ruby -ropen-uri -e 'open("http://github.com/raggi/source_ports/tree/stable/install.rb?raw=true") { |f| eval(f.read) }'

# __MARK__
module SourcePorts
  class SelfInstaller
    def initialize(dir, branch = "stable")
      @dir = dir
      # TODO add to the config
      @branch = branch
      Dir.mkdir(dir) unless File.directory? dir
      @fetch_cmd = "git clone git://github.com/raggi/source_ports.git"
      @update_cmd = "git fetch && git checkout origin/#{branch}"
    end

    def install
      in_dir do
        system @fetch_cmd
        Dir.chdir "source_ports" do
          system @update_cmd
          system "rake"
        end
      end
    end
    
    def write_loader
      require 'rbconfig'
      filename = File.join(Config::CONFIG['sitelibdir'], 'source_ports.rb')
      source_ports_path = File.join(@dir, 'source_ports', 'lib', 'source_ports')
      open(filename, 'w') do |f|
        f << <<-EORUBY
require '#{source_ports_path}'
SourcePorts.dir = #{@dir}
SourcePorts.repositories << SourcePorts::Repository::GitHub.new
        EORUBY
      end
    end

    def in_dir
      Dir.chdir @dir do
        yield
      end
      self
    end
  end
end

SourcePorts::SelfInstaller.new(ARGV.shift || '/tmp/source_ports_install', ARGV.shift || 'stable').install.write_loader