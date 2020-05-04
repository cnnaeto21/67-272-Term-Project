class HomeController < ApplicationController
  def index
    @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def about
  end

  def contact
    @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def privacy
  end

  def employee
    @upcoming_shifts = Shift.for_employee(current_user).upcoming.pending.chronological.paginate(page: params[:page]).per_page(5)
    @upcoming_shifts.reload
    @upcoming_shifts.reload

    @started_shifts = Shift.for_employee(current_user).upcoming.started.chronological.paginate(page: params[:page]).per_page(5)
    @started_shifts.reload
    @started_shifts.reload

    emp = current_user
    date_range = DateRange.new(7.days.ago.to_date)
    calc = PayrollCalculator.new(date_range)
    @payroll = [calc.create_payroll_record_for(emp)].paginate
  end

  def admin
    @stores = Store.all.alphabetical
  end

  def manager 
    @completed_shifts = Shift.for_store(current_user.current_assignment.store).incomplete.finished.chronological.paginate(page: params[:page]).per_page(5)
    @upcoming_shifts = Shift.for_store(current_user.current_assignment.store).upcoming.for_next_days(7).chronological.paginate(page: params[:page]).per_page(5)
    @missed_shifts = Shift.for_store(current_user.current_assignment.store).past.pending.paginate(page: params[:page]).per_page(5)
  end


  def search 
    redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    if current_user.role?(:manager) && !current_user.current_assignment.nil?
      @employees = current_user.current_assignment.store.employees.search(@query).alphabetical
    else
      @employees = Employee.search(@query).alphabetical
    end
    @total_hits = @employees.size 
  end
  
end