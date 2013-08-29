require 'spec_helper'

describe UberModel::Identity do
  class IdentityModel < UberModel::Base
    attribute :primary, :integer, primary_key: true
  end

  subject { IdentityModel.new(primary: 123) }
  its(:to_model) { should eql(subject) }

  context 'when persisted' do
    before { subject.stub(persisted?: true) }
    its(:to_param) { should eql('123') }
    its(:to_key) { should eql([123]) }
  end

  context 'when not persisted' do
    before { subject.stub(persisted?: false) }
    its(:to_param) { should be_nil }
    its(:to_key) { should be_nil }
  end
end
