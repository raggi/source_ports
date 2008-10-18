class SourcePorts::Installer

  def find_port(name, *args)
    repo = SourcePorts.repositories.find do |repository|
      repository.has? name, *args
    end
    repo.port(name, *args)
  end

  def install(name, *args)
    find_port(name, *args).install
  end

end