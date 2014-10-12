class GunView
  include GunObserver

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

  def update_status
    if @gun.inavailable?
      @view = "#" * @width
    elsif @gun.broken?
      @view = "*" * @width
    elsif @gun.available?
      @view = fix_width @gun.bullet, @width, "_"
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
  include LifeObserver

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
  include EnemiesObserver

  def initialize(enemies, width)
    @enemies = enemies
    @width = width
    @enemies.register_observer(self)
  end

  def to_s
    @view
  end

  def create_view
    update_enemy_status(@enemies)
  end

  def update_enemy_status(enemies)
    ret = ""
    enemies.each do |e|
      expr = e.value.to_s
      padding_size = e.pos - expr.length - ret.length
      padding = "_" * (padding_size > 0 ? padding_size : 0)
      ret += padding + expr
    end

    if ret.length < @width
      @view = ret + "_" * (@width - ret.length)
    elsif ret.length > @width
      @view = ret[0, @width]
    else
      @view = ret
    end

    @view
  end
end


require 'curses'

class MainView
  include Curses

  def initialize(controller, game, env)
    @controller = controller
    @game = game
    @env = env
  end

  def create_view
    gun_controller = GunController.new(@game.gun)
    @gun_view = GunView.new(gun_controller, @game.gun)
    @life_view = LifeView.new(@game.life)
    @enemies_view = EnemiesView.new(@game.enemies, @env[:field_width])
    init_screen
    cbreak
    noecho
    curs_set 0
    Curses::timeout = 10

    @gun_view.create_view
    @life_view.create_view
    @enemies_view.create_view

    render to_s
  end

  def render(string)
    setpos lines - 1, 0
    addstr string
    refresh
  end

  def to_s
    @gun_view.to_s + @life_view.to_s + @enemies_view.to_s
  end

  def input(char)
    case char
    when /z|Z/
      @gun_view.shoot_bullet
    when /\d/
      @gun_view.insert_bullet char.to_i
    when /q|Q/
      close
    when /p|P/
      @controller.step
    end
  end

  def close
    @controller.close

    clear
    Curses::timeout = -1
    close_screen
  end

  def execute
    t = Timer.new 100

    begin
      create_view
      until @game.game_over?
        char = getch
        input char
        t.cyclically do
          @controller.step
        end
        render to_s
      end
    ensure
      close
      puts @game.message
    end
  end
end
