require './gen.rb'
require './Enemies.rb'
require './Gun.rb'
require './Life.rb'
require './BulletProcessor.rb'
require './Game.rb'
require './View.rb'
require './Controller.rb'

env = {gun_width: 3,
       life: 100,
       life_width: 3,
       max_enemy_size: 2,
       field_width: 25,
       max_enemy_amount: 10}

game = Game.new env
controller = MainController.new(game, env)

controller.execute

#STDOUT.puts $err
