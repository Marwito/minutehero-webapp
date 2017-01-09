class VisitorsController < ApplicationController
  def index
    render 'pages/home' unless user_signed_in?
  end
end
