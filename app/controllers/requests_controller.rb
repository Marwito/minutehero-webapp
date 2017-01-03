class RequestsController < ApplicationController
  # POST /requests
  def create
    @request = Request.new(request_params)

    if @request.save
      RequestMailer.create(@request).deliver
      redirect_to root_path, notice: 'Request was successfully sent.'
    end
  end

  private

  def request_params
    params.require(:request).permit(:from, :subject, :content)
  end
end
