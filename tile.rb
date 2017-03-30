class Tile
  attr_reader :flagged, :bomb

  def initialize(bomb = false)
    @bomb = bomb
    bomb ? @value = -1 : @value = 0
    @flagged = false
    @visible = false
  end

  def toggle_flag
    @flagged = !flagged
  end

  def reveal
    @visible = true unless flagged?
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
        "b".colorize(:red)
      else
        @value == 0 ? "_" : @value.to_s.colorize(:blue)
      end
    else
      flagged? ? "F" : "*"
    end
  end

  def neighbor_bomb_count
    bombed? ? 0 : @value
  end
end
