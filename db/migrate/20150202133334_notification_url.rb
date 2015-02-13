class NotificationUrl < ActiveRecord::Migration
  def change
    if self.table_exists?("user_notifications")
      add_column :user_notifications, :notification_url, :text
      add_column(:user_notifications, :created_at, :datetime)
      add_column(:user_notifications, :updated_at, :datetime)
    end
  end
end
