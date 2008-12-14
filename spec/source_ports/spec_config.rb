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
    if File.exists? @config_file
      File.chmod 0700, @config_file
      File.delete(@config_file)
    end
  end
  
  should 'not be saveable if the file is not writable' do
    File.chmod 0000, @config_file
    @config.should.not.be.saveable?
  end
  
  should 'raise a NonWritableConfigException if save is called when not saveable' do
    File.chmod 0000, @config_file
    @config.should.not.be.saveable?
    should.raise(SourcePorts::Config::NonWritableConfigException) do
      @config.save
    end
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