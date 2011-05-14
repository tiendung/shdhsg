require 'spec_helper'

describe Card do
  it { should be_referenced_in :user }
end
