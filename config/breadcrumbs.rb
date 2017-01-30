crumb :root do
  link "Dashboard", root_path
end

crumb :calls do
  link "Calls", calls_path
end

crumb :call do |call|
  if call.persisted?
    link call.title, call_path(call)
  else
    link 'New Call'
  end
  parent :calls
end

crumb :users do
  link "Users", users_path
end

crumb :user do |user|
  link user.name, user_path(user)
  parent :users
end

crumb :pages do
  link params[:id].titleize
end

crumb :devise do
  link "#{params[:action].titleize} #{params[:controller].split('/').last.titleize}"
end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).