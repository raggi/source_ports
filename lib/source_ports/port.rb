class SourcePorts::Port
  # TODO add support for tests
  # TODO add support for CI build reports

  def initialize(name, uri)
    @name = name
    @uri = uri
  end

  def setup(raise_error = true)
    in_dir do
      command = "git clone #{@uri} #{@name}"
      puts command
      system command
    end
  rescue => e
    raise SourcePorts::PortCloneError, e if raise_error
  end

  def update
    in_port_dir do
      system "git pull"
    end
    build
  end

  def install
    setup(false)
    update
    build
  end

  def require
    SourcePorts.loader.require @name
  end

  def versions
    in_port_dir do
      return `git tag`.scan("\n")
    end
  end

  def build(args = [])
    return unless can_build?
    in_port_dir do
      config = Config.new('.source_ports_build')
      system "#{config[:build]} #{args.join(' ')}" if config[:build]
    end
  end

  def can_build?
    in_port_dir do
      return false unless File.exists?('.source_ports_build')
    end
  end

  def dir
    File.join(SourcePorts.dir, @name)
  end

  private
  def in_dir
    Dir.chdir SourcePorts.dir do
      yield
    end
    self
  end

  def in_port_dir
    Dir.chdir dir do
      yield
    end
    self
  end

end