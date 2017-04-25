class Control::Connection < Control
  def initialize(params = {})
    @params = params
    super(type: type, target: @params[:target], value: @params[:value], comparator: :<)
  end

  def calculate_target_value
    result = `ping -c 1 #{@params[:target]}`
    @target_value = result.split("\n")[1].split("=").last.split(" ").first.to_f rescue 99999
  end

  def error_message
    "ping  to #{@params[:target]} time (#{@params[:target_value]}) above #{@params[:value]}"
  end
end
