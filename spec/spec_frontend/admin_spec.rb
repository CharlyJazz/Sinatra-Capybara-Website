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
      Capybara.default_wait_time = 5
      before_create_admin("admin_user", "admin@gmail.com", "random1", "admin_secret")
      before_create_songs 7
      before_create_users 7
    end

    it "when delete records" do
      action_login("admin@gmail.com", "random1")
      visit '/admin/user'
      4.times do | n |
        find(:css, 'input#filled-in-' + (n + 1).to_s).set(true)
      end
      find(:css, 'a.delete-model > i.material-icons').click
    end

  end

end