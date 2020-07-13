require_relative 'shift_summery.rb'
require_relative '../pager_duty_api/incident_fetcher.rb'
require_relative '../pager_duty_api/whos_on_call'
require_relative '../email/file_writer_email_client'
require_relative '../email/email_client'
require_relative 'report_recipient/recipient_factory'
require_relative '../common/configuration_loader'
class Bootstraper
  def self.init_shift_summery
    configuration = ConfigurationLoader.load(__dir__ + '/../config.yml')
    recipient = RecipientFactory.resolve(configuration)
    incident_fetcher = IncidentFetcher.new(configuration[:pager_duty_api][:token])
    email_client = EmailClient.new(configuration[:email][:auth_token])

    ShiftSummery.new(incident_fetcher, recipient, email_client,
                     escalation_policy_id: configuration[:shift_summery][:escalation_policy],
                     subject_prefix: configuration[:email][:subject_prefix])
  end
end
