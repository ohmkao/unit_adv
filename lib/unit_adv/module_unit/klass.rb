module UnitAdv
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
          name_level = class_controller.send(:controller_path).singularize.underscore.split('/')
          name_level << class_controller.send(:action_name)
          name_level
        end

        # === === ===
        # str(String): Data String
        # gsub_data(Hash): { key: OldString, value: NewString }
        #
        def string_gsub(str, gsub_data = nil)
          return str if gsub_data.nil?
          h = [gsub_data].zip([]).to_h if gsub_data.kind_of?(String)
          h = gsub_data.zip([]).to_h if gsub_data.kind_of?(Array)
          h = gsub_data if gsub_data.kind_of?(Hash)
          str.gsub(Regexp.new("(#{h.keys.join('|')})"), h)
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
end
