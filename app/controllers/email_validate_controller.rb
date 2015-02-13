class EmailValidateController < ApplicationController
	def validate_email
		databaseModel=Object.const_get params[:recordtype]
		email=databaseModel.find(params[:recordid])[params[:fieldname]]

		if email.strip=="" || email.nil?
			render :text => false 
		else
			if !email.email?
				render :text =>  false
			else
				render :text =>  email.strip
			end	
		end
	end

	def validate_email_arbitrary

		if params[:email].strip=="" || params[:email].nil?
			render :text => false 
		else
			if !params[:email].email?
				render :text =>  false
			else
				render :text =>  true
			end				
		end
	end

end