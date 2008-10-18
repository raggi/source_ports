module SourcePorts
  class TreeCreateError < StandardError
    def initialize(dir)
      super("Could not create #{dir} for use as the SourcePorts tree")
    end
  end

  class PortCloneError < StandardError
    attr_accessor :exception
    def initialize(exception)
      @exception = exception
      super(exception.message)
    end
  end
  
  # The base require path to your application or library.
  RequirePath = File.basename(__FILE__, File.extname(__FILE__))
  
  # We're gunna cheat, for this app, as it's better here than in an external.
  $LOAD_PATH.unshift File.dirname(__FILE__) unless $LOAD_PATH.include?(File.dirname(__FILE__))
  
  # Add file base-names to this array, and they will be auto-loaded based on 
  # the snake to camel case conversion of the name.
  Autoloads = %w[config discoverer installer loader port repository require tree_manager]

  Autoloads.each do |lib|
    const_name = lib.split(/_/).map{ |s| s.capitalize }.join
    autoload const_name, File.join(RequirePath, lib)
  end

  Accessors = [
    :version, :setup_require, :dir,
    :tree_manager, :loader, :installer,
    :repositories
  ]
  # TODO probably these will just be writers, or at least some of them.
  class <<self; attr_accessor *Accessors; end

  self.version = '0.0.1'
  self.setup_require = true
  self.repositories = []
  def self.tree_manager
    @tree_manager ||= TreeManager.new
  end
  def self.installer
    @installer ||= Installer.new
  end
  def self.loader
    @loader ||= Loader.new
  end
end

extend SourcePorts::Require if SourcePorts.setup_require