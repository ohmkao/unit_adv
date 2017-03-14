module UnitAdv
  module HelperUnit
    class HttpAuth
      include UnitAdv::ModuleUnit::Klass
      include UnitAdv::ModuleUnit::MethodCall
      include UnitAdv::ModuleUnit::Init

      SET_ARGS = %w(controller_obj)
      ARGS_IS_DATA_OBJECT = false
      SET_USE_ENV = "staging"

      # === === ===
      def perform
        return !http_auth if check_ip && check_env && check_method
      end

      def http_auth
        arg_controller_obj.authenticate_or_request_with_http_basic do |username, password|
          username == opt_auth_key_hash[:username] && password == opt_auth_key_hash[:password]
        end
      end

      def to_render_401
        {
          text: "401 Unauthorized",
          status: 401,
          layout: false
        }
      end

      # === === ===
      def check_method
        action = self.class.self_controller_namelist(arg_controller_obj).join("_")
        (opt_skip_method_list || []).each { |m| return false if ( action =~ m ).present? }
        true
      end

      def check_ip
        (opt_ip_whitelist & [self_remote_ip]).blank?
      end

      def check_env
        use_env = call({ dcall: %w(method hash const) }, "set_use_env")
        ((use_env.kind_of?(String) ? [use_env] : use_env) & [self_env]).present?
      end

      # === === ===
      def self_env
        return opt_env = Rails.env if opt_env?.nil?
        opt_env
      end

      def self_remote_ip
        return opt_remote_ip = arg_controller_obj.request.remote_ip if opt_remote_ip?.nil?
        opt_remote_ip
      end
    end
  end
end
