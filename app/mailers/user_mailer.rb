class UserMailer < ApplicationMailer
 

  def welcome_email(to,subject,body)
    
    mail(to: to, subject: subject,body: body)
  end
end