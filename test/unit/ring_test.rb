require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class RingTest < ActiveSupport::TestCase

  test "can initialize" do
    puzzle = nil
    assert Ring.new(puzzle)
  end

  test "cannot initialize empty ring" do
    assert_raise ArgumentError do
      Ring.new
    end
  end
end

class SideRingTest < ActiveSupport::TestCase
  test "can initialize" do
    assert SideRing.new(:left)
    assert SideRing.new(:right)
  end

  test "initially solved" do
    ring = SideRing.new(:left)
    assert ring.solved?
  end

  test "after 1 move not solved" do
    ring = SideRing.new(:left)
    ring.beans.rotate!
    assert !ring.solved?
  end

  test "initial state" do
    ring = SideRing.new(:left)
    assert_equal ["L1","L2","L3","L4","L5","L6", "L7", "L8", "L9"], ring.state
    assert_equal "L1L2L3L4L5L6L7L8L9", ring.state_to_s
  end

  test "rotated state" do
    ring = SideRing.new(:left)
    ring.beans.rotate!
    assert_equal ["L2","L3","L4","L5","L6", "L7", "L8", "L9","L1"], ring.state
    assert_equal "L2L3L4L5L6L7L8L9L1", ring.state_to_s
  end

end

class CentreRingTest < ActiveSupport::TestCase
  test "can initialize" do
    assert CentreRing.new()
  end

  test "initially solved" do
    ring = CentreRing.new()
    assert ring.solved?
  end

  test "rotated state still solved" do
    ring = CentreRing.new()
    ring.beans.rotate!
    assert ring.solved?
  end

  test "after changed bean not solved" do
    ring = CentreRing.new()
    ring.beans[0] = Bean.new(:brown,:small,:left, 5)
    assert !ring.solved?
  end

  test "initial state" do
    ring = CentreRing.new()
    assert_equal ["C1","C2","C3"], ring.state
    assert_equal "C1C2C3",ring.state_to_s
  end

  test "rotated state" do
    ring = CentreRing.new()
    ring.beans.rotate!
    assert_equal ["C2","C3","C1"], ring.state
    assert_equal "C2C3C1",ring.state_to_s
  end

end