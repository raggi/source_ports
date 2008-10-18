class SourcePorts::Config < Hash

  def initialize(config_path, *args)
    @config_path = config_path
    super(*args)
  end

  def path=(path)
    @config_path = path
  end

  def load
    self.replace open(@config_path) { |f| YAML.load f }
  end

  def save
    open(@config_path, 'w+') do |file|
      file.write YAML.dump(self)
    end
  end

end