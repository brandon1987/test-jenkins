class ServicePlanCorrections < ActiveRecord::Migration
  def change
    add_column(:service_plan_link, :service_plan_start_date, :datetime)      	
    add_column(:service_plan_link, :next_service_date, :datetime)      
    add_column(:service_plan_link, :last_service_date, :datetime)      


    remove_column :service_plans,:service_plan_start_date
    remove_column :service_plans,:next_service_date
    remove_column :service_plans,:last_service_date
  end
end
