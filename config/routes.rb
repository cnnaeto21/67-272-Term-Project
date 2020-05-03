Rails.application.routes.draw do

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  get 'home/employee', to: 'home#employee', as: :employee_home
  get 'home/admin', to: 'home#admin', as: :admin_home
  get 'home/manager', to: 'home#manager', as: :manager_home
  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :sessions
  resources :employees
  get 'employees/new', to: 'employee#new', as: :signup
  get 'employee/edit', to: 'employees#edit', as: :edit_current_employee

  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :stores

  resources :assignments
  resources :shifts
  resources :payrolls
  get 'pay_roll', to: 'payrolls#store_pay_form', as: :store_payroll
  get 'payrolls', to: 'payrolls#store_calc', as: :store_calc

  get 'employees/:id/payroll', to: 'payroll#emp_pay', as: :emp_pay


  resources :pay_grades
  resources :pay_grade_rates
  resources :jobs
  resources :shift_jobs

  # Custom routes
  patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment
  patch 'shifts/:id/start', to: 'shifts#start', as: :start_shift
  patch 'shifts/:id/end', to: 'shifts#end', as: :end_shift

  # You can have the root of your site routed with 'root'
  root 'home#index'
end
