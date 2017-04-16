module FormHelpers
  
  def submit_form
    find('button[type="submit"]').click
  end

  Capybara.add_selector(:linkhref) do
    xpath {|href| ".//a[@href='#{href}']"}
  end

end