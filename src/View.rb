class GunView
  def initialize(controller, gun)
    @controller = controller
    @gun = gun
    @gun.register_observer(self)
    @width = keta(@gun.maximum)
  end

  def to_s
    @view
  end

  def create_view
    @view = "_" * @width
  end

  def update_bullet
    orderfixed = OrderFixed.new(@gun.bullet, @width)
    @view = orderfixed.to_s("_")
  end

  def update_status
    if @gun.inavailable?
      @view = "#" * @width
    elsif @gun.broken?
      @view = "*" * @width
    elsif @gun.available?
      update_bullet
    end
  end

  def insert_bullet(num)
    @controller.insert_bullet(num)
  end

  def shoot_bullet
    @controller.shoot
  end
end


class LifeView
  def initialize(life)
    @life = life
    @life.register_observer(self)
    @width = keta(@life.maximum)
  end

  def to_s
    @view
  end

  def concatnate(life)
    orderfixed = OrderFixed.new(life.to_s, @width)
    "[" + orderfixed.to_s + "%]"
  end

  def create_view
    @view = concatnate(@life.life)
  end

  def update_life
    create_view
  end
end


class EnemiesView
  def initialize(enemies, width)
    @enemies = enemies
    @width = width
    @enemies.register_observer(self)
  end

  def to_s
    @view
  end

  def create_view
    update_view
  end

  def update_enemies
    ret = ""
    @enemies.each do |e|
      expr = e.value.to_s
      padding_size = e.pos - expr.length - ret.length
      padding = "_" * (padding_size > 0 ? padding_size : 0)
      ret += padding + expr
    end

    if ret.length < @width
      ret + "_" * (@width - ret.length)
    elsif ret.length > @width
      ret[0, @width]
    else
      ret
    end
  end
end

