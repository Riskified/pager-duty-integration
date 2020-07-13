require_relative 'shift_summery_report'

class ShiftSummery
  def initialize(incident_fetcher, recipient_repo, email_client,
                 escalation_policy_id:,
                 subject_prefix:)
    @incident_repo = incident_fetcher
    @ep_id = escalation_policy_id
    @recipient_repo = recipient_repo
    @email_client = email_client
    @subject_prefix = subject_prefix
  end

  def summerize
    shifters = @recipient_repo.recipient
    puts shifters

    incidents = @incident_repo.list_daily_by_ep(@ep_id)
    log_relevant_incidents(incidents)

    report = generate_reports(incidents)
    send_report(shifters, report)
  end

  private
  def log_relevant_incidents(incidents)
    puts '---------------------'
    puts 'Relevant incidents found:'
    incidents.each { |x| puts x }
    puts '---------------------'
  end

  def generate_reports(incidents)
    ShiftSummeryReport.new(incidents).render
  end

  def send_report(shifters, report)
    @email_client.send_email(shifters.first, report, subject)
  end

  def subject
    "#{@subject_prefix} #{ShiftTimeframe.start.day}-#{ShiftTimeframe.end.day}/#{ShiftTimeframe.start.month}"
  end
end

