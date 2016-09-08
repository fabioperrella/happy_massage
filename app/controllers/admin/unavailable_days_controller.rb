module Admin
  class UnavailableDaysController < BaseController
    def index
      @unavailable_days = UnavailableDay.order(:date).all
    end

    def create
      begin
        @unavailable_day = UnavailableDay.create!(unavailable_day_params)
      rescue ActiveRecord::RecordInvalid => e
        flash[:alert] = e.message
      end
      redirect_to admin_unavailable_days_path
    end

    def destroy
      UnavailableDay.find(params[:id]).destroy
      redirect_to admin_unavailable_days_path
    end

    private

    def unavailable_day_params
      params.permit(:description, :date)
    end
  end
end
