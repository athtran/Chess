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
  attr_reader :name, :colour, :board, :start, :destionation

  def initialize(name, colour, board)
    @name = name
    @colour = colour
    @board = board
  end

  def generate_start
    [1,5]
  end

  def generate_destination
    [3,5]
  end

  def get_move
    sleep (1/2)
    @start ||= generate_start
    @destination ||= generate_destination


    if board.selected_piece.nil?
      return "\r" if board.cursor_pos == @start
      move_to(@start)
    else
      if board.cursor_pos == @destination
        @start, @destination = nil, nil
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
    elsif board.cursor_pos[1] < pos[1]
      "a"
    end
  end
end
