include LoginHelper

class LoginController < ApplicationController

  skip_before_action :verify_authenticity_token ##prevents caching fucking up the auth token

  def index
    if not session[:username].nil?
      redirect_to "/welcome"
    end
  end

  def check
    username = params["username"]
    password = params["password"]

    @user = User.where("lower(username) = ?", username.downcase).first

    respond_to do |format|
      if @user.nil?
        format.html {render :json => {"error" => "Invalid username or password."}}
      else
        if @user.hash_new == BCrypt::Engine.hash_secret(password, @user.salt_new) then
          set_up_session
          Apartment::Tenant.switch("conmag_#{session[:company_id]}")
          format.html {render :json => {"success" => "Valid credentials."}}
        else
          format.html {render :json => {"error" => "Invalid username or password."}}
        end
      end
    end
  end

  def logout
    reset_session
    redirect_to "/login"
  end

  def process_invite
    @code = params[:code]

    @invite = Invite.find_by(invite_code: @code)

    if @invite.nil? then
      render :text => "Invalid invite code."
    end
  end

  def sign_up
    invite = Invite.find_by(invite_code: request.POST["code"])

    if invite.nil? then
      render :json => {:success => false, :message => "Invalid invite code."}
    else
      username = request.POST["username"]
      password = request.POST["password"]

      new_salt = BCrypt::Engine.generate_salt
      new_hash = BCrypt::Engine.hash_secret(password, new_salt)

      params = {
        :username        => username,
        :xid_company     => invite.company_id,
        :salt_new        => new_salt,
        :hash_new        => new_hash,
        :priv_level      => 3
      }

      if User.new(params).save
        render :json => { :success => true }
        invite.destroy
      else
        render :json => { :success => false }
      end
    end
  end
end