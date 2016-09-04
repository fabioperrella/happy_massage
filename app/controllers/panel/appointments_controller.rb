module Panel
  class AppointmentsController < Panel::BaseController
    def index
      @appointments_presenter = AppointmentsPresenter.new(current_user)
    end

    def create
      @massage = schedule_massage
      if @massage.persisted?
        UserMailer.notify_massage(massage_id: @massage.id).deliver_later
        flash[:notice] = t('.massage_has_been_scheduled')
        redirect_to root_path
      else
        flash[:alert] = @massage.errors.messages[:timetable].first
        redirect_to :back
      end
    end

    def new
      @available_timetables = Schedule::TimetablesPresenter.new.available_schedule(Time.now)
      @massage = Massage.new
    end

    def destroy
      appointment = Massage.find(params[:id])
      if appointment.cancel!
        flash[:notice] = t('.cancelled')
      else
        flash[:alert] = t('.cannot_cancel')
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('.appointment_not_found')
    ensure
      redirect_to root_path
    end

    def schedule
      render json: Schedule::TimetablesPresenter.new.available_schedule(Time.now)
    end

    private

    def schedule_massage
      Schedule::MassageScheduler.new(massage_params).schedule_massage
    end

    def massage_params
      params.permit(:user, :timetable).merge(user: current_user)
    end
  end
end
