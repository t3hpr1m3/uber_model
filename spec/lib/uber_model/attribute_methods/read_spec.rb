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

  describe '_before_type_cast' do
    it 'should return the raw value' do
      subject.test = 1
      subject.test_before_type_cast.should eql(1)
      subject.test.should eql('1')
    end
  end
end
