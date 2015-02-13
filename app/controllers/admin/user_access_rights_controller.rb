class Admin::UserAccessRightsController < AdminController
  def update
    permissions = {}

    request.POST["permissions"].each do |name, item|
      permissions[name] = item == "true" ? 1 : 0
    end

    access_right = UserAccessRight.find_by(:user_id => params[:id])
    access_right.update(permissions)

    render :json => {:status => access_right.update(permissions)}
  end
end
