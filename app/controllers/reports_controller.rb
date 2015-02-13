class ReportsController < ApplicationController
  def index;end

  def destroy
    filename = "#{params[:filename]}.mrt"
    Report.delete_all(:filename => filename)
    render :json => { :status => 0 }
  end

  def set_default
    filename = "#{params[:filename]}.mrt"
    Report.find_by(:filename => filename).make_default
    render :json => { :status => 0 }
  end
end
