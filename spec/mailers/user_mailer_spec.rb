describe UserMailer do
  describe '.notify_massage' do
    let(:event_content) { 'lalalapoppopo' }
    let(:event_creator) { double 'event_creator', create_event: event_content }
    let(:massage) { create :massage }

    subject(:notify_massage) do
      described_class.notify_massage(
        massage_id: massage.id,
        event_creator: event_creator
      )
    end

    before do
      allow_any_instance_of(TimetableValidator).to receive(:validate_each)
    end

    it { expect(notify_massage.subject).to include("agendada") }
    it { expect(notify_massage.body.to_s).to eq event_content }
    it { expect(notify_massage.content_type).to eq "text/calendar; charset=UTF-8; method=REQUEST" }
    it { expect(notify_massage.to).to eq [massage.user_email] }
  end
end