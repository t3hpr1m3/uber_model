require 'spec_helper'

describe UberModel::Base do
  subject { UberModel::Base }
  it { should respond_to(:logger) }
  it { should respond_to(:logger=) }
end
