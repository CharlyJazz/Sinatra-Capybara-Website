$('.like_song').on 'click', ->
  id_song = $(this).attr('data-id-song')
  that = this
  $.ajax(
    url: '/music/song/like'
    type: 'POST'
    dataType: 'json'
    data: id: id_song).done((response) ->
    if response.error
      $('#modal1').modal 'open'
      $('.modal-flash-description').text response.error
    else if response.like
      $(that).html "<i class='material-icons'>favorite</i>" + response.like
    return
  ).fail(->
    console.log 'error'
    return
  ).always ->
    console.log 'complete'
    return
  return