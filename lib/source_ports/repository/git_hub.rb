require 'open-uri'
require 'yaml'
class SourcePorts::Repository::GitHub < SourcePorts::Repository
  attr_accessor :search_uri
  def initialize
    super("git://github.com/%s/%s.git")
    self.search_uri = 'http://github.com/api/v1/yaml/search/'
  end

  def port(name, *args)
    user = args.first || name
    SourcePorts::Port.new(name, self.template % [user, name])
  end

  def search(name, full = false)
    results = open(self.search_uri + URI.escape(name)) do |f|
      YAML.load(f)
    end
    results = results['repositories']
    full ? results : results.select { |r| r['name'] == name }
  end
end