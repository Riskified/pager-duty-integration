require_relative '../../common/common_structs'

class ShifterRecipient
  include CommonStructs
  def initialize(whos_on_call, schedule_id)
    @whos_on_call = whos_on_call
    @schedule_id = schedule_id
  end

  def recipient
    users_hash = @whos_on_call.get(@schedule_id)
    users_hash.map { |user| User.new(user['name'], user['email']) }
  end
end
