class Enemy
  attr_accessor :value, :pos
  
  def initialize(num, position)
    @value = num
    @pos = position
  end

  def right_edge
    pos - keta(@value)
  end

  def does_reach?
    keta(@value) > pos
  end

  def divisible?(prime)
    @value % prime == 0
  end

  def damage(bullet)
    if divisible? bullet
      @value /= bullet
      bullet
    else
      0
    end
  end

  def grow(seed)
    @value *= seed
    0
  end
end


class Enemies
  include Enumerable
  include GunObserver
  @@processors = []

  def self.add_processor(processor)
    @@processors << processor
    @@processors.sort! { |a, b|
      b.priority <=> a.priority
    }
  end
  
  def initialize(max_size, width, max_amount)
    @max_size = max_size
    @width = width
    @max_amount = max_amount
    @enemies = []
    @observers = []
  end

  def [](idx)
    @enemies[idx]
  end

  def []=(k, v)
    @enemies[k] = v
  end

  def []=(k, k2, v)
    @enemies[k, k2] = v
  end

  def register_observer(observer)
    @observers << observer
  end

  def notify
    @observers.each do |o|
      o.update_enemy_status(self)
    end
  end

  def notify_destroyed(point)
    @observers.each do |o|
      o.update_enemy_destroyed(point)
    end
  end

  def init_stage
    p = rand (@width / 3).floor...(@width / 2).floor
    @enemies = [bear_enemy(p)]
    create_many_enemies
  end

  def empty?
    @enemies.empty?
  end

  def does_reach?
    !@enemies.empty? and @enemies[0].does_reach?
  end

  def move
    @enemies.each do |e|
      e.pos -= 1
    end
  end

  def right_edge
    if @enemies.length == 0
      0
    else
      @enemies.last.pos
    end
  end

  def create_enemy
    if @enemies.size < @max_amount
      @enemies << bear_enemy(rand(1..3))
    end
    notify
  end

  def create_many_enemies
    while @enemies.size < @max_amount
      create_enemy
    end
  end

  def bear_enemy(position = 1, value = nil)
    v = value || make_composite( rand(1..@max_size) )
    p = right_edge + keta(v) + position
    Enemy.new(v, p)
  end

  def destroy(enemy)
    @enemies.delete enemy
    notify
  end

  def step
    move
    if does_reach?
      damage = @enemies[0].value
      destroy @enemies[0]
      damage
    else
      0
    end
  end

  def process_bullet(bullet)
    point = 0
    @@processors.each do |p|
      if p.processes? bullet
        point = p.process_maybe(bullet, self)
        break
      end
    end
    notify
    notify_destroyed(point)
  end

  def each(&block)
    @enemies.each &block
  end

  def update_shoot(bullet)
    process_bullet bullet
  end
end

module EnemiesObserver
  def update_enemy_ingression(enemy)
  end

  def update_enemy_status(enemies)
  end

  def update_enemy_destroyed(point)
  end
end
