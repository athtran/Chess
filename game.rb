require 'byebug'
require_relative 'piece'
require_relative 'knight'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
require 'yaml'


require_relative 'board'

class Game
  attr_reader :board, :player1
  attr_accessor :quit_var, :moved, :current_player

  def initialize
    @board = Board.new
    @player1 = Player.new("Player 1 - White", :white)
    @player2 = Player.new("Player 2 - Black", :black)
    @current_player = @player1
    @quit_var = false
    @move_completed = false
  end

  def play
    piece = nil
    until over? || force_quit?
      until moved? || force_quit?
        render_board
        char = current_player.get_move
        handle_char(char)
      end
      change_current_player
      check_if_check(current_player)
    end

    win_message unless force_quit?
  end

  def render_board
    system("clear")
    board.render
    puts current_player.name
    puts "Piece selected: #{board.selected_piece}#{board.selected_piece.class}" unless board.selected_piece.nil?
    puts "" if board.selected_piece.nil?
    puts ""
    puts "Controls:"
    puts "   WASD keys to move the cursor"
    puts "   Enter to select and deselect a piece"
    puts "   V to save your game"
    puts "   Q to quit"
  end

  def change_current_player
    current_player == @player1 ? self.current_player = @player2 : self.current_player = @player1
    @move_completed = false
  end

  def force_quit?
    quit_var
  end

  def check_if_check(current_player)
    king = find_king(current_player)
    if board.check?(current_player.colour)
      king.is_in_danger
    else
      king.is_safe
    end
  end

  def find_king(current_player)
    (0..7).each do |row|
      (0..7).each do |col|
        pos = row, col
        if board[*pos].class == King && board[*pos].colour == current_player.colour
          return board[*pos]
        end
      end
    end
  end

  def win_message
    puts "#{current_player.name} is in Checkmate!"
  end

  def check?
    board.check?(current_player.colour)
  end

  def over?
    board.checkmate?(current_player.colour)
  end

  def moved?
    @move_completed
  end

  def handle_char(char)
    case char
    when "q"
      self.quit_var = true
    when "a"
      board.move_cursor(:left)
    when "s"
      board.move_cursor(:down)
    when "d"
      board.move_cursor(:right)
    when "w"
      board.move_cursor(:up)
    when "\r"
      # debugger
      if board.selected_piece.nil?
        board.select_piece(current_player.colour)
      else
        if board.selected_piece.move_to(board.cursor_pos)

          @move_completed = true
          board.selected_piece.move_to!(board.cursor_pos)
        end
        board.selected_piece = nil
      end
    when "v"
      File.open("saved_version", 'w') do |file|
        file.print self.to_yaml
      end
    end
  end


end

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

if __FILE__ == $PROGRAM_NAME
  puts "Do you want to load a saved game? (y/n)"
  input = gets.chomp
  if input[0].downcase == "y"
    saved_version = File.open("saved_version")
    g = YAML::load(saved_version)
  else
    g = Game.new
  end
  g.play
end
