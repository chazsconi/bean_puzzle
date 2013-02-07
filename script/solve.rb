require_relative '../config/environment'

if __FILE__==$0
  puzzle = Puzzle.new
  puts "Initial Puzzle = #{puzzle}"
  #puzzle.unsolve 5
  puzzle.shift(:left,5)
  puzzle.shift(:right,5)
  puzzle.shift(:left,5)
  puzzle.shift(:right,5)
  puzzle.shift(:left,5)
  puts "Unsolved puzzle = #{puzzle}"

  solver = Solver.new(14)
  
  solutions = solver.solve_puzzle(puzzle, 0)
  best_solution_steps = solutions.map{ |s| s.history_size }.min
  puts "Solutions = #{solutions.size} Best solution steps=#{best_solution_steps}"

  #dcbm = Benchmark.measure do
  #  1000.times { puzzle2 = puzzle.deep_clone }
  #end
  puts "History size = #{puzzle.history.size} states size = #{puzzle.states.size} solved size = #{puzzle.solved_states.size}"
#puts "Time for deep_clone = #{dcbm}"
#puts puzzle.deep_clone
end
