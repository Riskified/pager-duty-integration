require 'httparty'
require_relative 'shift_timeframe'

class WhosOnCall
  OnCall = Struct.new(:name, :email)
  def initialize(token)
    @token = token
  end

  def get(schedule_id)
    puts "[WhosOnCall] resolving who's on call..."
    puts "[WhosOnCall] From #{ShiftTimeframe.start.iso8601}"
    puts "[WhosOnCall] To #{ShiftTimeframe.end.iso8601}"
    response = HTTParty.get("https://api.pagerduty.com/schedules/#{schedule_id}/users",
                            query: {
                                'since' => ShiftTimeframe.start.iso8601,
                                'until' => ShiftTimeframe.end.iso8601
                            },
                            headers: {
                                'Accept' => 'application/json',
                                'Content-Type' => 'application/json',
                                'Authorization' => "Token token=#{@token}"
                            },
                            timeout: 10)

    puts "[WhosOnCall] Got #{response.code} from PD API"
    if response.code == 200
      # puts response.body
      body = JSON.parse(response.body)
      body['users'].tap do |incidents|
        puts "[WhosOnCall] Got #{incidents.size} users!"
      end

      body['users']
    else
      puts '[WhosOnCall]', response.code, response.body
      []
    end
  end
end
