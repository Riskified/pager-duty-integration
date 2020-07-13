require_relative 'static_recipient'
require_relative 'shifter_recipient'
require_relative '../../pager_duty_api/whos_on_call'

class RecipientFactory
  def self.resolve(configuration)
    static_email = configuration[:shift_summery][:recipient_email]
    if static_email.nil?
      ShifterRecipient.new(WhosOnCall.new(configuration[:pager_duty_api][:token]), configuration[:shift_summery][:schedule_id])
    else
      StaticRecipient.new(configuration[:recipient_email])
    end
  end
end
