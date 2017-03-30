require_relative 'board'
require_relative 'tile'

class MinesweeperGame
  attr_reader :board

  def initialize(board = Board.new)
    @board = board
    @revealed_bomb = false
  end

  def run
    board.render
    play_turn until over?

    board.reveal_all
  end

  def play_turn
    turn_type = get_type_of_turn
    pos = get_pos
    if turn_type == "r"
      board.recursive_reveal(pos)
      @revealed_bomb = true if board[pos].bombed?
    else
      board[pos].toggle_flag
    end
    board.render
  end

  def get_type_of_turn
    puts "Flag or reveal? f/r"
    turn = gets.chomp

    until ["f", "r"].include?(turn)
      puts "Enter a valid turn type, 'f' or 'r'"
      turn = gets.chomp
    end

    turn
  end

  def get_pos
    puts "Enter a position"
    pos = parse_pos(gets.chomp)

    until board.valid_pos?(pos)
      puts "Enter a valid board positon!"
      pos = parse_pos(gets.chomp)
    end

    pos
  end

  def parse_pos(string)
    string.split(",").map { |char| Integer(char) }
  end

  def over?
    @revealed_bomb || board.only_bombs?
  end

end

if __FILE__ == $PROGRAM_NAME
  MinesweeperGame.new.run
end
