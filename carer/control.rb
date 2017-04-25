class Control
  attr_accessor :target, :value, :comparator, :performed
  attr_reader :errors, :target_value
  def initialize(params = {})
    @performed = false
    @target = params[:target]
    @value = params[:value]
    @comparator = params[:comparator]
    @errors = []
    calculate_target_value
  end

  def check!
    @errors = []
    @performed = true
    calculate_target_value
    add_error if target_value.public_send(comparator, value)
    self
  end

  def passed?
    performed && errors.empty?
  end

  def type
    self.class.name.split("::").last.downcase
  end

  protected

  def add_error
    @errors << error_message
  end
end
