class Carer
  attr_reader :config, :params, :ping_time, :packet_loss_percent, :memory, :logs, :mailer, :controls, :output
  def initialize(params={})
    load_config
    initialize_controls
    @params = params
    @logs = []
    initialize_mailer
  end

  def initialize_controls
    @controls = []
    config.controls_array.each do |control_type|
      klass = Object.const_get("Control::#{control_type[0].capitalize}")
      if klass == Control::Custom
        controls.concat control_type[1].map{|target, params| klass.new(target: target, target_value: params["target_value"], value: params["value"], comparator: params["comparator"])}
      else
        controls.concat control_type[1].map{|target, params| klass.new(target: target, value: params.values.first)}
      end
    end
  end

  def checks
    output = []
    controls.each do |c|
      output << "Type: #{c.type} | target: #{c.target} | control_value: #{c.value} | current_value: #{c.target_value} | status: #{c.errors.empty? ? 'OK!' : 'WARNING!'} | time: #{Time.now}"
    end
    output
  end

  def perform_controls!
    controls.each do |c|
      c.check!
      report (c.errors.join("\n")) unless c.passed?
    end
  end

  def report(message)
    @logs << "#{Time.now} WARNING! #{message}"
    mailer.notify "#{Time.now} WARNING! #{message}"
  end

  def initialize_mailer
    @mailer = Mailer.new(config.email_interval, ["kocasp@gmail.com"])
  end

  def load_config
    @config = Config.new("config/config.yml")
  end

  def system_windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    # File.exists?('C:\\')
  end

  def self.header
    "      ___\n     /\\  \\\n    /::\\  \\\n   /:/\\:\\  \\\n  /:/  \\:\\  \\\n /:/__/ \\:\\__\\\n \\:\\  \\  \\/__/\n  \\:\\  \\\n   \\:\\  \\\n    \\:\\__\\\n     \\/__/\n------\nCARER  (ctrl+C to quit)\n-----"
  end
end
