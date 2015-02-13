include NotificationHelper

class UserNotificationsController < ApplicationController
	def delete_notification
		UserNotifications.destroy(params[:id])
	    render :json => {:success =>true}

	end
	def delete_notification_all
		UserNotifications.where(:user_id=>session[:user_id]).destroy_all
	    render :json => {:success =>true}
	end	





	def add_notification
		if add_notification_internal(params[:notificationtype],params[:notificationtext], params[:notification_url])
	    	render :json => {:success =>true} 
	    else
	    	render :json => {:success =>false} 
	   	end
	end
end