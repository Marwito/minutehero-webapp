module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in '* First Name', with: 'Juan'
      fill_in '* Last Name', with: 'Perro'
      fill_in '* Email', with: email
      fill_in '* Password', with: password
      find(:css, '.custom-control-indicator').trigger('click')
      click_button 'Sign up'
    end

    def signin(email, password)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end
  end
end
