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
      user = {:username => "charlytester", 
              :email => "charlyjazzc1@gmail.com",
              :password => "password",
              :recover_password => "secret"}
      @user = User.create(user)
      @user.user_media = UserMedia.create
      @user.user_information = UserInformation.create
      @user.save
      @user.user_media.save
      @user.user_information.save
    end

    it "when register" do
      # This test is for a fail register
      visit 'http://127.0.0.1:8000/auth/register'
      within("form#form__register") do
        fill_in 'username', with: 'charlytester'
        fill_in 'email', with: 'charlyjazzc1@gmail.com'
        fill_in 'password', with: 'password'
        fill_in 'recover_password', with: 'secret'
      end
      submit_form
      expect(page).to have_content 'This username are existing'
      page.has_selector?('form#form__register')
    end

    it "when login" do
      visit 'http://127.0.0.1:8000/auth/'
      within("form#login") do
        fill_in 'email', with: 'charlyjazzc1@gmail.com'
        fill_in 'password', with: 'password'
      end
      submit_form
      expect(page).to have_content 'User successfully logged'
      page.has_selector?('form#login')
    end

    it "when change password" do
      visit 'http://127.0.0.1:8000/auth/change_password'
      within("form#form__change__password") do
        fill_in 'recover_password', with: 'secret'
        fill_in 'password_new', with: '_password'
        fill_in 'password_old', with: 'password'
      end
      submit_form
      expect(page).to have_content 'Your secret is correct, your password changed'
      page.has_selector?('form#form__change__password')
    end

  end

end