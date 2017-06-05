class ExampleMethodCall::Apple < ExampleMethodCall::Fruit

  def perform(name, size)
    "perform for Apple #{name} is #{size}"
  end


  def step_to_taiwan(size, count)
    return [:to_hongkong, size, count] if size == "L" && count >= 100
    return [:to_singapore, count] if count <= 99
    return [:to_japan, size] if size == "S"
    :to_usa
  end

  def step_to_hongkong(size, count)
    [:to_japan, size]
  end

  def step_to_singapore(count)
    :to_usa
  end

  def step_to_japan(size)
    return nil if size == "LL"
    [:to_singapore, 10]
  end

  def step_to_usa
    nil
  end

end
