require_relative 'spec_helper'
require 'searcher'

shared_context "simple_tree" do
  before do
    # A GameState is a state of the game.

    #        5
    #       / \
    #      1    6
    #    2 3 4  78
    @state = []
    20.times do |i|
      @state << double("state#{i}".to_sym)
    end

    # A Move creates a new GameState.
    @move01 = double("move01", :to_s => 'move01', :result => @state[1])
    @move02 = double("move02", :to_s => 'move02', :result => @state[2])
    @move03 = double("move03", :to_s => 'move03', :result => @state[3])

    # A MoveFinder finds a series of possible moves from a state.
    @move_finder = double(:move_finder, :find => [@move01, @move02, @move03])

    # An Evaluator evaluates GameStates
    @evaluator = double(:evaluator)
    @evaluator.stub :evaluate do |state|
      case state
      when @state[0]
        1
      when @state[1]
        5
      when @state[2]
        0
      when @state[3]
        11
      end
    end

    @searcher = Searcher.new(@move_finder, @evaluator)
  end
end

describe 'Searcher', 'initialize' do
  include_context "simple_tree"
  it "should find a good move at depth 1" do
    @searcher.should be_a_kind_of Searcher
    @searcher.search(@state[0], :depth => 1).should == @move03
  end

  it "should find a good move at depth 2" do
    @searcher.search(@state[5], :depth => 2).should == @move03
  end
end
