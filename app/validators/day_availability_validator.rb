class DayAvailabilityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.errors[attribute].any?
    if(UnavailableDay.all.map(&:date).include?(value))
      record.errors.add(attribute, :date_unavailable)
    end
  end
end
