class UserNotificationOptions < ActiveRecord::Migration
  def change  
    create_table :user_notification_opt_ins do |t|
      t.integer :user_id, :default => -1    	
      t.string  :notification_type, :limit => 50, :default => ""
    end
  end
end
