require 'spec_helper'

describe UberModel::Adapters::AdapterPool do
  class DummyAdapter < UberModel::Adapters::AbstractAdapter; end
  let(:spec) { UberModel::Adapters::AdapterSpecification.new(:dev, adapter: 'dummy') }
  let(:pool) { UberModel::Adapters::AdapterPool.new(spec) }
  before(:all) {
    UberModel::Base.add_spec(:test, {adapter: :dummy})
    UberModel::Base.register_adapter(:dummy, DummyAdapter)
    UberModel::Base.set_adapter(:test)
  }

  subject { UberModel::Adapters::AdapterPool.new(spec) }
  it { should respond_to(:spec) }
  it { should respond_to(:connected?) }
  it { should respond_to(:instance) }
  it { should respond_to(:release_instance) }
  it { should respond_to(:shutdown!) }

  its(:spec) { should eql(spec) }
  its(:connected?) { should be_false }

  describe 'obtaining an adapter instance' do
    before { subject.send(:clear_stale_cached_instances!) }

    it 'should return an adapter' do
      subject.instance.should be_kind_of(DummyAdapter)
    end

    it 'should store the instance for a given thread' do
      subject.stub(checkout: {})
      subject.instance
      subject.should_receive(:checkout).never
      subject.instance
    end

    it 'should be connected' do
      subject.instance
      subject.connected?.should be_true
    end

    it 'should reuse existing instances' do
      subject.instance
      subject.release_instance
      subject.should_receive(:checkout_existing_instance).and_return(DummyAdapter.new(spec))
      subject.instance
    end

    it 'should wait for an instance to become available' do
      threads = []
      main_inst = subject.instance
      thread_inst = nil
      (subject.max_size - 1).times do |idx|
        threads << Thread.new do
          subject.instance
        end
      end
      threads.each { |t| t.join }

      #
      # This thread should block
      #
      t = Thread.new do
        thread_inst = subject.instance
      end
      sleep 2
      subject.release_instance
      t.join
      thread_inst.should eql(main_inst)
    end

    it 'should raise ConnectionTimeoutError if no connections become available' do
      threads = []
      subject.max_size.times do |idx|
        threads << Thread.new do
          subject.instance
          # Keep these threads alive PAST the timeout
          sleep (subject.timeout * 2)
        end
      end

      #
      # Give the above threads a chance to get a connection
      #
      sleep 1

      lambda { subject.instance }.should raise_error(UberModel::Adapters::ConnectionTimeoutError)
      threads.each { |t| t.join }
    end

    it 'should reap instances for dead threads' do
      threads = []
      main_inst = subject.instance
      (subject.max_size - 1).times do |idx|
        threads << Thread.new do
          subject.instance
          sleep 2
        end
      end

      t = Thread.new do
        #
        # Will block here until the threads above die
        #
        subject.instance
      end

      threads.each { |t| t.join }
      t.join
    end
  end
end
