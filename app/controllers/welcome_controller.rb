class WelcomeController < ApplicationController
  def index
    check_browser
    check_desktop_version
  end

  def check_browser
    browser = Browser.new(:ua => request.env["HTTP_USER_AGENT"])

    if browser.ie? && browser.version.to_i < 10
      flash[:browser_warning] = true
    end
  end

  def check_desktop_version
    day, month, year = DesktopDefault.get(:tblCDefaults_DatabaseDate).split("/")

    required_date = Date.new(2014,9,17)
    current_date = Date.new(year.to_i, month.to_i, day.to_i)

    if current_date < required_date
      flash[:version_warning]  = true
      flash[:version]          = current_date.strftime("%d/%m/%Y")
      flash[:required_version] = required_date.strftime("%d/%m/%Y")
    end
  end
end
