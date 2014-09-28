class Game
  def initialize(env)
    @gun = Gun.new(env[:gun_width])
    @life = Life.new(env[:life], env[:life_width])
    @enemies =Enemies.new(env[:max_enemy_size], env[:field_width],
                          env[:max_enemy_amount])
    @enemies.init_stage

    @score = 0
  end

  def render
    gun_status + @life.to_s + @enemies.to_s
  end

  def gun_status
    if game_over?
      @gun.broken
    elsif not @gun.available?
      @gun.repeat("#")
    else
      @gun.to_s
    end
  end

  def input(str)
    n = str.to_i
    @gun.insert_bullet n if 0 <= n and n < 10
  end
  
  def shoot
    b = @gun.shoot
    p = @enemies.process_bullet b
    @score += p
  end

  def step
    return nil if game_over?
    @gun.step
    d = @enemies.step
    @life.damage d
    @gun.disable if d > 0
    @enemies.create_enemy
  end

  def game_over?
    @life.dead?
  end

  def message
    @life.report + " score: " + @score.to_s
  end
end
