class UserMailer < ActionMailer::Base
  default from: "Construction Manager <noreply@constructionmanager.net>"

  def password_reset_email(user, token)
    @user  = user

    @url  = "https://constructionmanager.net/reset_password/#{token}"

    mail(to: @user.username, subject: 'Your password reset link')
  end
end
