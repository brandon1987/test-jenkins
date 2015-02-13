class UsersController < ApplicationController
  def show
    @user = User.where(id: params[:id], xid_company: session[:company_id]).first

    unless @user
      redirect_to "/404.html" and return
    end

    #@access_rights = UserAccessRight.find_by(:user_id => params[:id])
  end

  def destroy
    user = User.find(params[:id])

    if session[:company_id] != user.xid_company
      render :json => {:status => 1, :message => "Insufficient privileges to delete user."}
      return
    end

    if session[:priv_level] <= user.priv_level
      render :json => {:status => 1, :message => "Insufficient privileges to delete user."}
      return
    end

    # Delete user mail preferences, if they exist
    mail_preferences = UserMailPreference.where(:id => params[:id])
    mail_preferences.destroy_all unless mail_preferences.empty?

    success = user.destroy

    render :json => {:status => success}
  end
end
