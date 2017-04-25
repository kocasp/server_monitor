class Carer::Config
  attr_accessor :ping_limits, :folders_limits, :memory_available_limit, :refresh_time, :file, :config_data
  def initialize(file)
    @file = file
    @ping_limits = {}
    @folders_limits = {}
    @memory_available_limit = {}
    @refresh_time = nil
    load_config_data
  end

  private

  def load_config_data
    @config_data = YAML::load(File.open(file))
    @refresh_time = config_data["refresh_time"]
  end
end
