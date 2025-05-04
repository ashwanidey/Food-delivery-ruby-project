module EmailHelper

 

  def send_email(to, subject, body) 
    UserMailer.welcome_email(to, subject, body).deliver_now
  end

 
end