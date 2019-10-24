class User
  attr_accessor :yesterday, :today, :blocked, :block_reason

  def initialize(yesterday, today, blocked, block_reason = nil)
    @yesterday = yesterday
    @today = today
    @blocked = blocked
    @block_reason = block_reason
  end
end