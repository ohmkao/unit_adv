class Run01

  attr_accessor :ef

  def initialize
    self.ef = ExampleInit::Family.new("apple", {
        property: 999999,
        land: "Taipei",
      })
  end

  # 取用 args 輸入的參數
  # arg_by_#{xxxx}
  #   or
  # args[:xxxx]
  def t01
    ef.arg_family_name
  end

  # 取用 opts 輸入的參數
  # opt_by_#{xxxx}
  #   or
  # opts[:xxxx]
  def t02
    ef.opt_land
  end

end
