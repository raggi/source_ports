module SourcePorts::Require
  def self.extended(base)
    base.class.send :alias_method, :require_pre_source_port, :require
    def base.require(name, *args)
      source_port_require name
    rescue
      require_pre_source_port(name, *args)
    end
  end

  def source_port(name)
    SourcePorts.loader.setup name
  end

  def source_port_require(name)
    SourcePorts.loader.require name
  end
end