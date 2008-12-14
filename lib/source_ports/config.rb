require 'yaml'

class SourcePorts::Config < Hash
  class NonWritableConfigException < Exception
    attr_accessor :config
    def initialize(config)
      @config = config
      super("Could not save configuration to #{config.path}, file is not writable")
    end
  end

  attr_accessor :path

  def initialize(path, *args)
    @path = path
    super(*args)
  end

  def load
    self.replace open(@path) { |f| YAML.load f }
  end

  def save
    raise NonWritableConfigException, self unless saveable?
    open(@path, 'w+') do |file|
      file.write YAML.dump(self)
    end
  end
  
  def saveable?
    File.writable? @path
  end
  
  def inspect
    YAML.dump(self).strip
  end

end