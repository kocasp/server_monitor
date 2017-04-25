class Control::Custom < Control
  def initialize(params = {})
    @params = params
    super(type: type, target: @params[:target], value: @params[:value], comparator: @params[:comparator])
  end

  def calculate_target_value
    @target_value = eval @params[:target_value]
  end

  def error_message
    "Custom check of #{@params[:value]} failed"
  end
end
