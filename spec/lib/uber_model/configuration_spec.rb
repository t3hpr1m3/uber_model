require 'spec_helper'

describe UberModel::Base do
  subject { UberModel::Base }
  it { should respond_to(:configure) }
  it { should respond_to(:specs) }
  it { should respond_to(:add_spec) }

  describe 'configure' do
    it 'should yield UberModel::Base class' do
      expect { |b| UberModel::Base.configure(&b) }.to yield_with_args(UberModel::Base)
    end
  end

  describe 'add_spec' do
    it 'should add to the hash of specs' do
      UberModel::Base.add_spec(:foo, {adapter: 'test', bar: 'baz'})
      UberModel::Base.specs[:foo].should_not be_nil
    end

    it 'should store it as an AdapterSpecification' do
      UberModel::Base.add_spec(:foo, {adapter: 'dummy', bar: 'baz'})
      UberModel::Base.specs[:foo].should be_kind_of(UberModel::Adapters::AdapterSpecification)
    end
  end
end
