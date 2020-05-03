class ShiftsController < ApplicationController
    before_action :set_shift, only: [:show, :edit, :terminate, :destroy, :start, :end]
    before_action :check_login
    authorize_resource

    #@time_clock = TimeClock.new(@shift)
    def index
        # for phase 3 only
          if current_user.role?(:employee)
            @upcoming_shifts = Shift.for_employee(current_user).upcoming.chronological.by_employee.paginate(page: params[:page]).per_page(10)
            @past_shifts = Shift.for_employee(current_user).past.chronological.by_employee.paginate(page: params[:page]).per_page(10)
            @current_shifts = Shift.for_employee(current_user).started.chronological.by_employee.paginate(page: params[:page]).per_page(10)
          elsif current_user.role?(:manager)
            @finished_shifts = Shift.for_store(current_user.current_assignment.store).finished.incomplete.chronological.paginate(page: params[:page]).per_page(10)
            @upcoming_shifts = Shift.for_store(current_user.current_assignment.store).upcoming.chronological.by_employee.paginate(page: params[:page]).per_page(10)
            @past_shifts = Shift.for_store(current_user.current_assignment.store).past.chronological.paginate(page: params[:page]).per_page(10)
            @current_shifts = Shift.for_store(current_user.current_assignment.store).started.chronological.by_employee.paginate(page: params[:page]).per_page(10)
          else
            @finished_shifts = Shift.finished.incomplete.chronological.paginate(page: params[:page]).per_page(10)
            @upcoming_shifts = Shift.upcoming.chronological.by_employee.paginate(page: params[:page]).per_page(10)
            @past_shifts = Shift.past.chronological.by_employee.paginate(page: params[:page]).per_page(10)
            @current_shifts = Shift.started.chronological.by_employee.paginate(page: params[:page]).per_page(10)
          end
    end
    def new
        @shift = Shift.new
        @shift.assignment_id = params[:assignment_id] unless params[:assignment_id].nil?
        #@time_clock = TimeClock.new(@shift)
      end

    def show 
        @jobs_worked = @shift.shift_jobs
    end 

    def edit
    end
  
    def create
      @shift = Shift.new(shift_params)
      if @shift.save
        redirect_to @shift, notice: "Successfully added shift to the system."
      else
        render action: 'new'
      end
    end
  
    def update
      if @shift.update_attributes(shift_params)
        redirect_to @shift, notice: "Updated shift information."
      else
        render action: 'edit'
      end
    end

    def start
        if Time.now.to_date < @shift.end_time
            redirect_to employee_home_path, alert: "You missed the shift. You cannot clock in."
        else
            @time_clock.start_shift_at()
            redirect_to employee_home_path, notice: "Shift Started!"
        end
    end

    def end
        @time_clock.end_shift_at()
        redirect_to employee_home_path, notice: "Shift ended."
    end

    private
  # Use callbacks to share common setup or constraints between actions.
    def set_shift
        @shift = Shift.find(params[:id])
        @time_clock = TimeClock.new(@shift)
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def shift_params
        params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :status, :notes)
    end
end