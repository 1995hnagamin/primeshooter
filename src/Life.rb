class Life
  attr_reader :maximum, :life

  def initialize(maximum, width)
    @life = maximum
    @maximum = maximum
    @width = width
    @observers = []
  end

  def damage(d)
    if @life > d
      @life -= d
    else
      @life = 0
      notify_dead d
    end
    notify
  end

  def dead?
    @life <= 0
  end

  def register_observer(observer)
    @observers << observer
  end

  def notify
    @observers.each do |o|
      o.update_life
    end
  end

  def notify_dead(damage)
    @observers.each do |o|
      o.update_life_dead(damage)
    end
  end
end

module LifeObserver
  def update_life
  end

  def update_life_dead(damage)
  end
end
