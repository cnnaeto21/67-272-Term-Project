class Ability
    include CanCan::Ability

    def initialize(employee)
        employee ||= Employee.new


        if employee.role? :admin
            can :manage, :all

        elsif employee.role? :manager
            can :manage, Shift
            can :manage, ShiftJob
            can :index, Store
            # can show their own store 
            can :show, Store do |this_store|  
                employee.current_assignment.store_id == this_store.id
            end

            can :index, Employee
            can :show, Employee do |this_emp|
                this_emp.current_assignment.store_id == employee.current_assignment.store_id
            end
            can :edit, Employee do |this_emp|
                this_emp.current_assignment.store_id == employee.current_assignment.store_id
            end 
            can :update, Employee do |this_emp|
                this_emp.current_assignment.store_id == employee.current_assignment.store_id
            end 

            can :index, Assignment
            can :show, Assignment do |curr|
                curr.store_id == employee.current_assignment.store_id
            end 
        
        elsif employee.role? :employee
            can :index, Assignment
            can :show, Assignment do |curr|
                curr.id == employee.current_assignment.id
            end 
            can :show, Employee do |this_emp|
                this_emp.id == employee.id
            end 

            can :edit, Employee do |this_emp|
                this_emp.id == employee.id 
            end

            can :update, Employee do |this_emp|
                this_emp.id == employee.id 
            end
        else 
            can :read, :all
        end 
    end 
end 