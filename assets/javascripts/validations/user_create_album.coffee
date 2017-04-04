$("#user_create_album").submit (e) ->
  arr_fields = new Array(
    name = $("#user_create_album input[name='name']"),
    file = $("#user_create_album input[name='file']"),
    songs_id = $("#user_create_album input[name='songs_id']"),
    tags = $("#user_create_album input[name='tags']"),
    date = $("#user_create_album input[name='date']"),
    description = $("#user_create_album input[name='description']"),
    file = $("#user_create_album input[name='file']"))
  
  for field in arr_fields
    if not field.val() and field != tags
       $('#modal1').modal("open")
       $(".modal-flash-description").text("Any field are empty");  
       return false

  arr_tag = new Array()
  chips_form = $(".chips").material_chip('data')
  for chip in chips_form
    console.log chip.tag
    arr_tag.push(chip.tag)
  $("#input-hidden-tag-album").val(arr_tag.toString())

