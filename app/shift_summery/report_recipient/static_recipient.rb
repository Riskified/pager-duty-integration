require_relative '../../common/common_structs'

class StaticRecipient
  include CommonStructs
  def initialize(recipient_email)
    @user = User.new(name: 'static', email: recipient_email)
  end

  def recipient
    [@user]
  end
end
