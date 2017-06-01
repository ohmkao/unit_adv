module UnitAdv
  class StepScript

    attr_accessor :this_current ,:step_data, :opts

    def initialize(_data = step_script)
      self.step_data = _data || []
      step_next
    end

    # === === ===
    def current(_set = nil)
      if step_data.include? _set
        self.this_current = _set
      else
        this_current
      end
    end

    def current=(_set)
      current(_set)
    end

    def perv
      return nil if self.current.blank?
      i = step_data.index(self.current)
      return step_data.at(i-1) if i > 0
      nil
    end

    def next
      return nil if self.current.blank?
      nt = step_data.at(step_data.index(self.current)+1)
    end

    def step_next
      self.this_current = self.next || step_data.at(0)
    end

    # === === ===
    def step_script
      [
        "start",
        "end",
      ]
    end

  end

end
