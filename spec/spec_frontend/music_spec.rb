require 'spec_helper'
require 'rack/test'
require 'capybara/rspec'

RSpec.describe 'Website' do
  def app
    MusicController
  end

  describe "\nTracks, Albumes, Tracks Likes in the profile:", :type => :feature do
    before do
      Capybara.default_driver = :selenium
      Capybara.default_max_wait_time = 5
      before_create_user(:username => "charlytester", :email => "charlytester",
                         :password => "password", :amount => 1, :role => "user")
      before_create_songs 5
    end

    # it "when have songs in the profile" do
    #   action_login("charlyjazzc1@gmail.com", "password")
    #   click_link('charlytester')
    #   click_link('Profile')
    #   click_link('Tracks')
    #   page.execute_script "window.scrollBy(0,10000)"
    #   expect(page).to have_selector('div.song__wrapper', count: 5)
    # end

    # it "when delete any song in profile" do
    #   action_login("charlyjazzc1@gmail.com", "password")
    #   click_link('charlytester')
    #   click_link('Profile')
    #   click_link('Tracks')
    #   find("a[data-id-song='1']").click
    #   click_button('Yes, delete')
    #   click_link('Tracks')
    #   page.execute_script "window.scrollBy(0,10000)"
    #   expect(page).to have_selector('div.song__wrapper', count: 4)
    # end

    it "when delete any song in play" do
      action_login("charlyjazzc1@gmail.com", "password")
      visit '/music/song/1'
      find(:css, 'a.pre-delete-song').click
      click_button('Yes, delete')
      expect(page).to have_content 'Song deleted'
    end

    # it "when create album" do
    #   action_login("charlyjazzc1@gmail.com", "password")
    #   visit '/music/create/album'
    #   5.times do | n |
    #     find("a[data-id-song='" + (n + 1).to_s+ "']").click
    #   end
    #   within("form#user_create_album") do
    #     attach_file("file", File.absolute_path('./assets/images/songs/default_song.png'), {make_visible: true }) 
    #     fill_in 'name', with: Forgery(:internet).user_name
    #     find_field('date').click()
    #     click_button('Today')
    #     fill_in 'description', with: Forgery(:lorem_ipsum).words(5)
    #     page.execute_script "$('#input-hidden-id-song').show()"
    #     page.execute_script "$('#input-hidden-tag-album').show()"
    #     page.execute_script "$('.chips').material_chip({data:[{tag:'Apple'},{tag:'Microsoft'},{tag:'Google'}]});"
    #   end
    #   submit_form
    #   expect(page).to have_content 'New album created!'
    # end
  end
end
