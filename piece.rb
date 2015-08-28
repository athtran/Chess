class Piece

  attr_reader :colour, :pos, :board

  def initialize(pos, colour, board)
    @board = board
    @pos = pos
    @colour = colour
  end

  def add_direction_to_pos(dir)
    pos.each_with_index.map { |x, i| x + dir[i] }
  end

  def sum_two_arrays(arr1, arr2)
    arr1.each_with_index.map { |x, i| x + arr2[i] }
  end

  def move_to(cursor_pos)
    if self.actual_possible_moves.include?(cursor_pos)
      @moved = true
    end
  end

  def move_to!(this_place)
    board[*pos] = EmptySpace.new
    @pos = this_place
    board[*this_place] = self
  end

  def actual_possible_moves #takes in possible moves for piece, removes moves that result in check
    actual_possible_moves_array = []
    old_pos = pos

    possible_moves.each do |move|
      board.res_piece = board[*move]
      self.move_to!(move)
      actual_possible_moves_array << move unless board.check?(self.colour)
      self.move_to!(old_pos)
      board[*move] = board.res_piece
    end

    actual_possible_moves_array
  end
end



module Steppable
  KNIGHT_STEPS = [[-1, -2], [-1, 2], [-2, -1], [-2, 1], [1, -2], [1, 2], [2, -1], [2, 1]]
  KING_STEPS = [[-1, -1],[0, -1],[1, -1],[-1, 0], [1, 0],[-1, 1],[0, 1],[1, 1]]

  def possible_moves
    steps = move_steps
    possible_moves = []

    steps.each do |step|
      new_pos = add_direction_to_pos(step)
      next unless board.on_board?(new_pos)
      if board[*new_pos].class == EmptySpace
        possible_moves << new_pos
      elsif board[*new_pos].colour != self.colour
        possible_moves << new_pos
      end

      # restrict check moves maybe
    end

    possible_moves
  end
end

module Slideable

  HORIZ_DIRS = [[1,0], [-1,0], [0,1], [0,-1]]
  DIAG_DIRS = [[1,1], [-1,1],[-1,-1],[1,-1]]

  def possible_moves
    dirs = move_dirs
    possible_moves = []

    # iterate through move_dirs, and grow your possible moves
    dirs.each do |dir|
      # debugger
      new_pos = add_direction_to_pos(dir)
      while board.on_board?(new_pos)
        if board[*new_pos].class == EmptySpace
          possible_moves << new_pos
        elsif board[*new_pos].colour != self.colour
          possible_moves << new_pos
          break
        else
          break
        end
        # new_pos = new_pos.each_with_index.map { |x, i| x + dir[i] }
        new_pos = sum_two_arrays(new_pos, dir)
      end
    end

    possible_moves
  end
end
