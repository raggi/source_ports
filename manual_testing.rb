#!/usr/bin/env ruby

require 'yaml'

require 'lib/source_ports'

dir = '/tmp/gitports'
SourcePorts.dir = dir
SourcePorts.tree_manager = SourcePorts::TreeManager.new
SourcePorts.loader = SourcePorts::Loader.new
port = SourcePorts::Port.new('sized_header_protocol', 'git://github.com/raggi/sized_header_protocol.git')
begin
  port.setup
rescue SourcePorts::PortCloneError
end
port.update

SourcePorts.loader.require 'sized_header_protocol'
p SizedHeaderProtocol

op_port = SourcePorts::Repository::GitHub.new.port('object_protocol', 'raggi').setup(false)
op_port.update
op_port.require

require 'object_protocol'

p ObjectProtocol
p op_port.versions

SourcePorts.repositories << SourcePorts::Repository::GitHub.new

SourcePorts.installer.install 'eventmachine'

require 'eventmachine'

EM.run { EM.stop }

SourcePorts.installer.install 'bacon', 'chneukirchen'
require 'bacon'
p Bacon

y SourcePorts::Repository::GitHub.new.search('eventmachine')