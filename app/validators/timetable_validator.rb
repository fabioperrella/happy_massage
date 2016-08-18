class TimetableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validate_schedule_table_contains_timetable(record, attribute, value)
  end

  private

  def validate_schedule_table_contains_timetable(record, attribute, value)
    return if record.errors[attribute].any?
    return if value.present? && schedule_table(value).include?(value)
    record.errors.add(attribute, :timetable_is_out_of_range)
  end

  def schedule_table(request_time)
    end_time = request_time + (ScheduleSettings.scheduling_window_days - 1).day
    Schedule::TableGenerator.new.schedule_table(request_time, end_time)
  end
end
