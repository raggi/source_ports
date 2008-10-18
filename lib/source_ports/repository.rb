class SourcePorts::Repository
  # The base require path to your application or library.
  RequirePath = File.join(SourcePorts::RequirePath, File.basename(__FILE__, File.extname(__FILE__)))
  
  # Add file base-names to this array, and they will be auto-loaded based on 
  # the snake to camel case conversion of the name.
  Autoloads = %w[git_hub]

  Autoloads.each do |lib|
    const_name = lib.split(/_/).map{ |s| s.capitalize }.join
    autoload const_name, File.join(RequirePath, lib)
  end
  
  attr_accessor :template

  def initialize(template)
    self.template = template
  end

  def port(name, *args)
    Port.new(name, self.template % [name, *args])
  end

  def has?(name, *args)
    true # default to trial by fire
  end
end