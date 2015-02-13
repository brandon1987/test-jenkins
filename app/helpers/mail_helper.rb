module MailHelper
  def quote_to_recipients
    begin
      mail_preferences = UserMailPreference.find(session[:user_id]) 
    rescue StandardError => e
      mail_preferences = UserMailPreference.new
    end

    recipients = []

    if mail_preferences.quotes_to_1 == 1
      recipients << @quote.customer.email
    end

    if mail_preferences.quotes_to_2 == 1
      recipients << @quote.customer.email2
    end

    if mail_preferences.quotes_to_3 == 1
      recipients << @quote.customer.email3
    end

    recipients.join(", ")
  end

  def quote_cc_recipients
    begin
      mail_preferences = UserMailPreference.find(session[:user_id]) 
    rescue StandardError => e
      mail_preferences = UserMailPreference.new
    end

    mail_preferences.quotes_cc
  end

  def quote_bcc_recipients
    begin
      mail_preferences = UserMailPreference.find(session[:user_id]) 
    rescue StandardError => e
      mail_preferences = UserMailPreference.new
    end

    mail_preferences.quotes_bcc
  end

  def store_password_reset_request(reset_code, recipient)
    reset_request = PasswordResetRequest.new({
      :token    => reset_code,
      :username => recipient,
      :created  => DateTime.now
      })

    return reset_request.save
  end
end