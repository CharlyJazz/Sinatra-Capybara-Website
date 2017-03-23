module ActionHerlpers
  def action_login
    visit '/auth/'
    within("form#login") do
      fill_in 'email', with: 'charlyjazzc1@gmail.com'
      fill_in 'password', with: 'password'
    end
    submit_form
  end
end