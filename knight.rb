require_relative 'piece'

class Knight < Piece
include Steppable

  def move_steps
    KNIGHT_STEPS
  end

  def to_s
    "♞ ".colorize(colour)
  end
end
