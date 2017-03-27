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
                              <input class="social_url" name="social_url['+x+']" type="text" class="validate">
                          </div>
                          <div class="input-field col s3">
                              <input class="social_name" name="social_name['+x+']" type="text" class="validate">
                          </div>
                          <a href="#" class="btn waves-effect waves-light remove_field remove-'+x+'">Remove</a></div>
                       </div>'
  return


$(wrapper).on 'click', '.remove_field', (e) ->
  e.preventDefault()
  id_social = $(this).data("id")
  $(this).parent('div').remove()
  x--
  # Reset x for correct index for a validation
  fields = $("#setting-form-social").find("input")
  count = 1
  for field in fields
    if $(field).attr("class") == "social_url"
      $(field).attr("name", "social_url[" + count + "]")
    else if $(field).attr("class") == "social_name"
      $(field).attr("name", "social_name[" + count + "]")
      count++
  console.log id_social.substring(id_social.indexOf('-') + 1) # ID
  return


validateUrl = (value) -> 
  return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(value);


$("#setting-form-social").submit (e) ->
  fields = $("#setting-form-social").find("input")
  _count = 1 
  count = 1

  for field in fields
    if $(field).attr("class") == "social_url"
      $(field).attr("name", "social_url[" + _count + "]")
    else if $(field).attr("class") == "social_name"
      $(field).attr("name", "social_name[" + _count + "]")
      _count++

  for field in fields
    if $(field).attr("name") == "social_url[" + count + "]"
      if not $(field).val()
        $('#modal1').modal("open")
        $(".modal-flash-description").text("Any field url are empty");
        return false
         
      else if !validateUrl $(field).val()
        $('#modal1').modal("open")
        $(".modal-flash-description").text("Url format invalid in " + $(field).val() );  
        return false

    else if $(field).attr("name") == "social_name[" + count + "]"
      if not $(field).val()
        $('#modal1').modal("open")
        $(".modal-flash-description").text("Any field name are empty");
        return false

      count++
  return true