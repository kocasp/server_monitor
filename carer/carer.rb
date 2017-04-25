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
    # @controls = config.controls_hash.map{|key, value| Object.const_get("Control::#{key.capitalize}").new(value)}
    config.controls_array.each do |control_type|
      klass = Object.const_get("Control::#{control_type[0].capitalize}")
      controls.concat control_type[1].map{|target, params| klass.new(target: target, value: params.values.first)}
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

  # # def dp(object)
  # #   p object if params[:verbose] == "verbose"
  # # end

  # def check_folders_sizes
  #   config.folders_limits.each do |directory, params|
  #     check_folder_size(directory, params["size"].to_f)
  #   end
  # end

  # # folder size in KB
  # def check_folder_size(location, size)
  #   control = Control::Directories.new(location: location, size: size).check!
  #   @checks[:folders_limits][location] = control.target
  #   report (control.errors.join("\n")) unless control.passed?
  # end

  # def check_memory_available
  #   result = `top | head -n 9`
  #   memory_available = result.split("\n")[6].split(" ")[-2] rescue "0M"
  #   @checks[:memory_available] = memory_available

  #   report "Memory available (#{memory_available}) below #{config.memory_available_limit}" if config.memory_available_limit.to_f > memory_available.to_f
  # end

  # def check_pings
  #   config.addresses.each do |address|
  #     check_ping(address)
  #   end
  # end

  # performs check of package loss in % and ping time in ms
  # def check_ping(address)
  #   result = `ping -c 1 #{address}`
  #   ping_time = result.split("\n")[1].split("=").last.split(" ").first rescue 99999
  #   packet_loss_percent = result.split("\n")[-2].split(" ")[-3] rescue "100%"

  #   @checks[:address_limits][address] = {ping: ping_time, packet_loss_percent: packet_loss_percent}

  #   report "Ping time of #{address} (#{ping_time}) above #{config.ping_limits[address]["ping_time"]}" if ping_time.to_f > config.ping_limits[address]["ping_time"].to_f
  #   report "Package loss of #{address} (#{packet_loss_percent}) above #{config.ping_limits[address]["packet_loss_percent"]}" if packet_loss_percent.to_f > config.ping_limits[address]["packet_loss_percent"].to_f
  # end

  def system_windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    # File.exists?('C:\\')
  end

  def self.header
    "      ___\n     /\\  \\\n    /::\\  \\\n   /:/\\:\\  \\\n  /:/  \\:\\  \\\n /:/__/ \\:\\__\\\n \\:\\  \\  \\/__/\n  \\:\\  \\\n   \\:\\  \\\n    \\:\\__\\\n     \\/__/\n------\nCARER  (ctrl+C to quit)\n-----"
  end
end
