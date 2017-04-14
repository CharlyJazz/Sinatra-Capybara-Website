$('#user_create_song').validate
  rules:
    title: required: true
    file:
      required: true
      extension: 'mp3|mpeg|mp4|wav|midi'
    description: required: true
    genre: required: true
    type: required: true
    license: required: true
  messages:
    file:
      required: "And the song?"
      extension: "Only mp3, mpeg, mp4, wav or midi"
    title: "Your song need a title!"
    description: "Your song need a description!"
    genre: required: "Your song need a genre!"
    type: required: "Your song need a type!"
    license: required: "Your song need a license!"
  invalidHandler: (form, validator) ->
    errors = validator.numberOfInvalids()
    if errors
      $('#modal1').modal 'open'
      $('.modal-flash-description').text "Your are " + errors + " errors"
    return
  submitHandler: (form) ->
    form.submit()
    return  