class VisitorsController < ApplicationController
  def index
    @most_recent_calls = current_user.calls.most_recent
    render 'pages/home' unless user_signed_in?
  end
end
