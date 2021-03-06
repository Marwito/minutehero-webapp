user = User.find_or_create_by!(email: ENV['admin_email']) do |u|
  u.first_name = 'Admin'
  u.last_name = 'User'
  u.password = Rails.application.secrets.admin_password
  u.password_confirmation = Rails.application.secrets.admin_password
  u.country = Country::DEFAULT_ALPHA_CODE
  u.admin!
  u.confirm
end

puts 'CREATED ADMIN USER: ' << user.email

['free', 'Pay as you go', 'Subscription 30',
 'Subscription 60', 'Subscription 100'].each do |name|
  Product.find_or_create_by! name: name
end

puts 'CREATED PRODUCTS'
