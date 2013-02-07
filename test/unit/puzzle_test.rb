require File.expand_path(File.dirname(__FILE__) + '/../test_helper')


#require './script/solve.rb'

class PuzzleTest < ActiveSupport::TestCase

  INITIAL_STATE = "L1L2L3L4L5L6L7L8L9C1C2C3R1R2R3R4R5R6R7R8R9"

  setup do
    @puzzle = Puzzle.new
  end

  test "can create puzzle object" do
    assert @puzzle
  end

  test "initial history and states" do
    assert_equal [step:0, state:"L1L2L3L4L5L6L7L8L9C1C2C3R1R2R3R4R5R6R7R8R9", side:nil, n:nil, solved:true ], @puzzle.history
    assert_equal [INITIAL_STATE], @puzzle.states.to_a
    assert_equal [INITIAL_STATE], @puzzle.solved_states.to_a
  end

  test "initially solved" do
    assert @puzzle.solved?, "Should be solved"
  end

  test "initial state" do
    assert_equal INITIAL_STATE, @puzzle.state
  end

  test "state after 1 shift on left" do
    @puzzle.shift_one(:left)
    assert_equal "L3L4L5L6L7L8L9C1C2C3L1L2R1R2R3R4R5R6R7R8R9", @puzzle.state
  end

  test "state after 1 shift on right" do
    @puzzle.shift_one(:right)
    assert_equal "L1L2L3L4L5L6L7L8L9C3R1R2R3R4R5R6R7R8R9C1C2", @puzzle.state
  end

  test "shift 6 times has no effect" do
    @puzzle.shift(:left,6)
    assert_equal INITIAL_STATE, @puzzle.state
    @puzzle.shift(:right,6)
    assert_equal INITIAL_STATE, @puzzle.state
  end

  test "changes to original puzzle do not affect clone" do
    cloned_puzzle = @puzzle.deep_clone
    @puzzle.shift(:left,3)
    @puzzle.shift(:right,2)
    assert_equal INITIAL_STATE, cloned_puzzle.state
  end
end