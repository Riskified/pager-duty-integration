require 'sendgrid-ruby'

class EmailClient
  include SendGrid
  SENDER = 'dev-shift-summery@riskified.com'.freeze
  ENCODING = 'UTF-8'.freeze

  def initialize(token)
    @token = token
  end

  def send_email(recipient, content, subject)
    from = Email.new(email: SENDER)
    to = Email.new(email: recipient.email)
    content = Content.new(type: 'text/html', value: content)
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: @token)
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    puts response.status_code
    puts response.body
    puts response.headers
  end
end
