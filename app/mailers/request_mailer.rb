class RequestMailer < ApplicationMailer
  def create(request_id)
    @request = Request.find request_id
    mail(to: [@request.from, ENV['admin_email']], subject: "[REQUEST] #{@request.subject}")
  end
end
