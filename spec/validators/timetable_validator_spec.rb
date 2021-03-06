class TimetableSample
  include ActiveModel::Validations

  validates :timetable, timetable: true

  attr_accessor :timetable

  def initialize(timetable)
    @timetable = timetable
  end
end

describe TimetableValidator do
  describe '#validate' do
    let(:massage_date) { Time.zone.today }
    let(:schedule_table) do
      Schedule::TableGenerator.new(massage_date).schedule_table
    end
    subject(:timetable_sample) { TimetableSample.new(timetable) }

    context 'when schedule is open' do
      before { Timecop.freeze(Time.zone.parse('2015-08-04 15:00')) }
      after { Timecop.return }

      %w(8:59 8:59:59 9:01 10:30 14:29 17:45:01 18:00).each do |timetable|
        context 'but timetable is not included in schedule table' do
          let(:timetable) { Time.zone.parse(timetable) + 1.day }

          it { is_expected.to be_invalid }
        end
      end

      %w(9:00 9:15 9:30 10:45 14:30 17:45:00).each do |timetable|
        context 'and timetable is included in schedule table' do
          let(:timetable) { Time.zone.parse(timetable) + 1.day }

          it { is_expected.to be_valid }
        end
      end
    end
  end
end
