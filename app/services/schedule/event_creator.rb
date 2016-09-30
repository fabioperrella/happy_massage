require 'icalendar/tzinfo'

module Schedule
  class EventCreator
    def create_event(massage:)
      @cal = Icalendar::Calendar.new
      @massage = massage
      cal.append_custom_property("METHOD", "REQUEST")

      set_timezone
      set_event

      cal.to_ical
    end

    private

    attr_accessor :cal, :massage

    def set_timezone
      cal.timezone do |t|
        t.tzid = tzid

        t.standard do |s|
          s.tzoffsetfrom = daylight_previous_period_offset
          s.tzoffsetto = time_now.formatted_offset(false)
          s.tzname = time_now.strftime('%Z')
          s.dtstart = daylight_current_period_start
        end
      end
    end

    def set_event
      cal.event do |e|
        e.dtstart = massage_dt_start
        e.dtend = massage_dt_end
        e.summary = t(:summary)
        e.description = t(:description)
        e.ip_class = "PUBLIC"

        attendee_params = {
          "CUTYPE" => "INDIVIDUAL",
          "ROLE" => "REQ-PARTICIPANT",
          "PARTSTAT" => "NEEDS-ACTION",
          "RSVP" => "TRUE",
          "CN" => massage.user_name,
          "X-NUM-GUESTS" => 1
        }
        attendee_value = Icalendar::Values::CalAddress
          .new("MAILTO:#{massage.user_email}", attendee_params)
        e.append_attendee(attendee_value)
      end
    end

    def t(key)
      I18n.t("services.event_creator.#{key}")
    end

    def tzid
      @tzid ||= ActiveSupport::TimeZone::MAPPING[Time.zone.name]
    end

    def daylight_current_period_start
      Time.zone.tzinfo.current_period
          .utc_start.strftime('%Y%m%dT%H%M%S')
    end

    def time_now
      @time_now ||= Time.zone.now
    end

    def daylight_previous_period_offset
      (Time.zone.tzinfo.current_period.utc_start - 1.day)
        .in_time_zone
        .formatted_offset(false)
    end

    def massage_dt_start
      Icalendar::Values::DateTime.new massage.timetable, tzid: tzid
    end

    def massage_dt_end
      Icalendar::Values::DateTime.new(
        massage.timetable + ScheduleSettings.massage_duration,
        tzid: tzid
      )
    end
  end
end