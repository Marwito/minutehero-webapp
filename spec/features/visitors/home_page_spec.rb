# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Redirection to the sign-in page' do
  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I access the website, i will be asked to sign in or sign up
  #   Then I will see "sign in"
  scenario 'visit the sign_in page' do
    visit root_path
    expect(page).to have_content 'sign in'
  end
end
