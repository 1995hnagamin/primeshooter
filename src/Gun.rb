class Gun
  def initialize(width)
    @bullet = OrderFixed.new(0, width)
    @standby = 0
  end

  def to_s
    @bullet.to_s_positive("_")
  end

  def insert_bullet(n)
    if available?
      @bullet.value = @bullet.value * 10 + n
    end
  end

  def shoot
    if available?
      b = @bullet.value
      @bullet.value = 0
      b
    end
  end

  def broken
    repeat("*")
  end

  def repeat(c)
    @bullet.repeat(c)
  end

  def disable(turns = 2)
    @standby = turns
  end

  def available?
    @standby == 0
  end

  def step
    if not available?
      @standby -= 1
      @bullet.value = 0 if available?
    end
  end
end
