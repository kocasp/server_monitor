class Carer
  attr_reader :config, :params, :ping_time, :packet_loss_percent, :memory, :checks
  def initialize(params={})
    @checks = {}
    @params = params
    load_config
  end

  def check!
    check_folder_size("config/")
    check_memory_available
    check_pings("onet.pl")
  end

  private

  def load_config
    @config = Carer::Config.new("config/config.yml")
  end

  def dp(object)
    p object if params[:verbose] == "verbose"
  end

  # folder size in KB
  def check_folder_size(location)
    `du -s #{location}`.split("\t").first
  end

  def check_memory_available
    result = `top | head -n 9`
    @checks[:memory_available] = result.split("\n")[6].split(" ")[-2] rescue "0M"
  end

  # performs check of package loss in % and ping time in ms
  def check_pings(address)
    result = `ping -c 1 #{address}`
    @checks[:ping_time] = result.split("\n")[1].split("=").last.split(" ").first rescue -1
    @checks[:packet_loss_percent] = result.split("\n")[-2].split(" ")[-3] rescue "100%"
  end

  def system_windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    # File.exists?('C:\\')
  end

  def self.header
    "      ___\n     /\\  \\\n    /::\\  \\\n   /:/\\:\\  \\\n  /:/  \\:\\  \\\n /:/__/ \\:\\__\\\n \\:\\  \\  \\/__/\n  \\:\\  \\\n   \\:\\  \\\n    \\:\\__\\\n     \\/__/\n------\nCARER\n-----"
  end
end
