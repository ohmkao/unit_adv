module UnitAdv
  module ModuleUnit
    module MethodCall

      # MethodCall 尋找變數順序
      DCALL_PRIORITY = %w(method const hash) unless const_defined?(:DCALL_PRIORITY)

      # MethodCall 預設 opts 的 name
      DCALL_HASH_DEFAULT = "opts" unless const_defined?(:DCALL_HASH_DEFAULT)

      # 動態 method 介詞
      METHOD_NAME_WITH = "_by_" unless const_defined?(:METHOD_NAME_WITH)

      attr_accessor :opts


      # === === === === === === === === ===
      # Detail:
      #   依序叫出 class 的 initialize + perform
      #
      # Use:
      #   class_names: [
      #       "cat",
      #       "dog",
      #       ["pig", "kg", 5],
      #       "sheep",
      #       "chicken#perform_ex",
      #     ]
      #   opts: {
      #     namespace: "animal"
      #   }
      #
      def call_perform(class_names = [], opts = {}, &block)
        opts[:namespace] ||= nil
        opts[:need_initialize] ||= true
        opts[:run_method] ||= "perform"

        class_names.each_with_object({}) do |na, h|
          if na.kind_of?(Array)
            args = na[1..-1]
            n = na[0]
          else
            n = na
          end
          nn ,run = n.split("#")

          obj_name = opts[:namespace].present? ? "#{opts[:namespace]}/#{nn}" : nn
          obj_c = obj_name.classify.constantize

          # 需要 initialize
          obj = opts[:need_initialize] ? obj_c.new : obj_c

          res = obj.send(*([(run || opts[:run_method]).to_sym] + (args || [])))
          h[nn.to_sym] = block_given? ? yield(nn, res, obj) : res
        end
      end

      # === === === === === === === === ===
      # Detail:
      #   呼叫 class 模式，在 class 內依序呼叫 method
      #
      # Use:
      #   class_obj: XxxYyyApi
      #   use_class: {
      #       init: [new_arg1, new_arg2], # this is Object new
      #       first_method: [first_method_arg1, first_method_arg2, first_method_arg3],
      #       second_method: second_method_arg1,
      #     }
      #
      def call_class(class_obj, use_args, &block)

        obj_c = class_obj.kind_of?(String) ? class_obj.constantize : class_obj
        obj = use_args[:init].present? ? obj_c.new(*use_args[:init]) : obj_c.new

        use_args.except(:init).each_with_object({}) do |(sym, args), m|
          res_tmp = obj.send(sym, *(args.kind_of?(Array) ? args : [args] ))
          m.merge!({ sym => (block_given? ? yield(sym, res_tmp) : res_tmp) })
        end.merge!({ obj: obj })

      end

      # === === === === === === === === ===
      # Detail:
      #   目標 self method 執行結束時，呼叫下一個 method 並帶入參數，輸出 report
      #
      # Use:
      #   call_goto(:first_method)
      #   is call >> step_first_method
      #   return:
      #     (step all status)
      #
      #   step_first_method()
      #     return: {
      #       report: "Data etc...",
      #       (1.) next_call: nil # is step to end or
      #       (2.) next_call: :second_method, arg1, arg2 #  next method sym and args
      #     }
      #
      def call_goto(*init_step, &block)
        res = {}
        tmp = {
          next_call: init_step
        }

        while tmp[:next_call].present?
          tmp = res[tmp[:next_call].first] = send("step_#{tmp[:next_call][0]}".to_sym, *tmp[:next_call][1..-1])
          break if tmp[:next_call].blank?
        end

        return yield(res) if block_given?
        res
      end

      # === === === === === === === === ===
      # Detail:
      #   依序尋找 method，有找到的話就 send（可配合 to_level 產生）
      #
      # Use:
      #   call_syms:
      #     %w(perform_by_aa_cc_xxx_ttt perform_by_aa_cc_xxx perform_by_aa_cc perform_by_aa default)
      #
      def call_methods(call_syms, *args, &block)
        call_syms.map(&:to_sym).each { |m| return send(m, *args, &block) if self.respond_to?(m) }
      end

      # === === === === === === === === ===
      # Detail:
      #   動態取得 call 的對象
      #
      # Use:
      #   call_sym_h:
      #     -> TYPE-1
      #     "xyz"
      #     -> TYPE-2
      #     {
      #       call_sym: "xyz"
      #       perfix: "aaa_by" # method 前綴詞
      #       dcall: %w(hash const method) # 修改動態資料的優先順序
      #     }
      #     -> TYPE-3
      #     ["xyz", "aaa_by", %w(method const hash), "_"]
      #
      #   Ans:(TYPE-2)
      #     first find method: aaa_by_xyz
      #     second find const: XYX
      #     third find hash for DCALL_HASH_DEFAULT: opts[:xyz]
      #
      def call_type(call_sym_h, *args, &block)
        _set = {
          dcall: DCALL_PRIORITY,
          perfix: "",
          split: "_",
        }

        case call_sym_h.class.name
        when /(Hash)/
          set = _set.merge call_sym_h
        when /(Array)/
          set = _set
          set[:call_sym] = call_sym_h[0] if call_sym_h[0].present?
          set[:perfix] = call_sym_h[1] if call_sym_h[1].present?
          set[:split] = call_sym_h[2] if call_sym_h[2].present?
          set[:dcall] = call_sym_h[3] if call_sym_h[3].present?
        when /(String)/
          set = _set
          set[:call_sym] = call_sym_h if call_sym_h.present?
        else
        end

        set[:dcall].each_with_object(nil) do |r, z|
          case r
          when 'method'
            m = set[:call_sym].remove(opts[:prefix]).split(opts[:split]).compact.unshift(set[:perfix]).join(opts[:split])
            z = send_method(m, *args, &block)
          when 'const'
            z = const_get(set[:call_sym])
          when 'hash'
            z = hash_fetch(set[:call_sym])
          end
          return z if !z.nil?
        end
        nil
      end


      # === === === === === === === === ===
      # Memo:
      #   old version
      #
      def call_method(call_sym, *args, &block)
        call(nil, call_sym, *args, &block)
      end

      # === === === === === === === === ===
      # Memo:
      #   old version
      #
      # Detail:
      #   動態取得 call 的對象
      #
      # Use:
      #   prefix_set:
      #     -> TYPE-1
      #     {
      #       perfix: "aaa" # method 前綴詞
      #       dcall: %w(hash const method) # 修改動態資料的優先順序
      #     }
      #     -> TYPE-2
      #     "bbb"
      #   call_sym:
      #     -> TYPE-1 多種型態尋找 (hash const method)
      #     "ccc_method"
      #     -> TYPE-2 階層式尋找（只限method）
      #     ["method_ccc_ddd_eee", "method_ccc_ddd", "method_ccc"]
      #
      def call(prefix_set, call_sym, *args, &block)
        set = call_prefix_set(prefix_set)
        z = nil
        m = call_sym.kind_of?(Array) ? multi_method_name(set[:perfix], call_sym) : method_name(set[:perfix], call_sym)
        set[:dcall].each do |r|
          case r
          when 'method'
            z = send_method(m, *args, &block)
            return z if call_sym.kind_of?(Array)
          when 'const'
            z = const_fetch(call_sym)
          when 'hash'
            z = hash_fetch(call_sym)
          end
          return z if !z.nil?
        end
        nil
      end

      # === === ===
      # Type1: method_name 組合 perfix
      def method_name(perfix, call_sym)
        return call_sym if perfix.blank?
        "#{perfix}#{self.class::METHOD_NAME_WITH}#{call_sym}"
      end

      # Type2: method_name 多選一
      def multi_method_name(perfix, call_syms)
        call_syms.each_with_object("") { |m, x| return x if self.respond_to?(x = method_name(perfix, m)) }
      end

      # === === ===
      # Get Dynamic Type Priority
      def call_prefix_set(set)

        return { perfix: set[:perfix], dcall: set[:dcall] } if prefix_set.kind_of?(Hash)

        {
          perfix: set,
          dcall: self.class::DCALL_PRIORITY,
        }
      end

      # === === ===
      # Dynamic Get Method
      def send_method(current_method_name, *args, &block)
        m = current_method_name.to_sym
        return send(m, *args , &block) if self.respond_to?(m)
        nil
      end

      # Dynamic Get Const
      def const_fetch(const_name)
        c = const_name.to_s.upcase
        return self.class.const_get(c) if self.class.const_defined?(c)
        nil
      end

      # Dynamic Get Hash
      def hash_fetch(key)
        hash_opts = self.send(DCALL_HASH_DEFAULT) || {}
        return hash_opts.fetch(key.to_sym, nil) if self.respond_to?(DCALL_HASH_DEFAULT.to_sym)
        nil
      end

    end
  end
end
