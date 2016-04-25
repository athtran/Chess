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

class ComputerPlayer
  attr_reader :name, :colour, :board, :start, :destination, :selected_piece

  def initialize(name, colour, board)
    @name = name
    @colour = colour
    @board = board
  end

  def generate_start
    possible_starts = board.pieces_that_can_move(@colour).select do |piece|
      piece.can_take_opponent?
    end

    @selected_piece = (possible_starts.empty? ? board.pieces_that_can_move(@colour).sample : pick_max_start(possible_starts))
    @selected_piece.pos
  end

  def generate_destination
    @selected_piece.can_take_opponent? ? @selected_piece.take_positions.sample : pick_max_end(@selected_piece)
  end

  def pick_max_start(array)
    array.max_by {|piece| piece.max_value_of_possible_captures }
  end

  def pick_max_end(piece)
    piece.highest_possible_capture
  end

  def get_move
    sleep (1.0/12)
    @start ||= generate_start
    @destination ||= generate_destination

    if board.selected_piece.nil?
      return "\r" if board.cursor_pos == @start
      move_to(@start)
    else
      if board.cursor_pos == @destination
        @start, @destination, @selected_piece = nil, nil, nil
        return "\r"
      end
      move_to(@destination)
    end
  end

  def move_to(pos)
    if board.cursor_pos[0] < pos[0]
      "s"
    elsif board.cursor_pos[0] > pos[0]
      "w"
    elsif board.cursor_pos[1] < pos[1]
      "d"
    elsif board.cursor_pos[1] > pos[1]
      "a"
    end
  end
end
