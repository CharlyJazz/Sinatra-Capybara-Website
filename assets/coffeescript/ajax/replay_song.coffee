$('audio').on 'play', ->
  id_song = $(this).attr('data-id')
  that = this
  $.ajax(
    url: '/music/song/replay'
    type: 'POST'
    dataType: 'json'
    data: id: id_song).done((response) ->
    if response.error
      $('#modal1').modal 'open'
      $('.modal-flash-description').text response.error
    else if response.replay
      $(that).parent().find('#song-replay').html '<i class=\'material-icons\'>play_arrow</i>' + response.replay
    return
  ).fail(->
    console.log 'error'
    return
  ).always ->
    console.log 'complete'
    return
  return