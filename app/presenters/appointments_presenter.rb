class AppointmentsPresenter
  def initialize(user)
    @user = user
  end

  def recent_appointments
    @recent_appointments ||= \
      user
      .massages
      .scheduled_massages
      .where('timetable > ?', interval_to_be_considered_recent)
      .order(:timetable)
  end

  def past_appointments
    user.massages.past_massages.order(timetable: :desc)
  end

  private

  attr_reader :user

  def interval_to_be_considered_recent
    Time.zone.now - ScheduleSettings.massage_duration
  end
end
