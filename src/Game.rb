class Game
  attr_reader :gun, :life, :enemies, :score
  def initialize(env)
    @gun = Gun.new(env[:gun_width])
    @life = Life.new(env[:life], env[:life_width])
    @enemies =Enemies.new(env[:max_enemy_size], env[:field_width],
                          env[:max_enemy_amount])
    @enemies.init_stage

    @gun.register_observer @enemies

    @score = Score.new @enemies

    @message = Message.new @life
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
    @message.add("Score: #{@score.value}")
    @terminated = true
  end

  def game_over?
    @life.dead? or @terminated
  end

  def message
    @message.to_s
  end
end
