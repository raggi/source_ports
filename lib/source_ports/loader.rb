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
    @loaded << name
    $LOAD_PATH.unshift load_path(name)
  end

  def unsetup(name)
    @loaded.delete(name)
    $LOAD_PATH.delete load_path(name)
  end

  def load_path(name)
    File.join(SourcePorts.dir, name, 'lib')
  end

end