require_relative 'piece'

class Rook < Piece
include Slideable

  def move_dirs
    HORIZ_DIRS
  end

  def to_s
    "♜ ".colorize(colour)
  end
end
