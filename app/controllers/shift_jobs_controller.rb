class ShiftJobsController < ApplicationController
    before_action :set_shift_job, only: [:show, :edit, :update]
    before_action :check_login
    authorize_resource
    def index
    end
    def new
        @shift_job = ShiftJob.new
        @shift_job.shift_id = params[:shift_id] unless params[:shift_id].nil?
        #@shift_job.job_id = params[:shift_id] unless params[:shift_id].nil?
      end

    def show 
    end 

    def edit
    end
  
    def create
      @shift_job = ShiftJob.new(shift_job_params)
      if @shift_job.save
        if current_user.role?(:manager)
            redirect_to manager_home_path, notice: "Successfully added jobs to #{@shift_job.shift.name}."
        else current_user.role?(:admin)
            redirect_to shifts_path, notice: "Successfully added jobs to #{@shift_job.shift.name}."
        end
      else
        render action: 'new'
      end
    end
  
    def update
      if @shift_job.update_attributes(shift_job_params)
        redirect_to shift_path(@shift_job.shift), notice: "Updated shift job information."
      else
        render action: 'edit'
      end
    end

    private
  # Use callbacks to share common setup or constraints between actions.
    def set_shift_job
        @shift_job = ShiftJob.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def shift_job_params
        params.require(:shift_job).permit(:shift_id, :job_id)
    end
end