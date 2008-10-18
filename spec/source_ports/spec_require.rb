require File.dirname(__FILE__) + '/../helper'

describe 'SourcePorts::Require extending an object' do
  
  before do
    @object = Object.new
    @object.extend SourcePorts::Require
    SourcePorts.loader ||= Object.new # avoid smashing on nil
  end
  
  should 'add source_port' do
    Amok.with(SourcePorts.loader) do |obj, mock|
      mock.need.setup('name') {}
      @object.source_port('name')
      mock.should.be.successful
    end
  end
  
  should 'add source_port_require' do
    Amok.with(SourcePorts.loader) do |obj, mock|
      mock.need.require('name') {}
      @object.source_port_require('name')
      mock.should.be.successful
    end
  end
  
end

describe 'SourcePorts::Require extended callback' do
  should 'alias require to require_pre_source_port' do
    object = Object.new
    Amok.with(object.class) do |klass, mock|
      mock.need.alias_method(:require_pre_source_port, :require)
      object.extend SourcePorts::Require
      mock.should.be.successful
    end
  end
  
  should 'redefine require to call source_port_require' do
    name = 'name'
    Amok.with(Class.new.new) do |object, mock|
      object.extend SourcePorts::Require
      mock.need.source_port_require name
      object.require name
      mock.should.be.successful
    end
  end
  
  should 'call the old require if source_port_require fails' do
    name = 'name'
    object = Class.new do
      attr_accessor :requires
      def initialize
        @requires = []
      end
      
      def require(name, *args)
        @requires << [name, *args]
      end
    end.new
    object.extend SourcePorts::Require
    
    Amok.with(object) do |object, mock|
      mock.need.source_port_require(name) { raise 'boom' } # TODO load error?      
      object.require(name)
      object.requires.should.include([name])
      mock.should.be.successful
    end
    
  end
end