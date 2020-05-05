require 'will_paginate/array'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to take this action. Contact administrator for more details. "
    redirect_to home_path
  end

  # handle 404 errors with an exception as well
  rescue_from ActiveRecord::RecordNotFound do |exception|
    # consider creating your own 404 page within home and redirecting there...
    flash[:error] = "404 Error... the page you are searching for does not exist"
    redirect_to home_path
  end
  private
  # Handling authentication
  def current_user
    @current_user ||= Employee.find(session[:emp_id]) if session[:emp_id]
  end
  helper_method :current_user
  
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  
  def check_login
    redirect_to login_path, alert: "You need to log in to view this page." if current_user.nil?
  end
end
