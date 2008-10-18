class SourcePorts::Discoverer
  def dir(name)
    path(name)
  end

  def file(name)
    path(name)
  end

  def path(path)
    Dir[File.join(SourcePorts.dir, '*', path)]
  end

  def sub_path(path)
    Dir[File.join(SourcePorts.dir, '**', path)]
  end
end