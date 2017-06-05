class Run02

  # attr_accessor :obj

  def initialize
    # self.obj = ExampleMethodCall::Apple.new "apple"
  end

  # === === === === === === === === ===
  # call_perform
  def t11
    call_perform(
        [
          ["apple", "APPLE", "XL"],
          "banana",
          ["orange#perform_ex", "ORANGE", { cc: 12345 }]
        ],
        {
           namespace: "example_method_call"
        }
      ) do |class_name, response, class_boj|
        response
      end
  end

  # === === === === === === === === ===
  # call_api
  def t21
    call_api(ExampleMethodCall::Banana,
        {
          init: ["excellent", 10000],
          jam: ["BigBanana", 24],
          tin: 6,
        }
      )
  end

  def t22
    call_api(ExampleMethodCall::Banana,
        {
          package: 12,
        }
      )
  end

  # === === === === === === === === ===
  # call_goto
  def t31
    obj = ExampleMethodCall::Apple.new "fuji apple"
    obj.call_goto(:to_taiwan, "L", 10000)
    # to_taiwan -> to_hongkong -> to_japan -> to_singapore -> to_usa
  end


  def t32
    obj = ExampleMethodCall::Apple.new "fuji apple"
    obj.call_goto(:to_taiwan, "L", 10)
    # to_taiwan -> to_usa
  end


  def t33
    obj = ExampleMethodCall::Apple.new "fuji apple"
    obj.call_goto(:to_taiwan, "S", 10000)
    # to_taiwan -> to_japan -> to_singapore -> to_usa
  end

  def t34
    obj = ExampleMethodCall::Apple.new "fuji apple"
    obj.call_goto(:to_japan, "LL")
    # to_japan
  end

  # === === === === === === === === ===
  # call_methods
  def t41
    ExampleMethodCall::Orange.new.call_methods(
      ExampleMethodCall::Orange::to_level(%w(aa cc xxx ttt)),
      "Abc", "xyz"
    )
  end

  def t42
    ExampleMethodCall::Orange.new.call_methods(
      ExampleMethodCall::Orange::to_level(
        "perform_by_aa_cc_xxx_ttt",
        {
          prefix: "show_by",
          arr_default: "default"
        }
      ),
      "Abc", "xyz"
    )
  end

  # === === === === === === === === ===
  # call_type
  def t51
    ExampleMethodCall::Watermelon.new.call_type "yyy"
    # >>> "YYY-YYY"
  end

  def t52
    ExampleMethodCall::Watermelon.new.call_type(
      {
        call_sym: "yyy"
        perfix: "type_by" # method 前綴詞
        dcall: %w(const hash method) # 修改動態資料的優先順序
      }
    )
    # >>> "yyy"
  end

  def t53
    ExampleMethodCall::Watermelon.new.call_type "yyy", "type_by", %w(method const hash), "_"
    # >>> "YYY"
  end

  def t54
    ExampleMethodCall::Watermelon.new.call_type "yyy", "type_by", %w(hash, const, method), "_"
    # >>> "YyY"
  end

end
