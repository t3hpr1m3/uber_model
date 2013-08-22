require 'spec_helper'

describe UberModel::Attribute do
  def mock_attribute(*args)
    UberModel::Attribute.new(*args)
  end

  RSpec::Matchers.define :type_cast do |input|
    match do |attr|
      begin
        @type_cast = attr.type_cast(input)
        @expected.nil? ? true : @type_cast.eql?(@expected)
      rescue
        false
      end
    end

    chain :to do |expected|
      @expected = expected

      failure_message_for_should do |actual|
        "type_cast(#{input.inspect}) should be #{@expected.inspect}, but got #{@type_cast.inspect}"
      end
    end

    failure_message_for_should do |attr|
      "type_cast(#{input.inspect}) failed"
    end

    description do |attr|
      if @expected.nil?
        "type_cast(#{input.inspect})"
      else
        "type_cast(#{input.inspect}) to #{@expected.inspect}"
      end
    end
  end

  before {
    @date_obj = Date.new(2001,1,1)
    @datetime_obj = DateTime.new(2001,1,1)
  }
  subject { mock_attribute(:foo, :string, default: 'bar') }
  it { should respond_to(:name) }
  it { should respond_to(:type) }
  it { should respond_to(:default) }
  its(:name) { should eql('foo') }
  its(:type) { should eql(:string) }
  its(:default) { should eql('bar') }

  context 'with a :string type' do
    subject { mock_attribute(:test, :string) }
    it { should type_cast('').to('') }
    it { should type_cast('foo').to('foo') }
    it { should type_cast(123).to('123') }
    it { should type_cast(1.23).to('1.23') }
    it { should type_cast(true).to('true') }
    it { should type_cast(false).to('false') }
    it { should type_cast(@date_obj).to(@date_obj.to_s) }
    it { should type_cast(@datetime_obj).to(@datetime_obj.to_s) }
    its(:number?) { should be_false }
  end

  context 'with an :integer type' do
    subject { mock_attribute(:test, :integer) }
    it { should type_cast('').to(0) }
    it { should type_cast('foo').to(0) }
    it { should type_cast('123').to(123) }
    it { should type_cast('1.23').to(1) }
    it { should type_cast(@date_obj).to(nil) }
    it { should type_cast(@datetime_obj).to(nil) }
    it { should type_cast(true).to(1) }
    it { should type_cast(false).to(0) }
    it { should type_cast(nil).to(nil) }
    its(:number?) { should be_true }
  end

  context 'with a :float type' do
    subject { mock_attribute(:test, :float) }
    it { should type_cast('').to(0.0) }
    it { should type_cast('foo').to(0.0) }
    it { should type_cast(123).to(123.0) }
    it { should type_cast(1.23).to(1.23) }
    it { should type_cast(@date_obj).to(nil) }
    it { should type_cast(@datetime_obj).to(@datetime_obj.to_f) }
    it { should type_cast(true).to(nil) }
    it { should type_cast(false).to(nil) }
    it { should type_cast(nil).to(nil) }
    its(:number?) { should be_true }
  end

  context 'with a :date type' do
    subject { mock_attribute(:test, :date) }
    it { should type_cast('').to(nil) }
    it { should type_cast('foo').to(nil) }
    it { should type_cast(123).to(123) }
    it { should type_cast(1.23).to(1.23) }
    it { should type_cast(@date_obj).to(@date_obj) }
    it { should type_cast(@datetime_obj).to(@datetime_obj) }
    it { should type_cast('2001-01-01').to(Date.new(2001,1,1)) }
    it { should type_cast(true).to(true) }
    it { should type_cast(false).to(false) }
    it { should type_cast(nil).to(nil) }
    its(:number?) { should be_false }
  end

  context 'with a :datetime type' do
    subject { mock_attribute(:test, :datetime) }
    it { should type_cast('').to(nil) }
    it { should type_cast('foo').to(nil) }
    it { should type_cast(123).to(123) }
    it { should type_cast(1.23).to(1.23) }
    it { should type_cast(@date_obj).to(@date_obj) }
    it { should type_cast(@datetime_obj).to(@datetime_obj) }
    it { should type_cast('2001-01-01 01:01:00').to(DateTime.new(2001,1,1,1,1)) }
    it { should type_cast(true).to(true) }
    it { should type_cast(false).to(false) }
    it { should type_cast(nil).to(nil) }
    its(:number?) { should be_false }
  end

  context 'with a :boolean type' do
    subject { mock_attribute(:test, :boolean) }
    it { should type_cast('').to(nil) }
    it { should type_cast('foo').to(false) }
    it { should type_cast(123).to(false) }
    it { should type_cast(1.23).to(false) }
    it { should type_cast(@date_obj).to(false) }
    it { should type_cast(@datetime_obj).to(false) }
    it { should type_cast(true).to(true) }
    it { should type_cast(false).to(false) }
    it { should type_cast(nil).to(nil) }
    its(:number?) { should be_false }
  end
end
