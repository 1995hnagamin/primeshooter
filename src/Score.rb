class Score
  attr_reader :value
  include EnemiesObserver

  def initialize(enemies)
    enemies.register_observer self
    @value = 0
  end

  def update_enemy_destroyed(point)
    @value += point
  end
end
