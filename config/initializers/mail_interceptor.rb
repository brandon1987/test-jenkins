class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['richard@jnc-uk.com']
  end
end

ActionMailer::Base.register_interceptor(SandboxEmailInterceptor) if Rails.env.development?