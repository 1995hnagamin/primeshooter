class Game
  attr_reader :gun, :life, :enemies
  def initialize(env)
    @gun = Gun.new(env[:gun_width])
    @life = Life.new(env[:life], env[:life_width])
    @enemies =Enemies.new(env[:max_enemy_size], env[:field_width],
                          env[:max_enemy_amount])
    @enemies.init_stage

    @score = 0
    @terminated = false
  end

  def step
    return nil if game_over?
    @gun.step
    d = @enemies.step
    @life.damage d
    @gun.disable if d > 0
    @enemies.create_enemy
  end

  def terminate
    @terminated = true
  end

  def game_over?
    @life.dead? or @terminated
  end

  def message
    @life.report + " score: " + @score.to_s
  end
end
