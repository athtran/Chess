class Player
  attr_reader :name, :colour

  def initialize(name, colour)
    @name = name
    @colour = colour
  end

  def get_move
    move = $stdin.getch
  end
end
