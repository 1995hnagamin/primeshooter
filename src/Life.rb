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
      @last = d
      @life = 0
    end
    update
  end

  def dead?
    @life <= 0
  end

  def register_observer(observer)
    @observers << observer
  end

  def update
    @observers.each do |o|
      o.update_life
    end
  end
end
