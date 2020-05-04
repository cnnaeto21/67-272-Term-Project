class PayrollsController < ApplicationController 
    before_action :set_roll, only: [:show, :store_pay_form, :store_calc, :emp_pay]
    before_action :check_login
    authorize_resource
    
    def store_pay_form
        @store = Store.find(params[:id])
        return @store
        #params[:store_id] = params[:id]
        # date_range = DateRange.new(30.day.ago.to_date)
        # puts "THE DATE RANGE IS NIL" if date_range.nil?
        # calc = PayrollCalculator.new(date_range)
        # puts "THE CALC IS NIL" if calc.nil?
        # @pay_rolls = calc.create_payrolls_for(@store).paginate
        # puts "THE PAY ROLL IS NILL" if @pay_rolls.nil?
    end

    def show
    end

    def store_calc
        byebug
        if params[:options].nil? 
            puts "OPTIONS ARE NIL"
            sd = params[:start] unless params[:start].nil?
            ed = params[:end] unless params[:end].nil?
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
        #byebug
        #@store = Store.find([:store_id])
        #byebug
        byebug
        puts "The STORE IS NIL" if params[:store_id].nil? 
        store = Store.find(params[:store_id])
        byebug
        date_range = DateRange.new(30.day.ago.to_date)
        puts "THE DATE RANGE IS NIL" if date_range.nil?
        calc = PayrollCalculator.new(sd,ed)
        puts "THE CALC IS NIL" if calc.nil?
        @pay_rolls = calc.create_payrolls_for(store).paginate
        puts "THE PAY ROLL IS NILL" if @pay_rolls.nil?
    end

    def emp_pay
        emp = Employee.find(params[:id])
        date_range = DateRange.new(7.days.ago.to_date)
        calc = PayrollCalculator.new(date_range)
        @pay_roll = calc.create_payroll_record_for(emp).paginate
    end


    private
  # Use callbacks to share common setup or constraints between actions.
    def set_roll
        #@store = Store.find(params[:store_id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
        params.require(:payroll).permit(:store_id, :start, :end, :options)
    end


end
