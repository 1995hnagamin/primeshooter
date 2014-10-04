class BulletProcessor
  def initialize(priority)
    @priority = priority
  end

  def priority
    @priority
  end

  def processes?(bullet)
    raise NotImplemenedError.new(
      "virtual method: #{self.class.name}.#{current_method_name}")
  end

  def process(bullet, enemies)
    raise NotImplemenedError.new(
      "virtual method: #{self.class.name}.#{current_method_name}")
  end

  def process_maybe(bullet, enemies)
    if enemies.empty?
      0
    else
      process bullet, enemies
    end
  end
end


class DefaultProcessor < BulletProcessor
  def processes?(bullet)
    true
  end

  def process(bullet, enemies)
    enemies[0].value *= bullet if bullet != 0
    0
  end
end

Enemies.add_processor DefaultProcessor.new(0)


class PrimeProcessor < BulletProcessor
  def processes?(bullet)
    $err << bullet if not bullet
    prime? bullet
  end

  def process(prime, enemies)
    used = false

    enemies.each do |e|
      if e.divisible? prime
        e.value /= prime
        used = true
        enemies.destroy e if e.value == 1
        break
      end
    end

    if not used
      newp = enemies[0].right_edge - 1
      enemies[0, 0] = Enemy.new(prime, newp)
    end
    
    used ? prime : -prime * prime
  end
end

Enemies.add_processor PrimeProcessor.new(11)

