require_relative 'piece'

class Queen < Piece
include Slideable

  def move_dirs
    HORIZ_DIRS + DIAG_DIRS
  end

  def to_s
    "♛ ".colorize(colour)
  end
end
