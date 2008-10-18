class SourcePorts::TreeManager

  def initialize
    @dir = SourcePorts.dir
    ensure_dir
  end

  def ensure_dir
    return if File.directory?(@dir)
    Dir.mkdir @dir
  rescue
    raise SourcePorts::TreeCreateError, @dir
  end

end