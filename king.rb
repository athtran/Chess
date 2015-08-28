require_relative 'piece'

class King < Piece
include Steppable
attr_accessor :in_danger

  def move_steps
    KING_STEPS
  end

  def is_in_danger
    self.in_danger = true
  end

  def is_safe
    self.in_danger = false
  end

  def to_s
    if in_danger == true
      "♚ ".colorize(:light_red)
    else
      "♚ ".colorize(colour)
    end
  end
end
