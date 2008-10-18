require File.dirname(__FILE__) + '/../helper'

require 'tempfile'

describe 'SourcePorts::Config hash loading' do
  
  before do
    @config_file = Tempfile.new('source_ports_config_spec')
    @config = SourcePorts::Config.new(@config_file.path)
  end
  
  should 'be empty on creation' do
    @config.should.be.empty?
  end
  
  should 'load the config file using yaml' do
    @config_file.write YAML.dump(:test => true)
    @config_file.close
    @config.load
    @config[:test].should.eql(true)
  end
end

describe 'SourcePorts::Config hash saving' do
  before do
    @config_file = Tempfile.new('source_ports_config_spec')
    @config_file.close
    @config_file = @config_file.path
    @config = SourcePorts::Config.new(@config_file)
  end
  
  after do
    File.delete(@config_file) if File.exists? @config_file
  end
  
  should 'write the data in YAML serialized form' do
    @config[:test] = true
    @config.save
    File.read(@config_file).should.eql YAML.dump(@config)
  end
  
  should 'be able to reload its own output' do
    @config[:test] = true
    @config['some strange key'] = 0
    @config.save
    @config = SourcePorts::Config.new(@config_file)
    @config.load
    @config[:test].should.be.true
    @config['some strange key'].should.eql 0
  end
end

describe "SourcePorts::Config path=" do
  should 'set the config path' do
    tempfile = Tempfile.new('source_ports_spec')
    tempfile.close
    config = SourcePorts::Config.new('')
    config.path = tempfile.path
    config[:test] = true
    config.save
    File.read(tempfile.path).should.eql(YAML.dump(config))
    File.delete tempfile.path
  end
end