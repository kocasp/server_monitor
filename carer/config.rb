class Config
  attr_accessor :ping_limits, :folders_limits, :memory_available_limit, :refresh_time, :file, :config_data, :email_interval, :controls_array
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
    # TODO: remove
    @refresh_time = config_data["refresh_time"]
    @email_interval = config_data["email_interval"]

    @controls_array = config_data.delete_if {|k,v| !available_params.include?(k) }.to_a
  end

  def available_params
    ["directories", "connection", "memory", "custom"]
    # ["ping_limits", "directories", "memory"]
  end
end
