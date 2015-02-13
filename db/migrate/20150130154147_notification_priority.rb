class NotificationPriority < ActiveRecord::Migration
  def change
    if self.table_exists?("user_notification_opt_ins")
      add_column :user_notification_opt_ins, :priority, :integer, default:3
    end
  end
end
