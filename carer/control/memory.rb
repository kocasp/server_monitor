class Control::Memory < Control
  def initialize(params = {})
    @params = params
    super(type: type, target: @params[:target], value: @params[:value], comparator: :>)
  end

  def calculate_target_value
    result = `top | head -n 9`
    @target_value = result.split("\n")[6].split(" ")[-2].to_i rescue "0M".to_i
  end

  def error_message
    "System memory #{@params[:target_value]} of (#{@params[:target_value]}) is below #{@params[:value]}"
  end
end
