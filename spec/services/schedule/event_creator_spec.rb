describe Schedule::EventCreator do
  describe '#create_event' do
    pending 'fazer os testes'
    let(:massage) { build :massage, timetable: Time.zone.parse("2015-05-10 12:00:00") }

    subject(:create_event) { described_class.new.create_event(massage: massage) }

    it { expect(create_event).to eq "1" }
  end
end