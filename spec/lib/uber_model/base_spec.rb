require 'spec_helper'

describe UberModel::Base do
  class LintTester < UberModel::Base; end

  subject { LintTester.new }

  it_should_behave_like 'ActiveModel'
end
