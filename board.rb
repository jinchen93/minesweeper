require_relative 'tile'
require 'colorize'

class Board
  attr_reader :grid

  def self.empty_board(size = 9)
    Array.new(size) { Array.new(size) { Tile.new } }
  end

  def initialize(grid = Board.empty_board)
    @grid = grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def place_bomb(pos)
    self[pos].become_bomb
    neighbors(pos).each do |n_pos|
      self[n_pos].increment_value
    end
  end

  def place_random_bombs(num = 10)
    until num_bombs == num
      rand_pos = get_random_pos
      place_bomb(rand_pos) unless self[rand_pos].bombed?
    end
  end

  def get_random_pos
    row = (0...9).to_a.sample
    col = (0...9).to_a.sample
    [row, col]
  end

  def bombed_positions
    result = []
    (0...9).each do |row|
      (0...9).each do |col|
        pos = [row, col]
        result << pos if self[pos].bombed?
      end
    end
    result
  end

  def num_bombs
    bombed_positions.length
  end

  def render
    puts "  " + (0..8).to_a.join(" ")
    grid.each_with_index do |row, i|
      row_display = row.map { |tile| tile.to_s }
      puts "#{i} #{row_display.join(" ")}"
    end
    puts
  end

  def reveal_all
    grid.each do |row|
      row.each do |tile|
        tile.reveal
      end
    end
    true
  end

  def neighbors(pos)
    row, col = pos
    results = []
    (row - 1..row + 1).each do |i|
      (col - 1..col + 1).each do |j|
        test_pos = [i, j]
        next if test_pos == pos || !valid_pos?(test_pos)
        results << test_pos
      end
    end
    results
  end

  def valid_pos?(pos)
    pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |x| (0..8).cover?(x) }
  end
end
