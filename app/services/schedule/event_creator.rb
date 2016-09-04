module Schedule
  class EventCreator
    def create_event(massage:, cal: Icalendar::Calendar.new)
      cal.event do |e|
        e.dtstart     = massage.timetable
        e.dtend       = massage.timetable + ScheduleSettings.massage_duration
        e.summary     = I18n.t(:massage)
        e.description = I18n.t(:massage)
      end

      cal.publish
      cal
    end
  end
end