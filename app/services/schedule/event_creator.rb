module Schedule
  class EventCreator
    def create_event(massage:, cal: Icalendar::Calendar.new)
      <<~HEREDOC
        BEGIN:VCALENDAR
        VERSION:2.0
        PRODID:-//Locaweb//Massagem//EN
        CALSCALE:GREGORIAN
        METHOD:REQUEST
        BEGIN:VTIMEZONE
        TZID:America/Sao_Paulo
        X-MICROSOFT-CDO-TZID:8
        BEGIN:STANDARD
        DTSTART:20160221T020000
        TZOFFSETFROM:-0200
        TZOFFSETTO:-0300
        TZNAME:BRT
        END:STANDARD
        END:VTIMEZONE
        BEGIN:VEVENT
        UID:F728F9F14A9F5A61702CAB23A6BB8CC9-E2E115F951D0877D
        DTSTAMP:20160910T222134Z
        CREATED:20160910T222134Z
        LAST-MODIFIED:20160910T222134Z
        DTSTART;TZID=America/Sao_Paulo:20160911T140000
        DTEND;TZID=America/Sao_Paulo:20160911T143000
        SUMMARY:lala poppo
        SEQUENCE:0
        TRANSP:OPAQUE
        CLASS:PUBLIC
        ATTENDEE;PARTSTAT=NEEDS-ACTION;ROLE=REQ-PARTICIPANT;CUTYPE=INDIVIDUAL;RSVP=
         TRUE:mailto:fabio.perrella@gmail.com
        END:VEVENT
        END:VCALENDAR
      HEREDOC
    end
  end
end