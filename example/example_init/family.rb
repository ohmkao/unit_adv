class ExampleInit::Family < ExampleInit::Base

  # initialize by args 結構
  SET_ARGS = %w(family_name)

  # 需要 initialize 後去執行的 method
  SET_AUTOLOAD = %w(build_home register_member)

  # === === ===
  # 初始化 args
  def init_args_by_family_name(v)
    return "#{v}_family" if v.kind_of?(String)
    v
  end

  # === === ===
  # 自動載入 autoload
  #
  def init_autoload_by_build_home
    self.data ||= {}
    self.data[:home] = {
      name: arg_by_family_name,
    }
  end

  def init_autoload_by_register_member
    self.data ||= {}
    self.data[:member] = nil
  end

end
