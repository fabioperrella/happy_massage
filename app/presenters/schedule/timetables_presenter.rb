module Schedule
  class TimetablesPresenter
    def available_schedule(request_time)
      schedule = available_timetables(request_time)
      schedule.group_by { |t| t[0].to_date }
              .map      { |g| { date: g[0], periods: group_by_period(g[1]) } }
    end

    private

    def available_timetables(request_time)
      available_timetables = []

      start_time = request_time
      end_time   = build_end_time(request_time)

      schedule_table(request_time).each do |timetable|
        massages_left = enabled_masseurs - scheduled_massages(start_time, end_time)[timetable].to_i
        next if massages_left.zero?

        available_timetables << [timetable, massages_left]
      end

      available_timetables
    end

    def group_by_period(day_schedule)
      day_schedule.group_by { |t| t[0].hour / 12 }
                  .map      { |g| { period: %w(morning afternoon)[g[0]], 
                                    schedule: build_period_schedule(g[1]) } }
    end

    def build_period_schedule(period_schedule)
      period_schedule.map { |t| { time: t[0], 
                                  remaining_massages: t[1] } }
    end

    def scheduled_massages(start_time, end_time)
      @schedule_massages ||= begin
        query = Massage.where('date(timetable) >= ? and date(timetable) < ?', start_time, end_time)
                       .group(:timetable).count(:id)
        Hash[query.map { |key, value| [key.in_time_zone, value] }]
      end
    end

    def schedule_table(request_time)
      end_time = build_end_time(request_time)
      Schedule::TableGenerator.new.schedule_table(request_time, end_time)
    end

    def enabled_masseurs
      @enabled_masseurs ||= Masseur.enabled.count
    end

    def build_end_time(request_time)
      delta_days = (ScheduleSettings.scheduling_window_days - 1).day
      request_time.at_end_of_day + delta_days
    end
  end
end
