class Message
  include LifeObserver

  def initialize(life)
    @messages = []
    life.register_observer self
  end

  def update_life_dead(damage)
    red = reduce(damage).join(" * ")
    add "#{damage} = #{red}."
  end

  def add(message)
    @messages << message
  end

  def to_s
    @messages.join(" ")
  end
end
