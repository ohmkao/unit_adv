class EchoLog

  attr_accessor :log_file

  def initialize(log)
    self.log_file = Rails.root.join(log).to_s
    self.log_file ||= " /dev/null 2>&1 "
  end

  # === === ===
  def cmd(str)
    push_echo_log str, "cmd", "green"
  end

  def res(str)
    push_echo_log str, "res", "light_cyan" if str.present?
  end

  def process(str)
    push_echo_log str, "process", "red"
  end

  def start(str)
    push_echo_log str, "start", "blue"
  end

  def tap(run, str)
    push_echo_log str, run,"light_magenta"
  end

  def finish(str)
    push_echo_log str, nil, "yellow"
  end

  # === === ===
  def push_echo_log(str, str_type = nil, str_type_color = nil)
    str_arr = []
    str_arr << DateTime.now.iso8601.colorize(:white)
    str_arr << str_type.colorize(str_type_color.to_sym) if str_type.present?
    str_arr << ((str_type.blank? && str_type_color.present?) ? str.colorize(str_type_color.to_sym) : str)
    s = str_arr.join(' - ')
    system("echo '#{s}' >> #{log_file}")
  end

end
