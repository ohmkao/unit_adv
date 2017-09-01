
module UnitAdv
  module ModuleUnit
    module TransformTo

      extend ActiveSupport::Concern

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        # === === ===
        def to_bool(data, opts = nil)
          case data.class.name
          when /(Hash|Array)/
            return false if data.blank?
            return true
          when /(String)/
            str = data.downcase
            return false if ['fail', 'failure', 'false', '0', 'no', 'off', 'f', ''].include? str
            return true if ['success', 'true', '1', 'yes', 'on', 't'].include? str
            return nil
          when /(Integer|Fixnum)/
            return false if data.zero?
            return true
          when /(FalseClass|TrueClass)/
            return data
          else
            return nil
          end
        end

        def to_arr(data, opts = nil)
          case data.class.name
          when /Array/
            return data
          when /Hash/
            return data.to_a
          when /(Integer|Fixnum|FalseClass|TrueClass)/
            return [data] if data.zero?
            return data
          else
            return data
          end
        end

        # === === === === === === === === ===
        # Detail:
        #   建立多重 method name
        #
        # Use:
        #   data:
        #     -> TYPE-1
        #     %w(aa cc xxx ttt)
        #     -> TYPE-2
        #     "perform_by_aa_cc_xxx_ttt"
        #   opts:
        #     prefix: "perform_by" # method 前綴詞
        #     split: "_" # 分割符號
        #     arr_default: "defalut" # 放在最後一個(不加入prefix詞)
        #
        # Example:
        #   -> to_level "perform_by_aa_cc_xxx_ttt", { prefix: "perform_by", arr_default: "default" }
        #   return:
        #     ["perform_by_aa_cc_xxx_ttt", "perform_by_aa_cc_xxx", "perform_by_aa_cc", "perform_by_aa", "default"]
        #
        def to_level(data, opts = {})
          data = data.remove(opts[:prefix] || "").split(opts[:split] || '_').reject { |c| c.empty? } if data.kind_of?(String)

          tmp = []
          tmp += opts[:arr_default] if opts[:arr_default].kind_of?(Array)
          tmp << opts[:arr_default] if opts[:arr_default].kind_of?(String)
          prefix = opts[:prefix].present? ? [opts[:prefix]] : []
          for i in 1..data.count
            tmp << (prefix + data[0..(i-1)]).join('_')
          end
          tmp.reverse
        end

      end
    end
  end
end
