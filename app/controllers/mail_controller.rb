include InviteHelper
include MailHelper
include ReportGenerationHelper

class MailController < ApplicationController
  def auto_mail_quote
    @quote = Quote.find(params[:id])

    send_quote(
      quote_to_recipients,
      quote_cc_recipients,
      quote_bcc_recipients,
      "See attached.",
      get_attachment_file(Report.default_report.filename)
    )

    render :json => {:status => 0}
  end

  def mail_quote_from_post
    @quote = Quote.find(params[:id])

    send_quote(
      request.POST["to"],
      request.POST["cc"],
      request.POST["bcc"],
      get_body_with_replacements(request.POST["body"]),
      get_attachment_file(params[:template])
    )

    render :json => {:status => 0}
  end

  def get_attachment_file(filename)
    output_file_token = SecureRandom.hex

    storage_root = Rails.root.join('storage', 'reports')

    tmp_file_name = storage_root.join("#{output_file_token}.mrt")
    out_file_name = storage_root.join("#{output_file_token}.pdf")

    report_xml = get_xml_from_reports_system(filename)

    conn_string  = "<ConnectionString>Server=constructionmanager.net;Port=3306;"
    conn_string << "Database=conmag_#{session[:company_id]};User=conman;"
    conn_string << "Password=D3lux3Moth3rboard;</ConnectionString>"

    report_xml.sub!(/<ConnectionString>.*\n.*<\/ConnectionString>/, conn_string)

    File.open(tmp_file_name, "w+") do |f|
      f.write(report_xml)
    end

    MRTExport.new({
      :report_file   => tmp_file_name.to_s,
      :output_file   => out_file_name.to_s,
      :export_format => "pdf",
      :replacements  => {"QuoteID" => @quote.id.to_s}
    })

    File.delete(tmp_file_name)

    return out_file_name
  end

  def send_quote(to, cc, bcc, body_text, attachment)
    from = session[:company_name]

    ArbitraryMailer.quote_email(
      to,
      from,
      cc,
      bcc,
      attachment
    ).deliver
  end

  def send_invite_link
    recipient = request.POST["address"]

    if !User.where(:username => recipient).empty?
      render :json => {:status => 1, :message => "They're already a member!"}
    else
      new_invite_id = InviteHelper::invite(recipient, session[:username], session[:company_id])
      render :json => {:status => 0, :new_invite_id => new_invite_id}
    end
  end

  def request_password_reset
    recipient = request.POST["username"]

    user = User.find_by(:username => recipient)

    unless user.nil?
      reset_code = SecureRandom.hex
      store_password_reset_request(reset_code, recipient)
      UserMailer.password_reset_email(user, reset_code).deliver
    end

    render :json => {:status => 0}
  end
end