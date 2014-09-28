class OrderFixed
  attr_reader :order, :value

  def initialize(num, order)
    @order = order
    @size = 10 ** order
    @value = num % @size
  end

  def value=(num)
    @value = num % @size
  end

  def to_s(c = "0")
    padding_size = @order - keta(value)
    padding = c * padding_size
    padding + value.to_s
  end

  def to_s_positive(c = "_")
    @value == 0 ? c * @order : to_s(c)
  end

  def repeat(char)
    char * @order
  end
end


def prime?(n)
  if n > 1
    max = (Math.sqrt n).floor
    (2..max).all? {|x| n % x != 0}
  elsif
    false
  end
end


def keta(n)
  n.to_s.length
end


def make_composite(n)
  primes = (1..100).select {|n| prime? n}
  primes.sample(n).inject(:*)
end

def reduce(n)
  a = []
  i = 2
  
  while n > 1
    if n % i == 0
      n /= i
      a << i
    else
      i += 1
    end
  end
  a
end

