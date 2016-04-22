require 'byebug'
require_relative 'piece'
require_relative 'knight'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
require_relative 'player'
require 'yaml'


require_relative 'board'

class Game
  attr_reader :board, :player1
  attr_accessor :force_quit, :moved, :current_player

  def initialize
    @player1 = Player.new("Player 1 - White", :white)
    @board = Board.new(@player1)
    @player2 = ComputerPlayer.new("ComputerPlayer - Black", :black, @board)
    @current_player = @player1
  end

  def play
    until over? || force_quit
      until moved || force_quit
        render_board
        char = current_player.get_move
        handle_char(char)
      end
      change_current_player
      check_if_check(current_player)
    end

    win_message unless force_quit
  end

  private

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
    @moved = false
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
    board.kings.each { |king| return king if king.colour == current_player.colour }
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

  def handle_char(char)
    case char
    when "q"
      self.force_quit = true
    when "a"
      board.move_cursor(:left)
    when "s"
      board.move_cursor(:down)
    when "d"
      board.move_cursor(:right)
    when "w"
      board.move_cursor(:up)
    when "\r"
      select_piece_or_move
    when "v"
      File.open("saved_version", 'w') do |file|
        file.print self.to_yaml
      end
    end
  end

  def select_piece_or_move
    if board.selected_piece.nil?
      board.select_piece(current_player.colour)
    else
      move_piece
    end
  end

  def move_piece
    if board.selected_piece.can_move_to?(board.cursor_pos)
      @moved = true
      board.selected_piece.move_to!(board.cursor_pos)
    end
    board.selected_piece = nil
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
