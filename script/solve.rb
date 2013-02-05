require 'set'
require 'benchmark'

class Puzzle
  class Bean
    def initialize(colour,size, original_ring, original_position_in_ring)

      raise ArgumentError, "Invalid size"if not [:big,:small].include?(size)
      raise ArgumentError, "Invalid colour" if not [:white, :yellow, :brown].include?(colour) ;

      @size = size
      @colour = colour
      @original_position = {ring: original_ring, position: original_position_in_ring}
    end

    def colour
      @colour
    end

    def to_s
      "#{@colour}\t#{@size}\t#{@original_position[:ring]}\t#{@original_position[:position]}"

    end

    def id
      side_initial = case @original_position[:ring]
      when :left then  "L"
      when :right then "R"
      when :centre then "C"
      else "X"
      end
      "#{side_initial}#{@original_position[:position]}"
    end

  end

  class Ring

    @beans = []
    def initialize(puzzle)
      @puzzle = puzzle
    end

    def beans
      @beans
    end

    def solved?
      true
    end

    def to_s
      out = ""
      @beans.each do |bean|
        out += bean.to_s + "\n"
      end

      out
    end

    def state
      @beans.map(&:id)
    end

    def state_to_s
      s=""
      @beans.each do |bean|
        s+=bean.id
      end
      s
    end

  end

  class SideRing < Ring
    def initialize(name)
      @beans = []

      @beans << Bean.new(:yellow,:big,    name, 1)
      @beans << Bean.new(:yellow,:small,  name, 2)
      @beans << Bean.new(:yellow,:big,    name, 3)

      @beans << Bean.new(:white,:small,   name, 4)
      @beans << Bean.new(:white,:big,     name, 5)
      @beans << Bean.new(:white,:small,   name, 6)

      @beans << Bean.new(:brown,:big,     name, 7)
      @beans << Bean.new(:brown,:small,   name, 8)
      @beans << Bean.new(:brown,:big,     name, 9)

    end

    def solved?
      @beans[0].colour == :yellow &&
      @beans[1].colour == :yellow &&
      @beans[2].colour == :yellow &&
      @beans[3].colour == :white &&
      @beans[4].colour == :white &&
      @beans[5].colour == :white &&
      @beans[6].colour == :brown &&
      @beans[7].colour == :brown &&
      @beans[8].colour == :brown

    end
  end

  class CentreRing < Ring
    def initialize
      @beans = []

      @beans << Bean.new(:white,:small, :centre, 1)
      @beans << Bean.new(:white,:big, :centre, 2)
      @beans << Bean.new(:white,:small, :centre, 3)

    end

    def solved?
      @beans[0].colour == :white &&
      @beans[1].colour == :white &&
      @beans[2].colour == :white
    end
  end

  def initialize
    @sides = {:left => SideRing.new(:left), :right => SideRing.new(:right)}
    @centre = CentreRing.new
    @random = Random.new
    @history = []
    @history_step = 0
    @states = Set.new
    @solved_states = Set.new

    save_history
  end

  def shift(side,n)
    n.times { |i| shift_one(side) }
    save_history(side, n)
  end

  def shift_one(side)
    @centre.beans << @sides[side].beans.shift
    @centre.beans << @sides[side].beans.shift

    @sides[side].beans << @centre.beans.shift
    @sides[side].beans << @centre.beans.shift
  end

  def save_history(side=nil, n=nil)
    solved = solved?
    @history << {step: @history_step, state:state, side:side, n:n, solved: solved}
    @states << state
    if solved
      @solved_states << state
      puts "Time=#{Time.now} New solved state.  Total solved states = #{@solved_states.size} Total moves=#{@history_step-1}"
    end
    @history_step +=1
  end

  def reset_history
    @history = []
    @history_step = 0
    @states = Set.new
    @solved_states = Set.new

    save_history

  end

  def history
    @history
  end

  def states
    @states
  end

  def solved_states
    @solved_states
  end

  def history_size
    @history_step-1
  end

  def shift_random
    r = @random.rand(2)
    n = @random.rand(5)+1
    if r==0
      shift(:left,n)
    else
      shift(:right,n)
    end
  end

  def solved?
    @sides[:left].solved? && @sides[:right].solved? && @centre.solved?
  end

  def unsolve(moves)
    moves.times do |n|
      shift_random
    end
  end

  def solved_history
    @history.select {|h| h[:solved] }
  end

  def to_s
    "LEFT:\n#{@sides[:left]}\nCENTRE:\n#{@centre}\nRIGHT: \n#{@sides[:right]}\nSOLVED=#{solved?}"
  end

  def state
    #  {left: @sides[:left].state, centre: @centre.state, right: @sides[:right].state}
    @sides[:left].state_to_s + @centre.state_to_s + @sides[:right].state_to_s
  end

  def deep_clone
    Marshal.load(Marshal.dump(self))
  end

end

def solve_puzzle(puzzle_base, depth)

  @recursions+=1
  puts "recursions=#{@recursions}/#{@total_recursions} depth=#{depth}" if @recursions % 1000==0

  if puzzle_base.solved?
    return [puzzle_base]
  end

  if depth >= @max_depth
    return nil
  end

  puzzle_shift_left = puzzle_base.deep_clone
  puzzle_shift_left.shift(:left,1)
  puzzle_shift_right = puzzle_base.deep_clone
  puzzle_shift_right.shift(:right,1)

  solved_puzzles = []

  solved_left = solve_puzzle(puzzle_shift_left, depth+1)
  solved_right = solve_puzzle(puzzle_shift_right, depth+1)

  solved_puzzles.concat solved_left if solved_left
  solved_puzzles.concat solved_right if solved_right

  return solved_puzzles
end

if __FILE__==$0
  puzzle = Puzzle.new
puts "Initial Puzzle = #{puzzle}"
  #puzzle.unsolve 5
  puzzle.shift(:left,5)
  puzzle.shift(:right,5)
  #puzzle.shift(:left,5)
  #puzzle.shift(:right,5)
  #puzzle.shift(:left,5)
puts "Unsolved puzzle = #{puzzle}"
@recursions = 0
@max_depth = 4
@total_recursions = 2**(@max_depth+1)
  solutions = solve_puzzle(puzzle, 0)
  best_solution_steps = solutions.map{ |s| s.history_size }.min
puts "Solutions = #{solutions.size} Best solution steps=#{best_solution_steps}"

  #dcbm = Benchmark.measure do
  #  1000.times { puzzle2 = puzzle.deep_clone }
  #end
puts "History size = #{puzzle.history.size} states size = #{puzzle.states.size} solved size = #{puzzle.solved_states.size}"
#puts "Time for deep_clone = #{dcbm}"
#puts puzzle.deep_clone
end
