class Control
  attr_accessor :type
  def initialize(params = {})
    @type = params[:type]
    @target = params[:target]
    @value = params[:value]
  end

  def passed?
    raise
  end
end
