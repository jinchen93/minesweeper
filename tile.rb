class Tile
  attr_reader :flagged, :bomb

  def initialize(bomb = false)
    @bomb = bomb
    bomb ? @value = -1 : @value = 0
    @flagged = false
    @visible = false

    @old_color = nil
    @color = :black
  end

  def toggle_flag
    @flagged = !flagged
    @color = :red if @flagged
  end

  def reveal
    @visible = true unless flagged?
    if bombed?
      @color = :red
    elsif fringe?
      @color = :blue
    end
  end

  def bombed?
    bomb
  end

  def visible?
    @visible
  end

  def flagged?
    @flagged
  end

  def fringe?
    @value > 0
  end

  def increment_value
    @value += 1 unless bombed?
  end

  def become_bomb
    @bomb = true
  end

  def to_s
    if visible?
      if bombed?
        str = "b"
      else
        str = @value == 0 ? "_" : @value.to_s
      end
    else
      str = flagged? ? "F" : "*"
    end
    str.colorize(@color)
  end

  def turn_on_cursor
    @old_color = @color
    @color = :green
  end

  def turn_off_cursor
    @color = @old_color
    @old_color = nil
  end

  def neighbor_bomb_count
    bombed? ? 0 : @value
  end

end
