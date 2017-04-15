$('#user_create_album').validate
  rules:
    name: required: true
    songs_id: required: true
    date: required: true
    description: required: true
    file:
      extension: 'png|jpg|jpeg'
      required: false
  messages:
    file:
      extension: "Only images in png, jpg or jpeg"
    name: "Your song need a name!"
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
      arr_tag.push(chip.tag)
    $("#input-hidden-tag-album").val(arr_tag.toString())

    if $('#user_create_album').attr("action").indexOf.call($('#user_create_album').attr("action"), "?mode=all") >= 0

      $("button[type='submit']").prop('disabled', true); # Very import
      
      $.ajax($('#user_create_album').attr('action'),
        type: 'POST'
        dataType: 'json'
        data:
            name: $('input[name=name]').val()
            description: $('input[name=description]').val()
            date: $('input[name=date]').val()
            tags: $('input[id=input-hidden-tag-album]').val()
            songs_id_delete: $('[id=input-hidden-id-song-delete]').val()
            songs_id: $('input[id=input-hidden-id-song]').val()).done((response) ->
        if response.error
            $('#modal1').modal("open")
            $(".modal-flash-description").text(response.error)
        else if response.album_id
          location.href = '/music/album/' + response.album_id
        return
      ).fail(->
        console.log 'error'
        return
      ).always ->
        console.log 'complete'
        return # end ajax
      return false
    else
      form.submit()