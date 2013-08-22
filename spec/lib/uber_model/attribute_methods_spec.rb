require 'spec_helper'

describe UberModel::AttributeMethods do
  class AttributeModel < UberModel::Base
    attribute :test, :string
  end

  subject { AttributeModel.new }

  specify { subject.send(:attribute_method?, 'test').should be_true }
  specify { subject.send(:attribute_method?, 'invalid').should be_false }
end
