#= require validations/user_social_setting
#= require validations/user_personal_setting
#= require validations/user_create_album
#= require validations/user_create_song
#= require validations/user_create_comment

#= require ajax/replay_song
#= require ajax/like_song

$(document).ready ->
  $('.scrollspy').scrollSpy()
  $('select').material_select()
  $('#modal-delete-song').modal();
  return
