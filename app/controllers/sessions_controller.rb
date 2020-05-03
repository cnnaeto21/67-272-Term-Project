class SessionsController < ApplicationController
    def new
    end
    
    def create
      emp = Employee.authenticate(params[:username], params[:password])
      if emp
        session[:emp_id] = emp.id
        if current_user.role?(:employee)
            redirect_to employee_home_path, notice: "Logged in!"
        elsif current_user.role?(:admin)
            redirect_to admin_home_path, notice: "Logged in!"
        elsif current_user.role?(:manager)
            redirect_to manager_home_path, notice: "Logged in!"
        else
            redirect_to home_path, notice: "Logged in!"
        end
      else
        flash.now.alert = "Username and/or password is invalid"
        render "new"
      end
    end
    
    def destroy
      session[:emp_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end
end