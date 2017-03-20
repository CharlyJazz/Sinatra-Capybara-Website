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

  describe "the change password proccess:", :type => :feature do

      it 'when get change_password' do
        get '/change_password'
        expect(last_response.body).to_not eq("")
        expect(last_response).to be_ok
      end

      it "when fill a form" do
          visit '/change_password'
          within('#form__change__password') do
            fill_in 'recover_password', with: 'my secret is...secret'
            fill_in 'password_old', with: '123456'
            fill_in 'password_new', with: '654321'
          end
          selector('#any_class').click
          expect(last_response.body).to_not eq("")
          expect(page).to have_content "Yours dates not are corrects"
     end

  end
  
end
