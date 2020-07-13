require 'httparty'
require 'time'
require_relative 'shift_timeframe'

# html_url, id, created_at
Incident = Struct.new(:summery, :url, :id, :created_at)

class IncidentFetcher
  def initialize(token)
    @token = token
  end

  def to_model(incident)
    Incident.new(incident['summary'], incident['html_url'], incident['id'],
                 Time.parse(incident['created_at']))
  end

  def list_weekly_by_status(status)
    puts "getting #{status}..."

    response = HTTParty.get('https://api.pagerduty.com/incidents',
                            query: {
                                'statuses[]' => status,
                                'since' => (Date.today - 7).iso8601,
                                'until' => Date.today.iso8601
                            },
                            headers: {
                                'Accept' => 'application/json',
                                'Content-Type' => 'application/json',
                                'Authorization' => "Token token=#{@token}"
                            },
                            timeout: 10)

    puts "Got #{response.code} from PD API"
    if response.code == 200
      # puts response.body
      body = JSON.parse(response.body)
      body['incidents'].tap do |incidents|
        puts "Got #{incidents.size} incidents!"
      end
    else
      puts response.code, response.body
      []
    end
  end

  def list_daily_by_ep(escalation_policy_id)
    more = true
    offset = 0
    incidents = []
    while more
      response = get_shift_incidents(offset)

      if response.code == 200
        body = JSON.parse(response.body)
        incidents += process_page(escalation_policy_id, body)
        more = body['more']
        offset += 100
      else
        puts response.code, response.body
        return []
      end
    end

    incidents
  end

  private

  def get_shift_incidents(offset)
    HTTParty.get('https://api.pagerduty.com/incidents',
                 query: {
                     'since' => ShiftTimeframe.start.iso8601,
                     'until' => ShiftTimeframe.end.iso8601,
                     'limit' => 100,
                     'offset' => offset
                 },
                 headers: {
                     'Accept' => 'application/json',
                     'Content-Type' => 'application/json',
                     'Authorization' => "Token token=#{@token}"
                 },
                 timeout: 10)
            .tap{ |response| puts "[IncidentFetcher] Got #{response.code} from PD API" }
  end

  def process_page(escalation_policy_id, body)
    body['incidents'].tap do |incidents|
      puts "[IncidentFetcher] Got #{incidents.size} incidents!"
    end

    body['incidents']
      .select { |i| i['escalation_policy']['id'] == escalation_policy_id }
      .map { |incident_raw| to_model(incident_raw) }
  end
end
