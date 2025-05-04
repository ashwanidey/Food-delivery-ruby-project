class UserLoginJob < ApplicationJob
  queue_as :default

  def perform(to,subject,body)
    
    UserMailer.welcome_email(to,subject,body).deliver_later(wait: 10.seconds)
  end
end
