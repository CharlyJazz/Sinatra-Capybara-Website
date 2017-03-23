require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Website' do
  def app
    AuthController
  end

  describe "\ntry register with dates used,\n # login,\n # change password process:", :type => :feature do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_wait_time = 5
      before_create_user
    end

    # it "when register" do
    #   visit 'http://127.0.0.1:8000/auth/register'
    #   within("form#form__register") do
    #     fill_in 'username', with: Forgery(:internet).user_name
    #     fill_in 'email', with: Forgery(:email).address
    #     fill_in 'password', with: Forgery(:basic).password
    #     fill_in 'recover_password', with: Forgery(:lorem_ipsum).words(5)     
    #   end
    #   submit_form
    #   expect(page).to have_content 'User successfully signed!'
    #   page.has_selector?('form#form__register')
    # end

    # it "when login" do
    #   visit 'http://127.0.0.1:8000/auth/'
    #   within("form#login") do
    #     fill_in 'email', with: 'charlyjazzc1@gmail.com'
    #     fill_in 'password', with: 'password'
    #   end
    #   submit_form
    #   expect(page).to have_content 'User successfully logged'
    #   page.has_selector?('form#login')
    # end

    # it "when change password" do
    #   visit 'http://127.0.0.1:8000/auth/change_password'
    #   within("form#form__change__password") do
    #     fill_in 'recover_password', with: 'secret'
    #     fill_in 'password_new', with: '_password'
    #     fill_in 'password_old', with: 'password'
    #   end
    #   submit_form
    #   expect(page).to have_content 'Your secret is correct, your password changed'
    #   page.has_selector?('form#form__change__password')
    # end

    # it "when setting personal info" do
    #   action_login
      
    #   click_link('charlytester')
    #   click_link('Setting')
    #   within("form#setting-form-personal") do
    #     fill_in 'display_name', with: Forgery(:lorem_ipsum).word
    #     fill_in 'first_name', with: Forgery(:name).first_name
    #     fill_in 'last_name', with: Forgery(:name).last_name
    #     fill_in 'country', with: Forgery(:address).country
    #     fill_in 'city', with: Forgery(:address).city
    #     fill_in 'bio', with: Forgery(:lorem_ipsum).words(5)        
    #   end
    #   submit_form
    #   expect(page).to have_content 'New personal information!'
    # end

    it "when setting social info" do
      action_login
      
      click_link('charlytester')
      click_link('Setting')
      click_link('Social')
      within("form#setting-form-social") do
        4.times do | x |
          find(:css, 'i.add-social-field.material-icons').click
          if x == 4 - 1 then find(:css, 'a.remove-4').click end
        end
        4.times do | x |
          fill_in "social_url[#{x + 1}]", with: "https://webpage.com/" + Forgery(:internet).user_name
          fill_in "social_name[#{x + 1}]", with: Forgery(:lorem_ipsum).word
        end
      end
      submit_form
      expect(page).to have_content 'New social information!'
    end

  end

end