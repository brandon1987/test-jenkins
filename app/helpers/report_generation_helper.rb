module ReportGenerationHelper
  def get_body_with_replacements(body)
    contact_name = @quote.customer.contact_name
    company_name = @quote.customer.name
    body.gsub!("%CONTACT_NAME%", contact_name)
    body.gsub!("%COMPANY_NAME%", company_name)
    return body
  end

  def get_xml_from_reports_system(filename)
    #url  = "http://localhost/cm-services/reports/stimulsoft/api/"
    url  = "http://reports.constructionmanager.net/api/"
    url << "get_xml.php?companyID=#{session[:company_id]}&filename=#{filename}"

    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    
    return res.body
  end
end