class AdminController < ApplicationController
  http_basic_authenticate_with name: "jnc", password: "vlrigwt"
  before_filter :authorized?
  layout 'admin'

  def authorized?
    unless ["127.0.0.1", "213.120.101.76"].include? request.remote_ip
      render :text => "You shall not pass." and return
    end
  end
end
