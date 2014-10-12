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
  end

  def dead?
    @life <= 0
  end

  def report
    return "" unless @last

    ps = reduce @last
    if ps.size > 1
      "#{@last} = " + ps.join("*") + "."
    else
      "#{ps[0]} is prime."
    end
  end

  def register_observer(observer)
    @observers << observer
  end

  def update_observers
    @observers.each do |o|
      o.update_life
    end
  end
end

