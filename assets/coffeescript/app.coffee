require("./ajax/like_song.coffee")
require("./ajax/replay_song.coffee")

require("./validations/user_create_album.coffee")
require("./validations/user_create_comment.coffee")
require("./validations/user_create_song.coffee")
require("./validations/user_personal_setting.coffee")
require("./validations/user_social_setting.coffee")

$(document).ready ->
  $('.scrollspy').scrollSpy()
  $('select').material_select()
  $('#modal-delete-song').modal();
  return
