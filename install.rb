#!/usr/bin/env ruby
# ruby -ropen-uri -e 'open("http://github.com/raggi/source_ports/tree/stable/install.rb?raw=true") { |f| eval(f.read) }'

# __MARK__
module SourcePorts
  class SelfInstaller
    def initialize(dir, fetch_cmd = "git clone git://github.com/raggi/git_ports.git")
      @dir = dir
      Dir.mkdir(dir) unless File.directory? dir
      @fetch_cmd = fetch_cmd
    end

    def install
      in_dir do
        system @fetch_cmd
        Dir.chdir "git_ports" do
          system "rake"
        end
      end
    end
    
    def write_loader
      require 'rbconfig'
      filename = File.join(Config::CONFIG['sitelibdir'], 'source_ports.rb')
      source_ports_path = File.join(@dir, 'source_ports', 'lib', 'source_ports')
      open(filename, 'w') do |f|
        f << "require '#{source_ports_path}'"
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

# SourcePorts::SelfInstaller.new(ARGV.first || '/tmp/gitports_install').install.write_loaderr