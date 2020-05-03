class PayrollsController < ApplicationController 
    before_action :set_roll, only: [:show, :store_pay_form, :store_calc, :emp_pay]
    before_action :check_login
    authorize_resource
    
    def store_pay_form

        @store = Store.find(params[:store_id])
    end

    def show
    end


    def store_calc
        if params[:options].nil? 
            sd = params[:start]
            ed = role_params[:end]
        elsif params[:options] == 1.month.ago.to_date
            sd = 1.month.ago.to_date
            ed = Date.today.to_date
        elsif params[:options] == 2.weeks.ago.to_date
            sd = 2.weeks.ago.to_date
            ed = Date.today.to_date
        else
            sd = params[:start]
            ed = params[:end]
        end
        store = Store.find(params[:store_id])
        date_range = DateRange.new(sd)
        calc = PayrollCalculator.new(date_range)
        byebug
        @pay_rolls = calc.create_payrolls_for(store).paginate
    end

    def emp_pay
        emp = Employee.find(params[:id])
        date_range = DateRange.new(7.days.ago)
        calc = PayrollCalculator.new(date_range)
        @pay_roll = calc.create_payroll_record_for(emp).paginate
    end


    private
  # Use callbacks to share common setup or constraints between actions.
    def set_roll
        #@roll = Payroll.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
        params.require(:payroll).permit(:store_id, :start, :end, :options)
    end


end