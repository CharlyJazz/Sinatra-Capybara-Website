  max_fields = 10
  wrapper = $('.input_fields_wrap')
  add_button = $('.add_field_button')
  x = 1
  $(add_button).click (e) ->
    e.preventDefault()
    if x < max_fields
      x++
      $(wrapper).append '<div class="col s12">
                            <div class="input-field col s3">
                                <input name="social_url['+x+']" type="text" class="validate">
                            </div>
                            <div class="input-field col s3">
                                <input name="social_name['+x+']" type="text" class="validate">
                            </div>
                            <a href="#" class="btn waves-effect waves-light remove_field">Remove</a></div>
                         </div>'
    return
  $(wrapper).on 'click', '.remove_field', (e) ->
    e.preventDefault()
    $(this).parent('div').remove()
    x--
    return