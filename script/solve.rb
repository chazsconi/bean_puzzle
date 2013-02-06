require 'set'
require 'benchmark'

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
