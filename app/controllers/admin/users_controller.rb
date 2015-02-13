include LoginHelper

class Admin::UsersController < AdminController
  def index
    @users = User.includes(:company).all
  end

  def view
    @user = User.find(params[:id])
    @company = Company.find(@user.xid_company)

    #@access_rights = get_user_access_rights_json#.to_json.html_safe
  end

  def create
    new_salt = BCrypt::Engine.generate_salt
    new_hash = BCrypt::Engine.hash_secret("CHANGEME#{params[:username]}", new_salt)

    User.new({
      :username        => params[:username],
      :xid_company     => params[:company_id],
      :salt_new        => new_salt,
      :hash_new        => new_hash,
      :priv_level      => 3
    }).save

    redirect_to "/admin/companies/#{params[:company_id]}"
  end

  def invite
    recipient = params[:username]

    if User.where(:username => recipient).empty?
      new_invite_id = InviteHelper::invite(recipient, "", params[:company_id])
    end

    redirect_to("/admin/companies/#{params[:company_id]}")
  end

  def revoke_invite
    Invite.find(params[:id]).destroy
    redirect_to request.referer
  end

  def show
    @user = User.find(params[:id])
    @company = Company.find(@user.xid_company)
    #@access_rights = get_user_access_rights
  end

  def take_over
    @user = User.find(params[:id])
    set_up_session
    session[:hijacked_session] = true
    redirect_to("/welcome")
  end

  private
  def get_user_access_rights_json
    result = {}
    get_user_access_rights.attributes.each do |name, value|
      result[name] = value
    end
    return result
  end

  def get_user_access_rights
    if UserAccessRight.find_by(:user_id => params[:id]).nil?
      access_rights = UserAccessRight.new({:user_id => params[:id]})
      access_rights.save
      return access_rights
    else
      access_rights = UserAccessRight.find_by(:user_id => params[:id])
      return access_rights
    end
  end
end