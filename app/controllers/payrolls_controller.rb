class PayrollsController < ApplicationController 
    before_action :set_roll, only: [:show, :store_pay_form, :store_calc, :emp_pay]
    before_action :check_login
    authorize_resource
    
    def store_pay_form
        @store = Store.find(params[:id])
        return @store
    end

    def show
    end

    def store_calc
        if params[:payroll][:store_id].empty? 
            redirect_to store_payroll_path(Store.first), alert: "Please select a store."
        elsif ((params[:payroll][:start].empty? || params[:payroll][:end].empty?) && params[:payroll][:options].empty?)
            store = Store.find(params[:payroll][:store_id]) unless params[:payroll][:store_id].empty?
            redirect_to store_payroll_path(store), alert: "Please select a valid date range."
        elsif params[:payroll][:options].empty? 
            puts "OPTIONS ARE NIL"
            sd = params[:payroll][:start] unless params[:payroll][:start].nil?
            ed = params[:payroll][:end] unless params[:payroll][:end].nil?
            @date_range = DateRange.new(params[:payroll][:start].to_date, params[:payroll][:end].to_date)
        elsif params[:payroll][:options].to_date == 1.month.ago.to_date
            puts "OPTION IS ONE MONTH"
            @date_range = DateRange.new(30.days.ago.to_date)
        elsif params[:payroll][:options].to_date == 2.weeks.ago.to_date
            puts "OPTION IS 2 WEEKS"
            @date_range = DateRange.new(14.days.ago.to_date)
        else
            @date_range = DateRange.new(params[:payroll][:start].to_date, params[:payroll][:end].to_date)

        end
        #byebug
        #@store = Store.find([:store_id])
        #byebug
        #byebug
        puts "The STORE IS NIL" if params[:payroll][:store_id].nil? 
        #byebug
        puts "THIS IS THE START DATE"
        #date_range = DateRange.new(sd)
        puts "THE DATE RANGE IS NIL" if @date_range.nil?
        store = Store.find(params[:payroll][:store_id]) unless params[:payroll][:store_id].empty?
        @calc = PayrollCalculator.new(@date_range) unless @date_range.nil?
        #puts "THE CALC IS NIL" if @calc.nil?
        @pay_rolls = @calc.create_payrolls_for(store).paginate unless @calc.nil?
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
