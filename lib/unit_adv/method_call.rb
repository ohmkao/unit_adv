module UnitAdv::MethodCall

  # MethodCall 尋找變數順序
  DCALL_PRIORITY = %w(method const hash)

  # MethodCall 預設 opts 的 name
  DCALL_HASH_DEFAULT = "opts"

  # 動態 method 介詞
  METHOD_NAME_WITH = "_by_"

  attr_accessor :opts

  def call_method(call_sym, *args, &block)
    call(nil, call_sym, *args, &block)
  end

  def call(perfix, call_sym, *args, &block)
    z = nil
    m = call_sym.kind_of?(Array) ? use_method_name(perfix, call_sym) : method_name(perfix, call_sym)
    self.class::DCALL_PRIORITY.each do |r|
      case r
      when 'method'
        z = send_method(m, *args, &block)
        return z if call_sym.kind_of?(Array)
      when 'const'
        z = const_get(call_sym)
      when 'hash'
        z = hash_fetch(call_sym)
      end
      return z if !z.nil?
    end
    nil
  end

  # Type1: method_name 組合 perfix
  def method_name(perfix, call_sym)
    return call_sym if perfix.blank?
    "#{perfix}#{self.class::METHOD_NAME_WITH}#{call_sym}"
  end

  # Type2: method_name 多選一
  def use_method_name(perfix, call_syms)
    call_syms.each_with_object("") { |m, x| return x if self.respond_to?(x = method_name(perfix, m)) }
  end

  # === === ===
  def send_method(current_method_name, *args, &block)
    m = current_method_name.to_sym
    return send(m, *args , &block) if self.respond_to?(m)
    nil
  end

  def const_get(const_name)
    c = const_name.to_s.upcase
    return self.class.const_get(c) if self.class.const_defined?(c)
    nil
  end

  def hash_fetch(key)
    hash_opts = self.send(DCALL_HASH_DEFAULT) || {}
    hash_opts.fetch(key.to_sym, nil) if self.respond_to?(DCALL_HASH_DEFAULT.to_sym)
  end

end
