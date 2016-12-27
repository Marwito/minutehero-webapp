user = User.find_or_create_by!(email: ENV['admin_email']) do |u|
  u.password = Rails.application.secrets.admin_password
  u.password_confirmation = Rails.application.secrets.admin_password
  u.confirm
  u.admin!
end

puts 'CREATED ADMIN USER: ' << user.email
