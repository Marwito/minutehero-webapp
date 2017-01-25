module CallsHelper
  def default_country
    if current_user.country.blank?
      Country::DEFAULT_ALPHA_CODE
    else
      current_user.country
    end
  end
end
