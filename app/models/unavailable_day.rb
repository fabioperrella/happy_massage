class UnavailableDay < ActiveRecord::Base
  validates_presence_of :date, :description
end
