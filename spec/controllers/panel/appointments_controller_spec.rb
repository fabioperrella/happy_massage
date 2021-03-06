describe Panel::AppointmentsController do
  let(:cas_user) { 'jackie.chan' }
  let(:cas_extra_attributes) do
    {
      'authorities' => ['MASSAGE_ADMIN-N3'],
      'cn'          => 'Jackie Chan',
      'email'       => 'jackie.chan@gmail.com',
      'type'        => 'Employee'
    }
  end

  before do
    CASClient::Frameworks::Rails::Filter.fake(cas_user, cas_extra_attributes)
  end

  describe 'GET #index' do
    before do
      create(:masseur)
      get :index
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(assigns(:appointments_presenter)).to_not be_nil }
  end

  describe 'POST #create' do
    let!(:masseur) { create(:masseur) }
    let!(:user) { create(:user) }
    let(:timetable) { '2015-08-05 9:00' }
    let(:params) do
      {
        user:      user,
        timetable: timetable
      }
    end

    before do
      Timecop.freeze(Time.zone.parse('2015-08-04 15:00'))

      request.env['HTTP_REFERER'] = root_path

      post(:create, params)
    end

    after { Timecop.return }

    context 'when massage persists' do
      let(:successful_creation_message) { 'Massagem agendada com sucesso!' }

      it { expect(Massage.last).to_not be_nil }
      it { is_expected.to redirect_to root_path }
      it { expect(flash[:notice]).to eq(successful_creation_message) }
    end

    context 'when massage does not persist' do
      let(:timetable) { '2015-08-05 9:01' }
      let(:error_message) do
        'O horário para o agendamento é obrigatório e deve conter ' \
        'um valor compatível com as regras estabelecidas. ' \
        'Por favor, tente novamente.'
      end

      it { expect(Massage.last).to be_nil }
      it { is_expected.to redirect_to root_path }
      it { expect(flash[:alert]).to eq(error_message) }
    end
  end

  describe 'GET #new' do
    let(:available_schedule) do
      Schedule::TimetablesPresenter.new.available_schedule(Time.zone.parse('2015-08-07 15:00'))
    end

    before do
      Timecop.freeze(Time.zone.parse('2015-08-07 15:00'))
      create(:masseur)
      get(:new)
    end

    after { Timecop.return }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
    it { expect(assigns(:available_timetables)).to eq available_schedule }
  end

  describe 'DELETE #destroy' do
    before do
      request.env['HTTP_REFERER'] = root_path

      Timecop.travel('2015-08-18 15:00') do
        create(:massage, timetable: Time.zone.parse('2015-08-19 9:00'))
      end
    end

    context 'when massage appointment can be cancelled' do
      let(:successfully_cancelled) { 'Agendamento excluído com sucesso!' }

      before do
        Timecop.freeze('2015-08-19 8:29')

        delete(:destroy, id: Massage.last.id)
      end

      after { Timecop.return }

      it { is_expected.to redirect_to root_path }
      it { expect(flash[:notice]).to eq(successfully_cancelled) }
    end

    context 'when massage appointment can not be cancelled' do
      let(:cannot_be_cancelled) do
        'O agendamento deve ser cancelado com até 30 minutos de antecedência.'
      end

      before do
        Timecop.freeze('2015-08-19 8:31')

        delete(:destroy, id: Massage.last.id)
      end

      after { Timecop.return }

      it { is_expected.to redirect_to root_path }
      it { expect(flash[:alert]).to eq(cannot_be_cancelled) }
    end

    context 'when massage appointment is not found' do
      let(:not_found_message) { 'Agendamento não encontrado.' }

      before do
        Timecop.freeze('2015-08-19 8:31')

        delete(:destroy, id: Massage.last.id + 1)
      end

      it { is_expected.to redirect_to root_path }
      it { expect(flash[:alert]).to eq(not_found_message) }
    end
  end

  describe 'GET #schedule' do
    before do
    end
  end
end
