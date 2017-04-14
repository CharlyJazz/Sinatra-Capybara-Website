$('#user_create_album').validate
  rules:
    name: required: true
    file: required: true
    songs_id: required: true
    tags: required: true
    date: required: true
    description: required: true
    file:
      extension: 'png|jpg|jpeg'
      required: true
  messages:
    file:
      extension: "Only images in png, jpg or jpeg"
    name: "Your song need a name!"
    tags: required: "Your song need a tags!"
    date: required: "Your song need a date!"
    description: required: "Your song need a description!"   
  invalidHandler: (form, validator) ->
    errors = validator.numberOfInvalids()
    if errors
      $('#modal1').modal 'open'
      $('.modal-flash-description').text "Your are " + errors + " errors"
    return
  submitHandler: (form) ->
    arr_tag = new Array()
    chips_form = $(".chips").material_chip('data')
    for chip in chips_form
      console.log chip.tag
      arr_tag.push(chip.tag)
    $("#input-hidden-tag-album").val(arr_tag.toString())
    form.submit()
    return  