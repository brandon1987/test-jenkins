class UserNotificationTable < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.integer :user_id, :default => -1    	
      t.string  :notification_type, :limit => 50, :default => ""
      t.text  :notification_text
      t.integer :notification_priority, :default => 1
    end  	
  end
end
