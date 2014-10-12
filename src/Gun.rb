class Gun
  def initialize(width)
    @bullet = 0
    @standby = 0
    @mod = 10 ** width
    @broken = false
    @observers = []
  end

  def insert_bullet(n)
    if available?
      @bullet = (@bullet * 10 + n) % @mod
    end
    update_status
  end

  def shoot
    if available?
      b = @bullet
      @bullet = 0
      update_shoot(b) if b > 0
    end
    update_status
  end

  def maximum
    @mod - 1
  end
  
  def bullet
    @bullet
  end

  def disable(turns = 2)
    @standby = turns
    update_status
  end

  def available?
    @standby == 0 and !@broken
  end

  def inavailable?
    !available? and !@broken
  end

  def broken?
    @broken
  end

  def break
    @broken = true
  end

  def step
    if not available?
      @standby -= 1
      if available?
        @bullet = 0
        update_status
      end
    end
  end

  def register_observer(observer)
    @observers << observer
  end

  def update_status
    @observers.each do |o|
      o.update_status
    end
  end

  def update_shoot(bullet)
    @observers.each do |o|
      o.update_shoot(bullet)
    end
  end
end

module GunObserver

  def update_status
  end

  def update_shoot(bullet)
  end
end
