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

      # === === ===
      # Detail:
      #   呼叫 api 模式，以 api class，依序呼叫 method
      #
      # Use:
      #   use_api: {
      #       api_obj: XxxYyyApi,
      #       init: [new_arg1, new_arg2], # this is Object new
      #       first_method: [first_method_arg1, first_method_arg2, first_method_arg3],
      #       second_method: second_method_arg1,
      #     }
      def call_api(use_api, &block)

        return nil if use_api[:api_obj].blank?

        api_obj_c = use_api[:api_obj].kind_of?(String) ? use_api[:api_obj].constantize : use_api[:api_obj]
        api_obj = use_api[:init].present? ? api_obj_c.new(*use_api[:init]) : api_obj_c.new

        use_api.except(:api_obj, :init).each_with_object({}) do |(sym, args), m|
          res_tmp = api_obj.send(sym, *(args.kind_of?(Array) ? args : [args] ))
          m.merge!({ sym => (block_given? ? yield(sym, res_tmp) : res_tmp) })
        end.merge!({ api_obj: api_obj })

      end

      # === === ===
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

      # === === ===
      def call_method(call_sym, *args, &block)
        call(nil, call_sym, *args, &block)
      end

<<<<<<< HEAD
=======
      # === === ===
>>>>>>> develop
      def call(perfix_set, call_sym, *args, &block)

        if perfix_set.kind_of?(Hash)
          perfix = perfix_set[:perfix]
          dcall_priority = perfix_set[:dcall]
        else
          perfix = perfix_set
        end
        dcall_priority ||= self.class::DCALL_PRIORITY

        z = nil
        m = call_sym.kind_of?(Array) ? use_method_name(perfix, call_sym) : method_name(perfix, call_sym)
        dcall_priority.each do |r|
          case r
          when 'method'
            z = send_method(m, *args, &block)
            return z if call_sym.kind_of?(Array)
          when 'const'
            z = const_get(call_sym) if const_defined?(call_sym.upcase.to_sym)
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
      def use_method_name(perfix, call_syms)
        call_syms.each_with_object("") { |m, x| return x if self.respond_to?(x = method_name(perfix, m)) }
      end

      # === === ===
      # Dynamic Get Method
      def send_method(current_method_name, *args, &block)
        m = current_method_name.to_sym
        return send(m, *args , &block) if self.respond_to?(m)
        nil
      end

      # Dynamic Get Const
      def const_get(const_name)
        c = const_name.to_s.upcase
        return self.class.const_get(c) if self.class.const_defined?(c)
        nil
      end

      # Dynamic Get Hash
      def hash_fetch(key)
        hash_opts = self.send(DCALL_HASH_DEFAULT) || {}
        hash_opts.fetch(key.to_sym, nil) if self.respond_to?(DCALL_HASH_DEFAULT.to_sym)
      end

    end
  end
end
