include LoginHelper
include BCrypt

class ClientportalController < ApplicationController

  	layout 'clientportal'
	def index
	end

	def register
		invite=InviteCode.where(:invite_code => params[:invite]).first
		if invite
			set_up_clientportal_session(invite.company_id)
			customer_record=Customer.find(invite.secret1)

			checkusername=Customer.where( "clientportal_username=? and id!=?",params[:username],customer_record.id).all
			if checkusername.count==0
			    new_hash = Password.create(params[:password])
				customer_record.update(client_portal_password: new_hash,clientportal_username: params[:username] )
				InviteCode.destroy(invite.id)
				ArbitraryMailer.client_portal_registration_confirm(session[:company_id],customer_record.id).deliver
				reset_session
				render :text => "ok"
			else
				reset_session
				render :text => "This username is already in use. Please choose another and try again."

			end
		else 
			reset_session
			render :text =>"This invite code has already been used, please contact your contractor for a new invite."
		end


	end

	def home

	end

	def login 
		company = Company.find_by login_name:params[:company]
		if company
			set_up_clientportal_session(company.id)			
			customer=Customer.find_by clientportal_username:params[:username]
				if customer

		    		if check_password(customer.client_portal_password,params[:password])
		    			#SUCCESSFUL LOGIN
		    			session[:customer_id] = customer.id
		    			remotecustomer=DesktopCustomer.find(customer.link_id)

		    			if remotecustomer

			    			session[:remotecustomer_id]=remotecustomer.id
			    			session[:remotecustomer_ref]=remotecustomer.ref
			    			session[:clientportal_access]=[]
			    			session[:clientportal_access]<<"maintenance_visits" if customer.is_portal_maintenance
			    			session[:clientportal_access]<<"maintenance_tasks" if customer.is_portal_maintenancetasks

	    					render :json => {:success =>true}		    			

			    			return
			    		else
			    			reset_session
			    			 #fail out as could not find the remote customer record
    						render :json => {:success =>false}		    			

		    				return
			    		end
		    		else
		    			reset_session
		    			#FAILED LOGIN
    					render :json => {:success =>false}		    			

		    			return
		    		end
				end
		end
		render :json => {:success =>false}		    			

	end


	def logout
	reset_session
	 redirect_to "/clientportal"

	end


	def check_password(encrypted,plaintext)
		hash=Password.new(encrypted)
	    if hash == plaintext
	       return true
	    else
	       return false
	    end 
	end

	def passwordreset
	end
	def resetpassword
	end


	def resetpassword_process
		invite=InviteCode.where(:invite_code => params[:request]).first
		if invite
			set_up_clientportal_session(invite.company_id)
			customer_record=Customer.find(invite.secret1)
		    new_hash = Password.create(params[:password])
			customer_record.update(client_portal_password: new_hash )
			InviteCode.destroy(invite.id)
			reset_session
			render :text => "ok"
		else 
			reset_session
			render :text =>"no"
		end		
	end

	def request_password_reset
		company = Company.find_by login_name:params[:companyref]
		if company
			set_up_clientportal_session(company.id)			
			customer=Customer.find_by clientportal_username:params[:username]
			if customer
    			invite_code= InviteCodeHelper.invite(customer.email, company.id,customer.id,0,0)				
				ArbitraryMailer.client_portal_password_reset(company.id,customer.email,customer.id,invite_code).deliver
			end
		end

		render :json => {:status => 0}
	end






end
