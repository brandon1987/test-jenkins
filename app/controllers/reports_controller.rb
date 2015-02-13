include AmazonStorage

class ReportsController < ApplicationController
  def index
    @reports = JSON.parse(getAmazonFileList("reports"))
    @default_report = CompanyPreferences.first.default_quote_template
  end

  def destroy
    deleteAmazonFile("reports/", "#{params[:filename]}.mrt")
    render :json => { :success => true }
  rescue StandardError => msg
    render :json => { :success => false }
  end

  def set_default
    filename = "#{params[:filename]}.mrt"
    CompanyPreferences.first.update(default_quote_template: filename)
    render :json => { :success => true }
  end

  def show
    database_string  = "Server=#{session[:userdb_host]};"
    database_string << "Port=#{session[:userdb_port]};"
    database_string << "Database=#{session[:userdb_db]};"
    database_string << "User=#{session[:userdb_user]};"
    database_string << "Password=#{session[:userdb_pass]}"

    if Rails.env == "production"
      url = "http://reports.constructionmanager.net/api/view.php?"
    else
      url = "http://localhost/cm-services/reports/stimulsoft/api/view.php?"
    end

    url << "companyID=#{params[:companyID]}"
    url << "&filename=#{Base64.decode64(params[:filename])}"
    url << "&QuoteID=#{params[:QuoteID]}"
    url << "&db=#{Base64.encode64(database_string)}"

    redirect_to url
  end

  def create
    saveAmazonFile("reports/", params[:report].original_filename, params[:report].read)
  rescue StandardError => msg
    flash[:upload_error] = msg
  ensure
    redirect_to :back
  end
end
