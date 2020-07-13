require 'time'

class ShiftTimeframe
  def self.start
    previous = Date.today.prev_day
    DateTime.new(previous.year, previous.month, previous.day, 7, 0, 0)
  end

  def self.end
    today = Date.today
    DateTime.new(today.year, today.month, today.day, 7, 00, 0)
  end
end
