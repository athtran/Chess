require_relative 'piece'

class Pawn < Piece

  WHITE_MOVES = [[-1,-1], [-1, 0], [-2, 0], [-1, 1]]
  BLACK_MOVES = [[1, 1], [1, 0], [2, 0], [1, -1]]


  def initialize(pos, colour, board)
    super(pos, colour, board)
    @moved = false
  end

  def moved?
    @moved
  end

  def moves
    #black starts at top
    return BLACK_MOVES if colour == :black
    return WHITE_MOVES if colour == :white
  end

  def possible_moves
    possible_moves = []

    if check_two_forward?(moves[1], moves[2])
      move = add_direction_to_pos(moves[2])
      possible_moves << move
    end
    if check_one_forward?(moves[1])
      move = add_direction_to_pos(moves[1])
      possible_moves << move
    end
    if check_diagonal(moves[0])
      move = add_direction_to_pos(moves[0])
      possible_moves << move
    end
    if check_diagonal(moves[3])
      move = add_direction_to_pos(moves[3])
      possible_moves << move
    end

    possible_moves
  end

  def check_two_forward?(first_move, second_move)
    first_move = add_direction_to_pos(first_move)
    second_move = add_direction_to_pos(second_move)

    return false if moved?
    if board[*first_move].class == EmptySpace
      if board[*second_move].class == EmptySpace
        return true
      end
    end

    false
  end

  def check_one_forward?(delta)
    new_pos = add_direction_to_pos(delta)
    # debugger
    board.on_board?(new_pos) && board[*new_pos].class == EmptySpace
    #
    # true
  end

  def check_diagonal(delta)
    new_pos = add_direction_to_pos(delta)

    return false unless board.on_board?(new_pos)
    return true if board[*new_pos].class != EmptySpace && board[*new_pos].colour != self.colour
    false
  end

  def to_s
    "\u265F".encode('utf-8').colorize(colour) + " "
  end
end
