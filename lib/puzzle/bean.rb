module Puzzle
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
end