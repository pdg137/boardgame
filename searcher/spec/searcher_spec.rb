require_relative 'spec_helper'
require 'searcher'

shared_context "simple_tree" do
  before do
    # Set up this tree of moves.  The number
    # in parentheses represents the value that
    # the evaluator should return.
    # Note that this is complicated enough for
    # alpha-beta to prune one evalution.

    #                 4(1)
    #             /       \             \
    #          0(1)         5(5)        8(1)
    #    1(5) 2(0) 3(11)  6(-1) 7(5)    9(-2)

    # These 9 GameState objects represent possible states of the game.
    @state = []
    9.times do |i|
      @state << double("state#{i}".to_sym)
    end

    # A Move creates a new GameState.
    @move01 = double("move01", :to_s => 'move01', :result => @state[1])
    @move02 = double("move02", :to_s => 'move02', :result => @state[2])
    @move03 = double("move03", :to_s => 'move03', :result => @state[3])
    @move40 = double("move40", :to_s => 'move40', :result => @state[0])
    @move45 = double("move45", :to_s => 'move45', :result => @state[5])
    @move48 = double("move48", :to_s => 'move48', :result => @state[8])
    @move56 = double("move56", :to_s => 'move56', :result => @state[6])
    @move57 = double("move57", :to_s => 'move57', :result => @state[7])
    @move89 = double("move89", :to_s => 'move89', :result => @state[9])

    # A MoveFinder finds a series of possible moves from a state.
    @move_finder = double(:move_finder)
    @move_finder.stub(:find) do |state|
      case state
      when @state[0]
        [@move01, @move02, @move03]
      when @state[4]
        [@move40,@move45,@move48]
      when @state[5]
        [@move56,@move57]
      when @state[8]
        [@move89]
      else
        []
      end
    end

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
      when @state[4]
        1
      when @state[5]
        5
      when @state[6]
        -1
      when @state[7]
        @received_7 = true
        5
      when @state[8]
        1
      when @state[9]
        -2
      else
        raise "invalid state #{state.inspect}"
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
    @received_7 = false
    @searcher.search(@state[4], :depth => 2).should == @move40
    @received_7.should == false
  end

  it "should find a good move from state 5 at depth 1" do
    @received_7 = false
    @searcher.search(@state[5], :depth => 1).should == @move57
    @received_7.should == true
  end

  it "should find the only move from state 8 at depth 1" do
    @searcher.search(@state[8], :depth => 1).should == @move89
  end
end
