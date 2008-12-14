class SourcePorts::Loader

  def initialize
    @loaded = []
  end

  def require(name)
    setup(name)
    Kernel.require name
  ensure
    return unless $!
    unsetup(name)
  end

  def setup(name)
    if File.exist? loadrc_path(name)
      tags = File.read(loadrc_path(name)).split.map {|s| s.strip }
      tags.each do |tag|
        # TODO implement tag loaders
        loaders[tag].load(name)
      end
    else
      path = File.join(port_path(name), 'lib')
      $LOAD_PATH.unshift path if File.directory? path
      path = File.join(port_path(name), 'bin')
      $LOAD_PATH.unshift path if File.directory? path
    end
    @loaded << name
  end

  def unsetup(name)
    @loaded.delete(name)
    # FIXME
    # $LOAD_PATH.delete load_path(name)
  end

  def loadrc_path(name)
    File.join(port_path(name), '.source_port', 'loadrc')
  end

  def port_path(name)
    File.join(SourcePorts.dir, name)
  end

end