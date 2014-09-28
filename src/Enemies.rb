class Enemy
  attr_accessor :value, :pos
  
  def initialize(num, position)
    @value = num
    @pos = position
  end

  def to_s
    if does_reach?
      (@value % (10 ** pos)).to_s
    else
      @value.to_s
    end
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
  end

  def to_s
    ret = ""
    @enemies.each do |e|
      expr = e.to_s
      padding_size = e.pos - expr.length - ret.length
      padding = "_" * (padding_size > 0 ? padding_size : 0)
      ret += padding + expr
    end

    if ret.length < @width
      ret + "_" * (@width - ret.length)
    elsif ret.length > @width
      ret[0,@width]
    else
      ret
    end
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
    @@processors.each do |p|
      if p.processes? bullet
        point = p.process_maybe(bullet, self)
        return point
      end
    end
  end

  def each(&block)
    @enemies.each &block
  end
end
