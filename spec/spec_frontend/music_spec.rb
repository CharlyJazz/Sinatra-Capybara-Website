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
      before_create_user(:username => "charlytester", :email => "charlytester@gmail.com",
                         :password => "password", :amount => 1, :role => "user")
      before_create_song 5
      before_create_album 1
    end

    it "when have songs in the profile" do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Profile')
      click_link('Tracks')
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector('div.song__wrapper', count: 5)
    end

    it "when delete any song in profile" do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Profile')
      click_link('Tracks')
      find("a[data-id-song='1']").click
      click_button('Yes, delete')
      click_link('Tracks')
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector('div.song__wrapper', count: 4)
    end

    it "when delete any song in song/" do
      action_login("charlytester@gmail.com", "password")
      visit '/music/song/1'
      find(:css, 'a.pre-delete-song').click
      click_button('Yes, delete')
      expect(page).to have_content 'Song deleted'
      expect(Song.all.length).to eq 4
    end

    it 'when create any song' do
      # This spec are failed...i dont have any idea why      
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Upload')
      within("form#user_create_song") do
        attach_file("file", File.absolute_path('./sound_test/maindrum.wav'), { make_visible: true })  
        fill_in 'title', with: Forgery(:internet).user_name
        fill_in 'description', with: Forgery(:lorem_ipsum).words(10)
        fill_in 'genre', with: "Rock"
      end
      submit_form
      expect(page).to have_content 'Successfully created...'
    end

    it 'when edit any song' do
      # This spec are failed...i dont have any idea why
      action_login("charlytester@gmail.com", "password")
      click_link('Tracks')
      find(:linkhref, '/music/song/1').click
      find(:linkhref, '/music/edit/song/1').click
      within("form#user_create_song") do
        fill_in 'title', with: Forgery(:internet).user_name
        fill_in 'description', with: Forgery(:lorem_ipsum).words(10)
        fill_in 'genre', with: "Vaporwave"
        page.execute_script '$("div.select-wrapper > ul > li:nth-child(3)").click()'
      end
      submit_form
      wait_for_ajax
      expect(page).to have_content 'Vaporwave'
    end

    it "when create album" do
      action_login("charlytester@gmail.com", "password")
      visit '/music/create/album'
      5.times do | n |
        find("a[data-id-song='" + (n + 1).to_s+ "']").click
      end
      within("form#user_create_album") do
        attach_file("file", File.absolute_path('./assets/images/songs/default_song.png'), {make_visible: true }) 
        fill_in 'name', with: Forgery(:internet).user_name
        find_field('date').click()
        click_button('Today')
        fill_in 'description', with: Forgery(:lorem_ipsum).words(5)
        page.execute_script "$('#input-hidden-id-song').show()"
        page.execute_script "$('#input-hidden-tag-album').show()"
        page.execute_script "$('.chips').material_chip({data:[{tag:'Apple'},{tag:'Microsoft'},{tag:'Google'}]});"
      end
      submit_form
      expect(page).to have_content 'New album created!'
    end

    it "when delete any album in album/" do
      action_login("charlytester@gmail.com", "password")
      visit '/music/album/1'
      find(:css, 'a.pre-delete-album').click
      click_button('Yes, delete')
      expect(page).to have_content 'Album deleted'
      expect(Album.all.length).to eq 0
      expect(AlbumTag.all.length).to eq 0      
    end

    it "when delete any album in profile/" do
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Profile')
      click_link('Albums')
      find("a[data-id-album='1']").click
      click_button('Yes, delete')
      click_link('Albums')
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector('div.album_wrapper', count: 0)
    end

    it "when edit any album" do
      # This spec are failed...i dont have any idea why
      action_login("charlytester@gmail.com", "password")
      click_link('charlytester')
      click_link('Profile')
      click_link('Albums')
      page.execute_script "window.scrollBy(0,10000)"
      find(:linkhref, '/music/album/1').click
      find(:linkhref, '/music/edit/album/1').click
      5.times do | n |
        find("a[data-id-song='" + (n + 1).to_s+ "']").click
      end      
      within("form#user_create_album") do
        fill_in 'name', with: "New Album Name"
        find_field('date').click()
        click_button('Today')
        fill_in 'description', with: Forgery(:lorem_ipsum).words(20)
      end
      submit_form
      wait_for_ajax
      expect(page).to have_content 'New Album Name'
    end        
  end
end
