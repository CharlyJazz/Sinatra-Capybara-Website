module ActionHerlpers
  def action_login(email, password)
    visit '/auth/'
    within("form#login") do
      fill_in 'email', with: email
      fill_in 'password', with: password
    end
    submit_form
  end
end