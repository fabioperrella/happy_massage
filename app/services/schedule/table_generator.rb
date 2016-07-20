module Schedule
  class TableGenerator
    def schedule_table(start_time, end_time)
      massage_dates = massage_dates(start_time, end_time)
      massage_dates.map { |d| massage_schedules(d.year, d.month, d.day) - pauses(d.year, d.month, d.day) }
           .flatten
           .select { |d| (d > start_time) & (d < end_time) }
    end

    private

    def massage_dates(start_time, end_time)
      dates_range(start_time, end_time).select { |d| configured_massage_days.include? d.strftime('%A') }
    end

    def dates_range(start_time, end_time)
      start_day = start_time.to_date
      end_day = end_time.to_date
      (start_day..end_day)
    end

    def configured_massage_days
      ScheduleSettings.massage_days
    end

    def massage_schedules(year, month, day)
      massage_interval = time_for(:massage_end) - time_for(:massage_start)
      massages = (massage_interval / ScheduleSettings.massage_duration - 1).to_i

      initial_hour, initial_minutes = ScheduleSettings.massage_start.split(':')
      initial = Time.zone.local(year, month, day, initial_hour, initial_minutes)

      massage_schedules = massages.times.each_with_object([initial]) do |_, acc|
        acc << acc.last + ScheduleSettings.massage_duration
      end
    end

    def time_for(time_expression)
      Time.zone.parse(ScheduleSettings.send(time_expression))
    end

    def pauses(year, month, day)
      pauses = []
      ScheduleSettings.pauses.each do |pause_start, pause_end|
        pause_interval = Time.zone.parse(pause_end) - Time.zone.parse(pause_start)
        pause = (pause_interval / ScheduleSettings.massage_duration - 1).to_i

        initial_hour, initial_minutes = pause_start.split(':')
        initial = Time.zone.local(year, month, day, initial_hour, initial_minutes)

        pauses += pause.times.each_with_object([initial]) do |_, acc|
          acc << acc.last + ScheduleSettings.massage_duration
        end
      end
      pauses
    end
  end
end
