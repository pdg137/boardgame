require_relative 'spec_helper'
require  'yinsh'

describe 'YinshState#[]' do
  before { @state = YinshState.new }

  it "should accept a number from 1-4" do
    expect{@state[1,2] = 1}.to_not raise_error
  end
end
