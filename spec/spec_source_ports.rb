require File.dirname(__FILE__) + '/helper'

describe 'SourcePorts::Autoloads' do

  SourcePorts::Autoloads.each do |al|
    it "should load up #{al} when the constant is used" do
      const_name = al.split(/_/).map { |n| n.capitalize }.join
      should.not.raise { SourcePorts.const_get(const_name) }
    end
  end

end