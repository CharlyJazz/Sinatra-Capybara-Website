$('#form-comment').validate
  rules:
    comment:
      required: true
      maxlength: 100
      minlength: 5
  invalidHandler: (form, validator) ->
    errors = validator.numberOfInvalids()
    if errors
      $('#modal1').modal 'open'
      $('.modal-flash-description').text "Your are " + errors + " errors"
    return
  submitHandler: (form) ->
    $.post(
      url: $('#form-comment').attr("action")
      dataType: 'json'
      data:
       comment: $('#form-comment input[name="comment"]').val()
    ).done((response) ->
      if response.error
        $('#modal1').modal("open")
        $(".modal-flash-description").text(response.error)
      else if response.success
        if $(".no-exist") then $(".no-exist").css("display", "none");

        $('.collection.comments').append("<li class='collection-item avatar'> \
                                           <span class='title'>" + " You now: " + response.success + "</span> \
                                          </li>")
        $('#form-comment input[name="comment"]').val("")                                
      return
    ).fail(->
      console.log 'error'
      return
    ).always ->
      console.log 'complete'
      return # end ajax
    return false