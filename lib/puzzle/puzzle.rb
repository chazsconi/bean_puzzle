class Puzzle

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
      #puts "Time=#{Time.now} New solved state.  Total solved states = #{@solved_states.size} Total moves=#{@history_step-1}"
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