#!/usr/bin/env ruby

require 'yaml'

require 'lib/source_ports'

dir = '/tmp/gitports'
SourcePorts.dir = dir
SourcePorts.tree_manager = SourcePorts::TreeManager.new
SourcePorts.loader = SourcePorts::Loader.new
# port = SourcePorts::Port.new('sized_header_protocol', 'git://github.com/raggi/sized_header_protocol.git')
# begin
#   port.setup
# rescue SourcePorts::PortCloneError
# end
# port.update

# SourcePorts.loader.require 'sized_header_protocol'
# p SizedHeaderProtocol

# op_port = GitHubRepository.new.port('object_protocol', 'raggi').setup(false)
# op_port.update
# op_port.require

# require 'object_protocol'

# p ObjectProtocol
# p op_port.versions

# SourcePorts.repositories << GitHubRepository.new

# SourcePorts.installer.install 'eventmachine'

# require 'eventmachine'

# EM.run { EM.stop }

# eval(installer)

# ruby -ropen-uri -e 'open("http://github.com/raggi/source_ports/tree/stable/install.rb?raw=true") { |f| eval(f.read) }'

# SourcePorts.installer.install 'bacon', 'chneukirchen'
# require 'bacon'
# p Bacon

class MantissaRepository < SourcePorts::Repository
  def initialize
    super("git@git.mantissaoperations.com:%s.git")
  end

  def port(name, *args)
    SourcePorts::Port.new(name, self.template % name)
  end
end


# MantissaRepository.new.port('agwpe').install
# require 'agwpe'

y SourcePorts::Repository::GitHub.new.search('eventmachine')

require 'raggi/irb/drop'
dROP! binding