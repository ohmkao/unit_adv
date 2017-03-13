module UnitAdv
  module HelperUnit
    class History
      include UnitAdv::ModuleUnit::Klass
      include UnitAdv::ModuleUnit::MethodCall
      include UnitAdv::ModuleUnit::Init

      SET_ARGS = %w(trigger)
      ARGS_IS_DATA_OBJECT = false

      HISTORY_MODEL = "History"
      attr_accessor :data_obj, :data_before, :data_after, :mode, :obj

      # === === ===
      # 初始化 args
      def init_args_by_trigger(v)
        return v if v[:controller_obj].blank?
        {
          action_name: v[:controller_obj].controller_name.singularize.humanize,
          action_type: v[:controller_obj].action_name,
          user: v[:controller_obj].current_user.id.to_s,
        }
      end

      # === === ===
      def model(init_obj)
        self.mode = "model"
        self.obj = init_obj
        self.data_obj = {
          class_name: obj.class.name,
          class_id: obj.try(:id),
        }
        before(obj)
        self
      end

      def before(data)
        case mode
        when "model"
          self.data_before = data.attributes.deep_symbolize_keys rescue nil
        else
          self.data_before = data
        end
        self
      end

      # === === ===
      def save(data)
        if data === false
          after(false)
        elsif data.present?
          after(data)
        elsif mode == "model"
          after(obj)
        end

        tmp_data = { data: hash_diff.to_json.to_s }
        tmp_data.merge! arg_trigger
        tmp_data.merge! data_obj

        history_obj_create(tmp_data) if tmp_data.present?
      end

      def after(data)
        if data === false
          return self.data_after = nil
        end
        case mode
        when "model"
          self.data_after = data.attributes.deep_symbolize_keys rescue nil
        else
          self.data_after = data
        end
      end

      # === === ===
      def diff(a_before, a_after)
        self.data_before = a_before
        self.data_after = a_after
        save
      end

      # === === ===
      #
      def history_obj_create(data_atts)
        history_obj.create history_org_attributes(data_atts)
      end

      # History Object Attributes
      def history_org_attributes(data_atts)
        %w(data class_name class_id action_name action_type user).map(&:to_sym).each_with_object({}) do |att, h|
          h[att] = data_atts[att]
        end
      end

      # History Object
      def history_obj
        call(nil, "history_model").constantize
      end

      # === === ===
      def hash_diff(init_before = nil, init_after = nil)
        HashDiff.diff((init_before || data_before || {}), (init_after || data_after || {}))
      end
    end
  end
end
