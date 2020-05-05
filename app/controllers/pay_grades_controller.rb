class PayGradesController < ApplicationController
    before_action :set_pay_grade, only: [:show, :edit, :update]
    before_action :check_login
    authorize_resource
  
    def index
      # get data on all pay grades and paginate the output to 10 per page
      @active_grades = PayGrade.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_grades = PayGrade.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end
  
    def show
    end

    def new
        @paygrade = PayGrade.new
      end
    
    def edit
    end

    def create
        @paygrade = PayGrade.new(grade_params)
        if @paygrade.save
          redirect_to pay_grades_path, notice: "Successfully added #{@paygrade.level} pay grade to the system."
        else
          render action: 'new'
        end
    end
    
    def update
        if @paygrade.update_attributes(grade_params)
          redirect_to pay_grades_path, notice: "Updated information for #{@paygrade.level} pay grade."
        else
          render action: 'edit'
        end
    end

    private
  # Use callbacks to share common setup or constraints between actions.
    def set_pay_grade
        @paygrade = PayGrade.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def grade_params
        params.require(:pay_grade).permit(:level, :active)
    end
end
  