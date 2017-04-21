require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Auth Front-End' do
  def app
    AuthController
  end

  describe "\ntry register with dates used,\n # login,\n # change password process:", :type => :feature do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_max_wait_time = 0
      before_create_user(:username => "charlytester", :email => "charlytester@gmail.com",
                         :password => "password", :amount => 1, :role => "user")
      before_create_social 4
    end

    it "when register" do
      visit '/auth/register'
      within("form#form__register") do
        fill_in 'username', with: Forgery(:internet).user_name
        fill_in 'email', with: Forgery(:email).address
        fill_in 'password', with: Forgery(:basic).password
        fill_in 'recover_password', with: Forgery(:lorem_ipsum).words(5)
      end
      submit_form
      expect(page).to have_content 'User successfully signed!'
      page.has_selector?('form#form__register')
    end

    it "when login" do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Setting')
      within("form#setting-form-personal") do
        fill_in 'email', with: 'charlytester@gmail.com'
        fill_in 'password', with: 'password'
      end
      submit_form
      expect(page).to have_content 'User successfully logged'
      page.has_selector?('form#login')
    end

    it 'when change media images' do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Setting')
      click_link('Media')      
      within('form#setting-form-media') do
        attach_file("image_profile", File.absolute_path('./assets/images/songs/default_song.png'), { make_visible: true })
        attach_file("image_banner", File.absolute_path('./assets/images/songs/default_song.png'), { make_visible: true })        
      end
      click_button("Change images")
      expect(page).to have_content 'Your media was updated successfully'
    end
  
    it "when change password" do
      visit '/auth/change_password'
      within("form#form__change__password") do
        fill_in 'recover_password', with: 'secret'
        fill_in 'password_new', with: '_password'
        fill_in 'password_old', with: 'password'
      end
      submit_form
      expect(page).to have_content 'Your secret is correct, your password changed'
      page.has_selector?('form#form__change__password')
    end

    it "when setting personal info" do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Setting')
      within("form#setting-form-personal") do
        fill_in 'display_name', with: Forgery(:internet).user_name
        fill_in 'first_name', with: Forgery(:name).first_name
        fill_in 'last_name', with: Forgery(:name).last_name
        fill_in 'country', with: Forgery(:address).country
        fill_in 'city', with: Forgery(:address).city
        fill_in 'bio', with: Forgery(:lorem_ipsum).words(5)
      end
      submit_form
      click_link('charlytester')
      click_link('Setting')
      within("form#setting-form-personal") do
        fill_in 'display_name', with: Forgery(:internet).user_name
      end
      submit_form
      expect(page).to have_content 'New personal information!'
    end

    it "when setting social info" do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Setting')
      click_link('Social')
      within("form#setting-form-social") do
        4.times do | x |
          find(:css, 'i.add-social-field.material-icons').click
          if x == 4 - 1 then find(:css, "a[data-id='remove-4']").click end
        end
        3.times do | x |
          fill_in "social_url[#{x + 5}]", with: "https://webpage.com/" + Forgery(:internet).user_name
          fill_in "social_name[#{x + 5}]", with: Forgery(:lorem_ipsum).word
        end
      end
      submit_form
      expect(page).to have_content 'New social information!'
    end

    it "when delete social info" do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Setting')
      click_link('Social')
      within("form#setting-form-social") do
        2.times do | x |
          find(:css, "a[data-id='remove-" + (x + 1).to_s + "']").click
        end
      end
      visit '/auth/setting'
      click_link('Social')
      expect(page).to have_selector('a.remove_field', count: 2)
    end

    it "when change profile image in profile/" do
      action_login("charlytester@gmail.com", "password")
      first(:linkhref, '#modal-change-image').click
      within("form#form-media-profile") do
        attach_file("file", File.absolute_path('./assets/images/songs/default_song.png'), { make_visible: true })
      end
      click_button("Upload image")
      wait_for_ajax
    end

    it "when change banner image in profile/" do
      action_login("charlytester@gmail.com", "password")
      all(:linkhref, '#modal-change-image').last.click
      within("form#form-media-profile") do
        attach_file("file", File.absolute_path('./assets/images/songs/default_song.png'), { make_visible: true })
      end
      click_button("Upload image")
      wait_for_ajax
    end

  end

end
