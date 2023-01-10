require_relative '../../spec_helper'
require_relative '../../../libraries/helpers'

RSpec.describe OslUnmanaged::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include OslUnmanaged::Cookbook::Helpers
  end

  subject { DummyClass.new }
end
