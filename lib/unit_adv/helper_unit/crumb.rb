module UnitAdv
  module HelperUnit
    class Crumb
      include UnitAdv::ModuleUnit::Klass
      include UnitAdv::ModuleUnit::MethodCall
      include UnitAdv::ModuleUnit::Init

      attr_accessor :data

      SET_ARGS = %w(controller_obj setting_org)
      ARGS_IS_DATA_OBJECT = false

      #SET_AUTOLOAD = %w(setting_org)

      def perform
        data
      end

      def add(item)
        self.data ||= []
        self.data << item
      end

      # === === ===
      # 初始化 args
      def init_args_by_controller_obj(v)
        v
      end

      def init_args_by_setting_org(v)
        v
      end

      # === === ===
      # 自動載入 autoload
      #
      #def init_autoload_by_org_setting
      #end

    end
  end
end
