require 'spec_helper'

describe UberModel::AttributeMethods::BeforeTypeCast do
  class BeforeTypeCastModel < UberModel::Base
    attribute :test, :integer
  end

  subject { BeforeTypeCastModel.new(test: '123') }

  its(:test_before_type_cast) { should eql('123') }
  its(:test) { should eql(123) }
end
