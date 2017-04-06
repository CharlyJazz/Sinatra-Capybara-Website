require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Website' do
  def app
    AdminController
  end

  describe "\nAdmin CRUD process:", :type => :feature do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_max_wait_time = 8
      before_create_admin("admin_user", "admin@gmail.com", "random", "admin_secret")
      before_create_songs 7
      before_create_users 7
    end

    it "when delete song records" do
      action_login("admin@gmail.com", "random")
      visit '/admin'
      click_link('User')
      page.execute_script "$('#input-hidden-id-models').show()"
      4.times do | n |
        within('.form-checkbox-' + (n + 1).to_s) do
          find('[for=filled-in-' + (n + 1).to_s + ']').click
        end
      end
      find(:css, 'a.delete-model > i.material-icons', wait: 10).click
      visit '/admin'
      click_link('User')      
      expect(page).to have_selector('tr.tr-model', count: 3)
    end

    it "when delete song records" do
      action_login("admin@gmail.com", "random")
      visit '/admin'
      click_link('Song')
      page.execute_script "$('#input-hidden-id-models').show()"
      4.times do | n |
        within('.form-checkbox-' + (n + 1).to_s) do
          find('[for=filled-in-' + (n + 1).to_s + ']').click
        end
      end
      find(:css, 'a.delete-model > i.material-icons', wait: 10).click
      visit '/admin'
      click_link('Song')      
      expect(page).to have_selector('tr.tr-model', count: 3)
    end

  end

end