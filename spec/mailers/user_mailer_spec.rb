describe UserMailer do
  describe '.notify_massage' do
    subject(:notify_massage) { described_class.notify_massage }

    it { expect(notify_massage.body).to include("agendou") }
    # it { expect(notify_massage.to).to eq [email.customer.email] }
  end
end