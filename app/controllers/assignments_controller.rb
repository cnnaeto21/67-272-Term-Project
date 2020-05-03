class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :terminate, :destroy]
  before_action :check_login
  authorize_resource

  def index
    # for phase 3 only
      if current_user.role?(:employee)
        curr = [current_user.current_assignment]
        #@current_assignments = curr.paginate unless curr.nil?
        @current_assignments = curr.paginate
        past = current_user.assignments.chronological - curr
        @past_assignments = past.paginate
      elsif current_user.role?(:manager)
        @current_assignments = Assignment.for_store(current_user.current_assignment.store).current.chronological.paginate(page: params[:page]).per_page(10)
        @past_assignments = Assignment.for_store(current_user.current_assignment.store).past.chronological.paginate(page: params[:page]).per_page(10)
      else
        @current_assignments = Assignment.current.chronological.paginate(page: params[:page]).per_page(10)
        @past_assignments = Assignment.past.chronological.paginate(page: params[:page]).per_page(10)
      end
  end

  def show
    @completed_shifts = @assignment.shifts.completed.chronological.paginate(page: params[:page]).per_page(10)
    @pending_shifts = @assignment.shifts.pending.chronological.paginate(page: params[:page]).per_page(10)
  end

  def new
    @assignment = Assignment.new
    @assignment.employee_id = params[:employee_id] unless params[:employee_id].nil?
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to assignments_path, notice: "Successfully added the assignment."
    else
      render action: 'new'
    end
  end

  def terminate
    if @assignment.terminate
      redirect_to assignments_path, notice: "Assignment for #{@assignment.employee.proper_name} terminated."
    end
  end

  def destroy
    @assignment.destroy
    redirect_to assignments_path, notice: "Removed assignment from the system."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assignment_params
    params.require(:assignment).permit(:store_id, :employee_id, :start_date, :pay_grade_id)
  end

end

