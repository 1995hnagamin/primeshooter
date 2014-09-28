require './gen.rb'
require './Enemies.rb'
require './Gun.rb'
require './Life.rb'
require './BulletProcessor.rb'
require './Game.rb'

env = {gun_width: 3,
       life: 100,
       life_width: 3,
       max_enemy_size: 2,
       field_width: 25,
       max_enemy_amount: 10}

g = Game.new env
print "press enter to start"


while input = gets and not g.game_over?
  case input
  when /q|Q/
    break
  when /z|Z/
    g.shoot
  when /\d/
    g.input input
  else
  end
  g.step
  print g.render, " >"
end

puts g.message
