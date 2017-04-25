class Config
  attr_accessor :ping_limits, :folders_limits, :memory_available_limit, :refresh_time, :file, :config_data, :email_interval
  def initialize(file)
    @file = file
    @ping_limits = {}
    @folders_limits = {}
    @memory_available_limit = {}
    @refresh_time = nil
    load_config_data
  end

  def folder_names
    config_data["folders_limits"].keys
  end

  def addresses
    config_data["ping_limits"].keys
  end

  private

  def load_config_data
    @config_data = YAML::load(File.open(file))
    @refresh_time = config_data["refresh_time"]
    @folders_limits = config_data["folders_limits"]
    @ping_limits = config_data["ping_limits"]
    @memory_available_limit = config_data["minimum_memory_available"].to_f
    @email_interval = config_data["email_interval"]
  end
end
