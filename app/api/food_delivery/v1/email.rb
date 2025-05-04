module FoodDelivery
  module V1
    class Email < Grape::API
      helpers EmailHelper
      format :json

      resource "/email" do

        desc "Send email"
        params do
          requires :to, type: String, desc: "Recipient email address"
          requires :subject, type: String, desc: "Recipient email address"
          requires :body, type: String, desc: "Recipient email address"
        end
        post "/send_email" do
          puts params[:to]
          user = User.find_by(email: params[:to])
          puts "user : #{user}"
          error!('User not found', 404) unless user

          UserLoginJob.perform_now(params[:to], params[:subject], params[:body])
          { message: 'Email sent successfully' }
         
        end
      end
    end
  end
end