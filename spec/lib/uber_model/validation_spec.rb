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
      subject.stubs(create: true)
    end

    it 'should validate on save' do
      subject.expects(:run_callbacks).with(:validation).yields
      subject.expects(:run_callbacks).with(:validate)
      subject.save
    end
  end

  it 'should skip validation if validate is false' do
    subject.expects(:valid?).never
    subject.save(validate: false)
  end
end
