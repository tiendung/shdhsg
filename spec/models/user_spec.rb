require 'spec_helper'

describe User do
  it { should reference_one :card }
end
