class NotificationPriority < ActiveRecord::Migration
  def change
    add_column :user_notification_opt_ins, :priority, :integer, default:3
  end
end
