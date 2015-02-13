module PasswordManager
  def service_password_reset(token, username, new_password)
    clear_old_requests

    if reset_request_exists?(token, username)
      stored_request = PasswordResetRequest.find_by(:token => token, :username => username)
      return update_user_password(username, new_password)
    else
      return 1
    end
  end

  def clear_old_requests
    PasswordResetRequest.where(
      "created < :created", :created => 20.minute.ago
    ).destroy_all
  end

  def reset_request_exists?(token, username)
    PasswordResetRequest.find_by(:token => token, :username => username)
  end

  def update_user_password(username, password)
    new_salt = BCrypt::Engine.generate_salt
    new_hash = BCrypt::Engine.hash_secret(password, new_salt)

    User.find_by(:username => username).update({
      :salt_new => new_salt,
      :hash_new => new_hash
    })

    PasswordResetRequest.where(:username => username).destroy_all
    return 0
  end
end