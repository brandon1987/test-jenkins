class UserAccessRightsController < ActionController::Base
  def update
    permissions = {}

    request.POST["permissions"].each do |name, item|
      permissions[name] = item == "true" ? 1 : 0
    end

    access_right = UserAccessRight.find_by(:user_id => params[:id])
    access_right.update(permissions)
	reload_access_rights()
    render :json => {:status => access_right.update(permissions)}

  end

  def reload_access_rights()

    session[:access_rights] =UserAccessRight.where(user_id: session[:user_id]).first.to_json
    puts session[:access_rights]
  end

end
