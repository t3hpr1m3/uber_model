require 'spec_helper'

describe UberModel::AttributeMethods::Read do
  class ReadModel < UberModel::Base
    attribute :test, :string
    attribute :primary, :integer, primary_key: true
  end

  subject { ReadModel.new }

  it 'should read the primary key when "id" is requested' do
    subject.primary = 123
    subject.read_attribute(:id).should eql(123)
  end
end
