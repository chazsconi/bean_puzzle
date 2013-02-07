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