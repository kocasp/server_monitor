class Control::Directories < Control
  def initialize(params = {})
    @params = params
    super(type: type, target: @params[:target], value: @params[:value], comparator: :<)
  end

  def calculate_target_value
    @target_value = `du -s #{@params[:target]}`.split("\t").first.to_f
  end

  def error_message
    "#{@params[:target]} directory size (#{@params[:target_value]}) above #{@params[:value]}"
  end
end
