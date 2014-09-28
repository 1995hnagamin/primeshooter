require './gen.rb'
require './Enemies.rb'
require './Gun.rb'
require './Life.rb'
require './BulletProcessor.rb'
require './Game.rb'
require 'curses'

class Timer
  def initialize(cycle)
    @cycle = cycle
    @current = cycle
  end

  def cyclically(&p)
    if @current == 0
      @current = @cycle
      p.call()
    else
      @current -= 1
    end
  end
end


env = {gun_width: 3,
       life: 100,
       life_width: 3,
       max_enemy_size: 2,
       field_width: 25,
       max_enemy_amount: 10}

g = Game.new env

include Curses
init_screen
cbreak
noecho
curs_set 0

def putcs(string)  
  setpos lines - 1, 0
  addstr string
  refresh
end

begin
  step = Timer.new(100)
  Curses::timeout = 10

  while true
    input = getch
    case input
    when /q|Q/
      break
    when /z|Z/
      g.shoot
    when /\d+/
      g.input input
    else
    end
    
    step.cyclically do
      g.step
    end

    putcs g.render
  end
ensure
  clear
  putcs g.message
  Curses::timeout = -1
  getch
  close_screen
end
