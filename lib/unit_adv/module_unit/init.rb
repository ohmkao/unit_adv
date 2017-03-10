module UnitAdv
  module ModuleUnit
    module Init

      # initialize by args 結構
      SET_ARGS = [] unless const_defined?(:SET_ARGS)

      # 魔術變數 args[:xxx] >>> arg_xxx
      MAGIC_VARS = { "arg" => "args", "opt" => "opts" } unless const_defined?(:MAGIC_VARS)

      # init_args 如果回傳 nil 自動 pass
      ARGS_IS_NIL_PASS = true unless const_defined?(:ARGS_IS_NIL_PASS)

      # assign args 是否要使用 RecursiveOpenStruct 結構
      ARGS_IS_DATA_OBJECT = true unless const_defined?(:ARGS_IS_DATA_OBJECT)

      attr_accessor :args, :opts, :errors, :echo_log

      def initialize(*args)
        self.errors = []
        init_opts(args) # 初始化 opts (如果有的話)
        init_args(args) # 初始化 args
        init_autoload # 自動載入
      end

      def to_obj(data)
        RecursiveOpenStruct.new(data, recurse_over_arrays: true)
      end

      # === === ===
      # 初始化 參數 args
      def init_args(args)
        tmp_data = self.class::SET_ARGS.zip(args.slice(0..(self.class::SET_ARGS.size - 1))).each_with_object([]) { |(k, v), a| a << init_args_by(__method__, k, v) }.to_h

        self.args = (self.class::ARGS_IS_DATA_OBJECT ? to_obj(tmp_data) : tmp_data )
      end

      # 自動呼叫對應的 method，並作回傳後的處理
      def init_args_by(method_call, k ,v)
        res = call(method_call, k, v)
        case res.class.name
        when "FalseClass" # return false : 作為錯誤，拋出 Exception
          raise Exception.new("Error: #{method_call}_by_#{k} (#{v})")
        when "NilClass" # return nil : 根據 ARGS_IS_NIL_PASS 視為 true or false
          return [k, v] if self.class::ARGS_IS_NIL_PASS
          raise Exception.new("Error: #{method_call}_by_#{k} (#{v})")
        when "TrueClass" # return true : 視為 正確，並自動將 v 一併回傳
          return [k, v]
        else # return other : 非以上三種，都是為 true 並將 return data 作為資料回傳
          return [k, res]
        end
      end

      # === === ===
      # 初始化 參數 opts
      def init_opts(args)
        self.opts = {}
        self.opts.merge!(args.last) if args.last.kind_of?(Hash) && (args.size.to_i > self.class::SET_ARGS.size.to_i)
      end

      # === === ===
      # 自動載入
      def init_autoload
        call_method("set_autoload").each { |c| call(__method__, c) } if self.class.const_defined?(:SET_AUTOLOAD)
      end

      # === === ===
      # 魔術變數
      #     args[:xxx] >>> arg_xxx
      #     arg_xxx = "asdf"
      #     arg_xxx? >> true, false, nil

      def method_missing(method_sym, *args, &block)
        type_var, key_var, mode_var = method_missing_slice(method_sym.to_s)
        if type_var.present? && key_var.present? && (self.class::MAGIC_VARS.keys & [type_var]).present?
          tmp = self.send(MAGIC_VARS[type_var].to_sym)[key_var.to_sym]
          case mode_var
          when "?"
            return nil if (tmp.nil?)
            return false if (tmp === false)
            return true
          when "="
            return self.send(MAGIC_VARS[type_var].to_sym)[key_var.to_sym] = args.first
          else
            return tmp
          end
        end
        Exception.new("UnitAdv::Error: #{method_sym}")
      end

      def method_missing_slice(method_name)
        type_var = nil
        key_var = nil
        mode_var = nil
        self.class::MAGIC_VARS.keys.each do |m|
          if method_name.slice(0..m.size) == "#{m}_"
            type_var = m
            mode_var = method_name.last if (["=", "?"] & [method_name.last]).present?
            key_var = ( mode_var ? method_name.slice((m.size + 1)..-2) : method_name.slice((m.size + 1)..-1) )
          end
        end
        [type_var, key_var, mode_var]
      end

    end
  end
end
