user = User.find_or_create_by!(email: ENV['admin_email']) do |u|
  u.first_name = 'Admin'
  u.last_name = 'User'
  u.password = Rails.application.secrets.admin_password
  u.password_confirmation = Rails.application.secrets.admin_password
  u.admin!
  u.confirm
end

puts 'CREATED ADMIN USER: ' << user.email
