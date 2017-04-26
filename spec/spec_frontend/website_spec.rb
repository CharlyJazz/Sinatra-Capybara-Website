require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Website Front-End' do
  def app
    WebsiteController
  end
  
  describe "visit main pages", :type => :feature do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_max_wait_time = 0
    end
    describe "visit pages with records creates", :type => :feature do
      before :each do
        before_create_user(:username => "admin_user", :email => "admin@gmail.com", :password => "password", :amount => 1, :role => "admin")
        before_create_song 5
        before_create_album 4
        before_create_comment_song 4, 2, 1
      end
      it "when visit home page" do
        visit '/'
        expect(page).to have_selector('div.sound_body', count: 5)
        expect(page).to have_selector('li.album', count: 4)
        expect(page).to have_selector('li.last-comment', count:4)
      end
    end

    describe "visit pages without records", :type => :feature do
      before :each do
        before_create_user(:username => "admin_user", :email => "admin@gmail.com", :password => "password", :amount => 1, :role => "admin")
      end
      it "when visit home page" do
        visit '/'
        expect(page).to have_content 'No have songs..'
        expect(page).to have_content 'No have albums..'
        expect(page).to have_content 'No have comments..'
      end
    end    

    # it "when no have comment" do
    
    # end

  end
end