class PayGradeRatesController < ApplicationController
    before_action :set_rate, only: [:show]
    before_action :check_login
    authorize_resource
  
    def index
      # get data on all pay grades and paginate the output to 10 per page
      @current_rates = PayGradeRate.current.chronological.paginate(page: params[:page]).per_page(10)
      @past_rates = PayGradeRate.past.chronological.paginate(page: params[:page]).per_page(10)
    end
  
    def show
    end

    def new
        @rate = PayGradeRate.new
        @rate.pay_grade_id = params[:pay_grade_id] unless params[:pay_grade_id].nil?
      end
    
    def create
        @rate = PayGradeRate.new(rate_params)
        if @rate.save
            redirect_to pay_grade_rates_path, notice: "Successfully added the pay rate."
        else
            render action: 'new'
        end
    end

    private
  # Use callbacks to share common setup or constraints between actions.
    def set_rate
        @rate = PayGradeRate.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def rate_params
        params.require(:pay_grade_rate).permit(:pay_grade_id, :rate, :start_date, :end_date)
    end
end