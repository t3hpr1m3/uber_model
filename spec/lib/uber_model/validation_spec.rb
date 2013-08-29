require 'spec_helper'

describe UberModel::Validation do
  class ValidationModel < UberModel::Base
  end

  let(:model) { ValidationModel.new }

  subject { model }

  it { should respond_to(:valid?) }
  it { should respond_to(:save) }

  describe 'save' do
    before do
      subject.stub(create: true)
    end

    it 'should validate on save' do
      subject.should_receive(:run_callbacks).with(:validation).and_yield
      subject.should_receive(:run_callbacks).with(:validate)
      subject.should_receive(:run_callbacks).with(:save).and_yield
      subject.save
    end
  end

  it 'should skip validation if validate is false' do
    subject.should_receive(:valid?).never
    subject.save(validate: false)
  end
end
