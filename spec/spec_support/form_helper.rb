module FormHelpers
  def submit_form
    find('button[type="submit"]').click
  end
end