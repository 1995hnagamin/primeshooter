class Life
  def initialize(current, order)
    @life = OrderFixed.new current, order
  end

  def to_s
    "[#{@life.to_s}%]"
  end

  def damage(d)
    if @life.value > d
      @life.value -= d
    else
      @last = d
      @life.value = 0
    end
  end

  def dead?
    @life.value <= 0
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

