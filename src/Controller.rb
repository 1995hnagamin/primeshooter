class GunController
  def initialize(gun)
    @gun = gun
    @view = GunView.new(this, gun)
    @view.create_view
  end

  def insert_bullet(num)
    @gun.insert_bullet(num)
  end

  def shoot
    @gun.shoot
  end
end

