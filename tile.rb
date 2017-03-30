class Tile
  attr_reader :flagged, :bomb

  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @visible = false

    @neighbors = []
  end

  def toggle_flag
    @flagged = !flagged
  end

  def reveal
    @visible = true
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

  def neighbor_bomb_count
    @neighbors.count(&:bombed?)
  end

  def add_neighbor(neighbor) end
end
