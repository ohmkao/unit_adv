module UnitAdv
  module HelperUnit
    class ErrorCollect

      # MethodCall 尋找變數順序
      # DCALL_PRIORITY = %w(method const hash) unless const_defined?(:DCALL_PRIORITY)

      attr_accessor :errors

      def initialize
        self.errors = []
      end

      def add(data)
        self.errors << data
      end

      def show
        
      end

      def last
        self.errors.last
      end

    end
  end
end
