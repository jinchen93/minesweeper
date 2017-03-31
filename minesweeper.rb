require_relative 'board'
require_relative 'tile'
require_relative 'keypress'

class MinesweeperGame
  attr_reader :board

  def initialize(board = Board.new)
    @board = board
    @revealed_bomb = false
    @cursor = [0, 0]
  end

  # def run
  #   board.render
  #   play_turn until over?
  #
  #   board.reveal_all
  #   puts won? ? "You win!" : "You lose!"
  # end

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

  def cursor_move
    loop do
      pos = @cursor.dup
      board[pos].toggle_cursor

      system('clear')
      board.render
      get_cursor_move
      board[pos].toggle_cursor
    end
  end

  def run
    until over?
      pos = @cursor.dup
      board[pos].turn_on_cursor

      system('clear')
      board.render

      c = read_char #get keystroke

      if c.start_with?("\e")
        parse_cursor_move(c)
      elsif c == "f"
        board[pos].toggle_flag
      elsif c == " "
        board.recursive_reveal(pos)
        @revealed_bomb = true if board[pos].bombed?
      elsif c == "q"
        break
      end
    end

    board.reveal_all
    puts won? ? "You win!" : "You lose!"
  end

  def parse_cursor_move(c)
    board[@cursor].turn_off_cursor

    case c
    when "\e[A"
      @cursor[0] = (@cursor[0] - 1) % 9
    when "\e[B"
      @cursor[0] = (@cursor[0] + 1) % 9
    when "\e[C"
      @cursor[1] = (@cursor[1] + 1) % 9
    when "\e[D"
      @cursor[1] = (@cursor[1] - 1) % 9
    end
  end

  def parse_pos(string)
    string.split(",").map { |char| Integer(char) }
  end

  def over?
    won? || lost?
  end

  def won?
    board.only_bombs?
  end

  def lost?
    @revealed_bomb
  end

end

if __FILE__ == $PROGRAM_NAME
  MinesweeperGame.new.run
end
