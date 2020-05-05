class JobsController < ApplicationController
    before_action :set_job, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    def index
      # get data on all pay grades and paginate the output to 10 per page
      @active_jobs = Job.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_jobs = Job.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end
  
    def show
        @name = @job.name
    end

    def new
        @job = Job.new
      end
    
    def edit
    end

    def create
        @job = Job.new(job_params)
        if @job.save
          redirect_to @job, notice: "Successfully added #{@job.name} job to the system."
        else
          render action: 'new'
        end
    end
    
    def update
        if @job.update_attributes(job_params)
          redirect_to jobs_path, notice: "Updated information for #{@job.name} job."
        else
          render action: 'edit'
        end
    end

    def destroy
        @job.destroy
        redirect_to jobs_path, notice: "Removed job from the system."
      end

    private
  # Use callbacks to share common setup or constraints between actions.
    def set_job
        @job = Job.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
        params.require(:job).permit(:name, :active)
    end
end