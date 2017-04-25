class Carer
  attr_reader :config, :params, :ping_time, :packet_loss_percent, :memory, :checks, :logs, :mailer
  def initialize(params={})
    initialize_checks
    @params = params
    @logs = []
    load_config
    initialize_mailer
  end

  def check!
    check_folders_sizes
    check_memory_available
    check_pings
  end

  def report(message)
    @logs << "#{Time.now} WARNING! #{message}"
    mailer.notify "#{Time.now} WARNING! #{message}"
  end

  def clear_logs!
    @logs = []
  end

  private

  def initialize_checks
    @checks = {
      folders_limits: {},
      address_limits: {}
    }
  end

  def initialize_mailer
    @mailer = Mailer.new(config.email_interval, ["kocasp@gmail.com"])
  end

  def load_config
    @config = Config.new("config/config.yml")
  end

  # def dp(object)
  #   p object if params[:verbose] == "verbose"
  # end

  def check_folders_sizes
    config.folder_names.each do |location|
      check_folder_size(location)
    end
  end

  # folder size in KB
  def check_folder_size(location)
    result = `du -s #{location}`.split("\t").first
    @checks[:folders_limits][location] = result
    report "#{location} directory size (#{result}) above #{config.folders_limits[location]["size"]}" if config.folders_limits[location]["size"].to_f < result.to_f
  end

  def check_memory_available
    result = `top | head -n 9`
    memory_available = result.split("\n")[6].split(" ")[-2] rescue "0M"
    @checks[:memory_available] = memory_available

    report "Memory available (#{memory_available}) below #{config.memory_available_limit}" if config.memory_available_limit.to_f > memory_available.to_f
  end

  def check_pings
    config.addresses.each do |address|
      check_ping(address)
    end
  end

  # performs check of package loss in % and ping time in ms
  def check_ping(address)
    result = `ping -c 1 #{address}`
    ping_time = result.split("\n")[1].split("=").last.split(" ").first rescue 99999
    packet_loss_percent = result.split("\n")[-2].split(" ")[-3] rescue "100%"

    @checks[:address_limits][address] = {ping: ping_time, packet_loss_percent: packet_loss_percent}

    report "Ping time of #{address} (#{ping_time}) above #{config.ping_limits[address]["ping_time"]}" if ping_time.to_f > config.ping_limits[address]["ping_time"].to_f
    report "Package loss of #{address} (#{packet_loss_percent}) above #{config.ping_limits[address]["packet_loss_percent"]}" if packet_loss_percent.to_f > config.ping_limits[address]["packet_loss_percent"].to_f
  end

  def system_windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    # File.exists?('C:\\')
  end

  def self.header
    "      ___\n     /\\  \\\n    /::\\  \\\n   /:/\\:\\  \\\n  /:/  \\:\\  \\\n /:/__/ \\:\\__\\\n \\:\\  \\  \\/__/\n  \\:\\  \\\n   \\:\\  \\\n    \\:\\__\\\n     \\/__/\n------\nCARER  (ctrl+C to quit)\n-----"
  end
end
