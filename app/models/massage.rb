class Massage < ActiveRecord::Base
  has_and_belongs_to_many :accounts
  has_many :masseurs

  validates_presence_of :timetable, :masseur
end
