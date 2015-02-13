class ArbitraryMailer < ActionMailer::Base
  default from: "Constructionmanager.net<noreply@constructionmanager.net>"

  def invite_email(address, from, invite_code)
    @url  = "https://constructionmanager.net/accept_invite/#{invite_code}"
    @from = from

    mail(to: address, subject: 'Your Construction Manager invitation!')
  end

  def quote_email(to, from, cc, bcc, attachment)
    attachments["quote.pdf"] = File.read(attachment)
    mail(
      to:      to,
      cc:      cc,
      bcc:     bcc,
      subject: "Your quote from #{from}")
  end

  def client_portal_password(company_id,to,customerid,invite_code)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logoforemail.png")

    company=Company.find(company_id)
    @companyname=company.display_name
    @invite_code=invite_code
    customer=Customer.find(customerid)
    @customername=customer.name
    @messagetype="Client Portal Invitation"
    

    mail(to: customer.clientportal_email, subject: 'Construction Manager Client Portal Details')    
  end

  def client_portal_password_reset(company_id,to,customerid,invite_code)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logoforemail.png")

    company=Company.find(company_id)
    @companyname=company.display_name
    @invite_code=invite_code
    customer=Customer.find(customerid)
    @customername=customer.name
    @messagetype="Client Portal password reset"
    
    mail(to: customer.clientportal_email, subject: 'Construction Manager Client Portal Password Reset')    
  end

  def client_portal_registration_confirm(company_id,customer_id)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logoforemail.png")

    company=Company.find(company_id)
    @companyname=company.display_name
    @companyref=company.login_name

    customer=Customer.find(customer_id)
    @customername=customer.name    
    @customerusername=customer.clientportal_username
    mail(to: customer.clientportal_email, subject: 'Construction Manager Client Portal Signup Complete')  
  end

  def error_email(error)
    @error = error

    mail(to: "james.srn@gmail.com", subject: "Construction Manager Debug")
  end
end
