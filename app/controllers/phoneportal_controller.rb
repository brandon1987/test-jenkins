class PhoneportalController < ApplicationController

  	layout 'phoneportal'

	def connect_as_tenant
		set_tenant_db

		unless params[:controller] == "settings" or params[:action] == "logout"
			#We don't currently need the sage connection working for the mobile data connection.
			#If we needed to make sage transactions from the phone in the future we could reenable this
			#if !sage_connection_working?
			#  redirect_to '/settings#database-settings-tab', :flash => { :error => :no_sage }
			#  return false
			#end
			if !set_remote_db
				redirect_to '/settings#database-settings-tab', :flash => { :error => :no_db }
				return false
			end
		end
	end


end