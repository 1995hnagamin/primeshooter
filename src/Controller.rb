class GunController
  def initialize(gun)
    @gun = gun
    @view = GunView.new(self, gun)
    @view.create_view
  end

  def insert_bullet(num)
    @gun.insert_bullet(num)
  end

  def shoot
    @gun.shoot
  end
end

class MainController
  def initialize(game, env)
    @game = game
    @gun = game.gun
    @enemies = game.enemies
    @life = game.life
    @view = MainView.new(self, game, env)
  end

  def execute
    @view.execute
  end

  def close
    @game.terminate
  end

  def step
    @game.step
  end
end
