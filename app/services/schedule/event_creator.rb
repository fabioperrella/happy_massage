require 'icalendar/tzinfo'

module Schedule
  class EventCreator
    TZID = "America/Sao_Paulo"

    def create_event(massage:)
      cal = Icalendar::Calendar.new
      cal.append_custom_property("METHOD", "REQUEST")

      cal.timezone do |t|
        t.tzid = TZID

        t.standard do |s|
          s.tzoffsetfrom = "-0200"
          s.tzoffsetto   = "-0300"
          s.tzname       = "BRT"
          s.dtstart      = "20160221T020000"
        end
      end

      cal.event do |e|
        e.dtstart     = Icalendar::Values::DateTime.new massage.timetable, tzid: TZID
        e.dtend       = Icalendar::Values::DateTime.new massage.timetable + 15.minutes, tzid: TZID
        e.summary     = t(:summary)
        e.description = t(:description)
        e.ip_class    = "PUBLIC"

        attendee_params = {
          "CUTYPE"   => "INDIVIDUAL",
          "ROLE"     => "REQ-PARTICIPANT",
          "PARTSTAT" => "NEEDS-ACTION",
          "RSVP"     => "TRUE",
          "CN"       => massage.user_name,
          "X-NUM-GUESTS" => 1
        }
        attendee_value = Icalendar::Values::CalAddress.new("MAILTO:#{massage.user_email}", attendee_params)
        e.append_attendee(attendee_value)
      end

      cal.to_ical
    end

    private

    def t(key)
      I18n.t("services.event_creator.#{key}")
    end
  end
end