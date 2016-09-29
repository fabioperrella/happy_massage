describe Schedule::EventCreator do
  describe '#create_event' do
    let(:massage) { build :massage, timetable: Time.zone.parse("2015-05-10 12:00:00") }

    subject(:create_event) { described_class.new.create_event(massage: massage) }

    it { expect(create_event).to eq "111" }
    it { expect(create_event).to include "METHOD:REQUEST" }
    it { expect(create_event).to include "BEGIN:VTIMEZONE" }
    it { expect(create_event).to include "BEGIN:VCALENDAR" }
    it { expect(create_event).to include "TZID:America/Sao_Paulo" }
  end
end