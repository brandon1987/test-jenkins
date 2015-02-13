module NotificationHelper
	def add_notification_internal(notification_type,notification_text,notification_url)
		notification_recipients=UserNotificationOptIns.where(:notification_type=>notification_type)

		notification_recipients.each do |recipient|
			notification=UserNotifications.new()
			notification.user_id=recipient.user_id
			notification.notification_type=notification_type
			notification.notification_text=notification_text
			notification.notification_url=notification_url
			notification.notification_priority=recipient.priority
			notification.save()
		end
		return true		
	end
end