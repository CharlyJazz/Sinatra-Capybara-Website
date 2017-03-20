require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Website' do
  def app
    AuthController
  end

  it 'when get login' do
    get '/'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end
  
  it 'when get profile with id 1' do
    get '/profile/1'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end

  it 'when get change_password' do
    get '/change_password'
    expect(last_response.body).to_not eq("")
    expect(last_response).to be_ok
  end

  describe "login and change password process:", :type => :feature do
    # BUG 
     before do
      Capybara.default_driver = :selenium
     end
      it "when login" do
        visit '/'
        within("form#login") do
          fill_in 'email', with: 'charlytester@gmail.com'
          fill_in 'password', with: 'tester'
        end
        click_button 'action'
        expect(page).to have_content 'User successfully logged'
        page.has_selector?('form#login')
      end

    it "when get a form" do
        visit '/change_password'
        page.has_selector?('form#form__change__password')
    end
  end
end