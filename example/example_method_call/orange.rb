class ExampleMethodCall::Orange < ExampleMethodCall::Fruit

  def perform
    "perform for Orange"
  end

  def perform_ex(name, opt = {})
    "perform for Super Orange #{name}, #{opt}"
  end

  def show_by_aa_cc_xxx
    "perform_by_aa_cc_xxx"
  end

  def show_by_aa_cc
    "perform_by_aa_cc"
  end

  def show_by_aa
    "perform_by_aa"
  end

  def default
    "default"
  end


end
