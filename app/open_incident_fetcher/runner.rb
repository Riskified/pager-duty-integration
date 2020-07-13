require_relative 'open_incidents_reporter.rb'
token = ENV['PD_TOKEN']
team_id  = ENV['TEAM_ID']
OpenIncidentsReporter.new(token, team_id).run
