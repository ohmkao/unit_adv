module UnitAdv
  class StepScript

    attr_accessor :this_current ,:step_data, :opts

    def initialize(_data)
      self.step_data = _data
    end

    # === === ===
    def current()
      self.this_current =
    end

    def current=()

    end

    def perv
      i = step_data.index(self.current)
      return step_data.at(i-1) if i > 0
      nil
    end

    def next
      nt = step_data.at(step_data.index(self.current)+1)
    end

    # === === ===
    def step_script
      [
        # "start",
        "picowork_authorization",
        "welcome",
        "organization",
        "email_pattern",
        "user",
        "validate_code",
        "end",
      ]
    end

    # === === ===
    def run_script
      [
        "system_admin",
        "default_app",
        "organization",
        "user",
      ]
    end

    def init_run_script(_script: [] nsp: nil)
      _script.each_with_object(steps ||= {}) do |n, h|
        h[n.to_sym] = ("init_startup/#{n}").classify.constantize.new.perform
      end
    end

  end
end
