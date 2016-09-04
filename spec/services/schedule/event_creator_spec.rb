describe Schedule::EventCreator do
  describe '#create_event' do
    let(:massage) { build :massage, timetable: Time.zone.parse("2015-05-10 12:00:00") }

    subject(:create_event) { described_class.new.create_event(massage: massage) }
    let(:first_event) { create_event.events.first }

    it { expect(create_event.events.count).to eq 1 }
    it { expect(first_event.description).to include "Massagem" }
    it { expect(first_event.summary).to include "Massagem" }
    it { expect(first_event.dtstart).to eq massage.timetable }
    it { expect(first_event.dtend).to eq Time.zone.parse("2015-05-10 12:15:00") }
  end
end