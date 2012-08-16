require_relative 'spec_helper'
require  'yinsh'

describe 'YinshState#[]' do
  before { @state = YinshState.new }

  it "should accept a number from 0-4" do
    (0..4).each do |state| expect{@state[1,2] = state}.to_not raise_error end
  end

  [[1,2],[1,5],[2,1],[2,7],[3,1],[3,8],[4,1],[4,9],[5,1],[5,10],
   [6,2],[6,10],[7,2],[7,11],[8,3],[8,11],[9,4],[9,11],[10,5],[10,11],
   [11,7],[11,10]].each do |point|
    it "should not raise errors for #{point}, within the bounds" do
      expect{@state[*point] = 1}.to_not raise_error
    end
    it "should not raise errors for #{[point[1],point[0]]}, within the bounds" do
      expect{@state[point[1],point[0]] = 1}.to_not raise_error
    end
  end

  [[0,0],[1,1],[1,6],[2,0],[2,8],[3,0],[3,9],[4,0],[4,10],[5,0],[5,11],
  [6,1],[6,11],[7,1],[7,12],[8,2],[8,12],[9,3],[9,12],[10,4],[10,12],
  [11,6],[11,11],[12,7]].each do |point|
    it "should raise errors for #{point}, outside of the bounds" do
      expect{@state[*point] = 1}.to raise_error
    end
    it "should raise errors for #{[point[1],point[0]]}, outside of the bounds" do
      expect{@state[point[1],point[0]] = 1}.to raise_error
    end
  end
end
