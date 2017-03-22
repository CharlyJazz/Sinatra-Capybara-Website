#= require validations/song
#= require validations/album
#= require validations/user
$(document).ready ->
  $('.scrollspy').scrollSpy()
  $('select').material_select()
  $('#modal-delete-song').modal();
  return
