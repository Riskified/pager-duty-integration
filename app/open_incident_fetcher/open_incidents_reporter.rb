require 'httparty'
require 'time'

Incident = Struct.new(:summery, :url)

class OpenIncidentsReporter
  def initialize(token, team_id)
    @token = token
    @team_id = team_id
  end

  def extract_reportable_data(incidents)
    report = []
    incidents.each do |incident|
      report << Incident.new(incident['summary'], incident['html_url'])
    end
    report
  end

  def run
    incidents = []
    incidents.concat list_incidents('triggered')
    incidents.concat list_incidents('acknowledged')

    data = extract_reportable_data(incidents)
    report(data)
    nil
  end

  private

  def report(data)
    data.each do |incident|
      puts "#{incident.summery} -> #{incident.url}"
    end
  end

  def list_incidents(status)
    puts "getting #{status}..."

    response = HTTParty.get('https://api.pagerduty.com/incidents',
                            query: {
                                'team_ids[]' => @team_id,
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
end
