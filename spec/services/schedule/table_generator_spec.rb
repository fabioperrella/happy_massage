describe Schedule::TableGenerator do
  describe '#schedule_table' do

    subject(:schedule_table) do
      described_class.new.schedule_table(Time.zone.parse('2016-08-12 1:00'), Time.zone.parse('2016-08-12 23:00'))
    end

    context 'when table is generated' do
      it { is_expected.to_not be_nil }
      it { expect(schedule_table.count).to eq 30 }
    end

    context 'when a timetable corresponds to a massage' do
      it { is_expected.to include(Time.zone.parse('2016-08-12 09:00')) }
      it { is_expected.to include(Time.zone.parse('2016-08-12 10:45')) }
      it { is_expected.to include(Time.zone.parse('2016-08-12 14:30')) }
      it { is_expected.to include(Time.zone.parse('2016-08-12 17:45')) }
    end

    context 'when a timetable corresponds to a pause' do
      it { is_expected.to_not include(Time.zone.parse('2016-08-12 10:30')) }
      it { is_expected.to_not include(Time.zone.parse('2016-08-12 12:00')) }
      it { is_expected.to_not include(Time.zone.parse('2016-08-12 12:15')) }
      it { is_expected.to_not include(Time.zone.parse('2016-08-12 12:30')) }
      it { is_expected.to_not include(Time.zone.parse('2016-08-12 12:45')) }
      it { is_expected.to_not include(Time.zone.parse('2016-08-12 16:30')) }
    end
  end
end
