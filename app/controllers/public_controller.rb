include PasswordManager

class PublicController < ApplicationController
  def termsandconditions;end

  def privacypolicy;end

  def passwordreset;end



  def reset_password
    @token = params[:token]
  end

  def service_password_reset
    success = PasswordManager::service_password_reset(
      params[:token],
      params[:username],
      params[:password])

    render :json => {:status => success}
  end
end