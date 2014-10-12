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
  def initialize(game)
    @game = game
    @gun = game.gun
    @enemies = game.enemies
    @life = game.life
    @view = MainController.new(self, game)
  end

  def shoot
  end

  def close
  end
end
