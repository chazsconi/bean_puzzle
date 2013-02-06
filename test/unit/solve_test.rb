require 'test_helper'
require './script/solve.rb'

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

class BeanTest < ActiveSupport::TestCase
  [:white, :yellow, :brown].each do |colour|
    [:big, :small].each do |size|
      test "Can create bean object of #{colour}, #{size}" do
        assert Puzzle::Bean.new(colour, size, :left, 5)
      end
    end
  end

  test "invalid bean colour" do
    assert_raise ArgumentError do
      Puzzle::Bean.new(:red,:small,:left, 5)
    end
  end

  test "invalid size" do
    assert_raise ArgumentError do
      Puzzle::Bean.new(:white,:medium,:left, 5)
    end
  end

  test "ID method works" do
    assert_equal "L5", Puzzle::Bean.new(:white,:big,:left, 5).id
    assert_equal "R5", Puzzle::Bean.new(:white,:big,:right, 5).id
    assert_equal "C5", Puzzle::Bean.new(:white,:big,:centre, 5).id
  end
end

class RingTest < ActiveSupport::TestCase

  test "can initialize" do
    puzzle = Puzzle.new
    assert Puzzle::Ring.new(puzzle)
  end

  test "cannot initialize empty ring" do
    assert_raise ArgumentError do
      Puzzle::Ring.new
    end
  end
end

class SideRingTest < ActiveSupport::TestCase
  test "can initialize" do
    assert Puzzle::SideRing.new(:left)
    assert Puzzle::SideRing.new(:right)
  end
  
  test "initially solved" do
    ring = Puzzle::SideRing.new(:left)
    assert ring.solved?
  end
  
  test "after 1 move not solved" do
    ring = Puzzle::SideRing.new(:left)
    ring.beans.rotate!
    assert !ring.solved?
  end
  
  test "initial state" do
    ring = Puzzle::SideRing.new(:left)
    assert_equal ["L1","L2","L3","L4","L5","L6", "L7", "L8", "L9"], ring.state
    assert_equal "L1L2L3L4L5L6L7L8L9", ring.state_to_s
  end

  test "rotated state" do
    ring = Puzzle::SideRing.new(:left)
    ring.beans.rotate!
    assert_equal ["L2","L3","L4","L5","L6", "L7", "L8", "L9","L1"], ring.state
    assert_equal "L2L3L4L5L6L7L8L9L1", ring.state_to_s
  end
  
end


class CentreRingTest < ActiveSupport::TestCase
  test "can initialize" do
    assert Puzzle::CentreRing.new()
  end
  
  test "initially solved" do
    ring = Puzzle::CentreRing.new()
    assert ring.solved?
  end
  
  test "rotated state still solved" do
    ring = Puzzle::CentreRing.new()
    ring.beans.rotate!
    assert ring.solved?
  end

  test "after changed bean not solved" do
    ring = Puzzle::CentreRing.new()
    ring.beans[0] = Puzzle::Bean.new(:brown,:small,:left, 5)
    assert !ring.solved?
  end
  
  test "initial state" do
    ring = Puzzle::CentreRing.new()
    assert_equal ["C1","C2","C3"], ring.state
    assert_equal "C1C2C3",ring.state_to_s
  end

  test "rotated state" do
    ring = Puzzle::CentreRing.new()
    ring.beans.rotate!
    assert_equal ["C2","C3","C1"], ring.state
    assert_equal "C2C3C1",ring.state_to_s
  end
  
end

