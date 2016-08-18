class TimetableWeekYearUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return if record.user.nil? || record.timetable.nil?
    validate_week_year_uniqueness(record, attribute)
  end

  private

  def validate_week_year_uniqueness(record, attribute)
    return if record.errors[attribute].any?
    if user_has_scheduled_this_week?(record)
      record.errors.add(attribute, :timetable_week_and_year_are_not_unique)
    end
    if user_has_scheduled_too_many_massages?(record)
      record.errors.add(attribute, :exceeded_scheduled_massages)
    end
  end

  def user_has_scheduled_this_week?(record)
    massages_scheduled_week = user_massages_for_same_week(record.user, record.timetable)
    massages_scheduled_week >= ScheduleSettings.scheduled_limit_per_week
  end

  def user_has_scheduled_too_many_massages?(record)
    total_massages_scheduled = user_total_scheduled_massages(record.user)
    total_massages_scheduled >= ScheduleSettings.scheduled_limit_total
  end

  def user_total_scheduled_massages(user)
    user.massages.where('status = ?', 'scheduled').count
  end

  def user_massages_for_same_week(user, timetable)
    user.massages
        .where(
          'date >= ? and date <= ?',
          timetable.beginning_of_week,
          timetable.end_of_week
        ).count
  end
end
