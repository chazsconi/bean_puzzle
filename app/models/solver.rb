class Solver
  def initialize(max_depth)
    @recursions = 0
    @max_depth = max_depth
    @total_recursions = 2**(@max_depth+1)
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
end
