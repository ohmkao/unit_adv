class ExampleMethodCall::Cherry < ExampleMethodCall::Fruit

  def initialize(*args)

  end

  def size_with_xxl
    100
  end

  def size_with_xl
    ["AAA", "BBB"]
  end

  def size_with_l
    {
      x: "A",
      y: "B",
      z: "C",
    }
  end

  def size_with_m
    :zzzz
  end

  def size_with_s
    :retun_pass
  end

  def size_with_xs
    "hihi"
  end


end
