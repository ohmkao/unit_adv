module ModuleUnit
  module Klass

    extend ActiveSupport::Concern

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def self_service(locale_class)
        string_sub(locale_class, ["#{Rails.root}/", "/#{self_namespace.underscore}.rb"])
      end

      def self_namespace
        self.name.deconstantize
      end

      def self_class
        self.name.demodulize
      end

      def self_path
        self.name.underscore.split("/").first
      end

      def self_controller_namelist(class_controller)
        name_level = self.send(:controller_path).singularize.underscore.split('/')
        name_level << self.send(:action_name)
        name_level
      end

      # === === ===
      def string_gsub(str, sub_data = nil)
        return str if sub_data.nil?
        h = [sub_data].zip([]).to_h if sub_data.kind_of?(String)
        h = sub_data.zip([]).to_h if sub_data.kind_of?(Array)
        h = sub_data if sub_data.kind_of?(Hash)
        str.gsub(/[#{h.keys.join('|')}]/, h)
      end

      def to_level(arr, opts = {})
        tmp = []
        tmp += opts[:arr_first] if opts[:arr_first].kind_of?(Array)
        tmp << opts[:arr_first] if opts[:arr_first].kind_of?(String)
        for i in 1..arr.count
          tmp << arr[0..(i-1)].join('_')
        end
        tmp.reverse
      end
    end

    def run_command(commands)
      commands.each do |c|
        cmd = c.kind_of?(Array) ? c.join(" && ") : c
        echo_log.cmd cmd
        res = %x( #{cmd} )
        echo_log.res res
      end
    end

  end
end
