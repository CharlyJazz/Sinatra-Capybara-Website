$('#setting-form-personal').validate
  rules:
    display_name: required: true
    first_name: required: true
    last_name: required: true
    country: 
      required: true
      number: false
    city: required: true
    date: required: true
    bio: required: true
  messages:
    display_name: "Write you display name!"
    first_name: required: "Write you first name!"
    last_name: required: "Write you last name"
    country: required: "Write you country"
    city: required: "Write your city"
    bio: required: "Write any litle bio"
  invalidHandler: (form, validator) ->
    errors = validator.numberOfInvalids()
    if errors
      $('#modal1').modal 'open'
      $('.modal-flash-description').text "Your have " + errors + " errors"
    return
  submitHandler: (form) ->
    form.submit()
    return  