$('#user_create_song').validate
  rules:
    title: required: true
    file:
      required: false
      extension: 'mp3|mpeg|mp4|wav|midi'
    description: required: true
    genre: required: true
    type: required: true
    license: required: true
  messages:
    file:
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
    # Ajax call only if edit song
    if $('#user_create_song').attr("action").indexOf.call($('#user_create_song').attr("action"), "?mode=all") >= 0

      $("button[type='submit']").prop('disabled', true); # Very import

      $.ajax($('#user_create_song').attr('action'),
        type: 'POST'
        dataType: 'json'
        data:
          title: $('input[name=title]').val()
          description: $('input[name=description]').val()
          license: $('select[name=license]').val()
          type: $('select[name=type]').val()
          genre: $('input[name=genre]').val()).done((response) ->
        if response.error
            $('#modal1').modal("open")
            $(".modal-flash-description").text(response.error)
        else if response.song_id
            location.href = '/music/song/' + response.song_id
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