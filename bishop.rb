require_relative 'piece'

class Bishop < Piece
include Slideable

  def move_dirs
    DIAG_DIRS
  end

  def to_s
    "\u265D".encode('utf-8').colorize(colour) + " "
  end
end
