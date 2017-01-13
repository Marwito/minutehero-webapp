class VisitorsController < ApplicationController
  def index
    if user_signed_in?
      @most_recent_calls = current_user.calls.most_recent
    else
      render 'pages/home'
    end
  end
end
