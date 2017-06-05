class ExampleMethodCall::Banana < ExampleMethodCall::Fruit

  def initialize(*args)

  end

  def perform
    "perform for Banana"
  end

  def jam(neme, size)
    "#{neme} - #{size}"
  end

  def tin(count)
    count
  end

  class << self
    def package(unit)

    end
  end

end
