require 'colorize'
require 'byebug'
require 'io/console'

class Board
  attr_accessor :grid, :cursor_pos, :helper, :selected_piece, :res_piece

  CURSOR_MOVES = {
      :left => [0, -1],
      :right => [0, 1],
      :down => [1, 0],
      :up => [-1, 0]
  }

  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySpace.new } }
    @cursor_pos = 0, 0
    @helper = false
    @selected_piece = nil
    populate_board
  end

  def populate_board
    (0..7).each do |col|
      self[1,col] = Pawn.new([1,col], :black, self)
    end
    self[0,0] = Rook.new([0,0], :black, self)
    self[0,1] = Knight.new([0,1], :black, self)
    self[0,2] = Bishop.new([0,2], :black, self)
    self[0,3] = Queen.new([0,3], :black, self)
    self[0,4] = King.new([0,4], :black, self)
    self[0,5] = Bishop.new([0,5], :black, self)
    self[0,6] = Knight.new([0,6], :black, self)
    self[0,7] = Rook.new([0,7], :black, self)


    (0..7).each do |col|
      self[6,col] = Pawn.new([6,col], :white, self)
    end

    self[7,0] = Rook.new([7,0], :white, self)
    self[7,1] = Knight.new([7,1], :white, self)
    self[7,2] = Bishop.new([7,2], :white, self)
    self[7,3] = King.new([7,3], :white, self)
    self[7,4] = Queen.new([7,4], :white, self)
    self[7,5] = Bishop.new([7,5], :white, self)
    self[7,6] = Knight.new([7,6], :white, self)
    self[7,7] = Rook.new([7,7], :white, self)

  end

  def select_piece(colour)
    # debugger
    unless self[*cursor_pos].class == EmptySpace || self[*cursor_pos].colour != colour
      @selected_piece = self[*cursor_pos]
    end
  end

  def render
    print " "
    ("a".."h").each { |col_index| print " #{col_index}"}
    puts
    row_label = 8
    (0..7).each do |row|
      print row_label
      row_label -= 1
      (0..7).each do |col|
        pos = row, col
        object_on_tile = self[*pos]

        case
        when @cursor_pos == [*pos]
          print object_on_tile.to_s.on_light_yellow
        when (selected_piece || self[*cursor_pos]).possible_moves.include?([*pos])
          print object_on_tile.to_s.on_light_cyan
        when (row + col).even?
          print object_on_tile.to_s.on_light_white
        when (row + col).odd?
          print object_on_tile.to_s.on_light_black
        end
      end
      puts
    end

    puts debug_info
  end

  def [](*pos)
    begin
      row,col = pos
      grid[row][col]
    rescue NoMethodError
      byebug
    end
  end

  def []=(*pos,value)
    row,col = pos
    grid[row][col] = value
  end

  def move_cursor(direction)
    dx, dy = CURSOR_MOVES[direction]
    x, y = cursor_pos

    @cursor_pos = dx + x, dy + y if on_board?([dx + x, dy + y])
  end

  def valid?(move)
    on_board?(move)
  end

  def on_board?(move)
    x, y = move
    x.between?(0,7) && y.between?(0,7)
  end

  def check?(colour)
    (0..7).each do |row|
      (0..7).each do |col|
        check_pos = row,col
        # debugger
        self[*check_pos].possible_moves.each do |move|
          return true if self[*move].class == King && self[*move].colour == colour
        end
      end
    end
    false
  end

  def checkmate?(colour)
    (0..7).each do |row|
      (0..7).each do |col|
        check_pos = row,col
        self[*check_pos].colour == colour ? piece = self[*check_pos] : next

        return false unless piece.actual_possible_moves.empty?
      end
    end

    true
  end



  def debug_info
    if self.helper
      piece = self[*cursor_pos]
      message = ''
        # debugger
        message += "Class: #{piece.class} \n"
        message += "Colour: #{piece.colour} \n"
        message += "Pos : #{piece.pos} \n"
        message += "Possible moves: #{piece.possible_moves} \n"
        message += "Cursor Position: #{cursor_pos} \n"
        message += "Selected Piece: #{selected_piece.class} \n"
        message += "Check white?: #{self.check?(:white)} \n"
        message += "Check black?: #{self.check?(:black)} \n"
        message += "Checkmate white?: #{self.checkmate?(:white)} \n"
        message += "Checkmate black?: #{self.checkmate?(:black)} \n"

        # message += "Conflicts: #{self.conflicts} \n"
      message
    end
  end


end

class EmptySpace
  def to_s
    "  ".colorize(:white)
  end

  def colour
  end

  def move_to(arg)
    raise "cant move empty space"
    rescue
  end

  def pos
  end

  def actual_possible_moves
    []
  end

  def possible_moves
    []
  end
end
