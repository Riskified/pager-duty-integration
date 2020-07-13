class ShiftSummeryReport
  def initialize(incidents)
    puts "incidents in report: #{incidents.size}"
    @incidents = incidents
  end

  def render
    template = File.read(__dir__ + '/summery_template.html.erb')
    ERB.new(template).result(binding)
  end
end
