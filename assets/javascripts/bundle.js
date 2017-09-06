/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(1);

__webpack_require__(2);

__webpack_require__(3);

__webpack_require__(4);

__webpack_require__(5);

__webpack_require__(6);

__webpack_require__(7);

$(document).ready(function() {
  $('.scrollspy').scrollSpy();
  $('select').material_select();
  $('#modal-delete-song').modal();
});


/***/ }),
/* 1 */
/***/ (function(module, exports) {

$('.like_song').on('click', function() {
  var id_song, that;
  id_song = $(this).attr('data-id-song');
  that = this;
  $.ajax({
    url: '/music/song/like',
    type: 'POST',
    dataType: 'json',
    data: {
      id: id_song
    }
  }).done(function(response) {
    if (response.error) {
      $('#modal1').modal('open');
      $('.modal-flash-description').text(response.error);
    } else if (response.like) {
      $(that).html("<i class='material-icons'>favorite</i>" + response.like);
    }
  }).fail(function() {
    console.log('error');
  }).always(function() {
    console.log('complete');
  });
});


/***/ }),
/* 2 */
/***/ (function(module, exports) {

$('audio').on('play', function() {
  var id_song, that;
  id_song = $(this).attr('data-id');
  that = this;
  $.ajax({
    url: '/music/song/replay',
    type: 'POST',
    dataType: 'json',
    data: {
      id: id_song
    }
  }).done(function(response) {
    if (response.error) {
      $('#modal1').modal('open');
      $('.modal-flash-description').text(response.error);
    } else if (response.replay) {
      $(that).parent().find('#song-replay').html('<i class=\'material-icons\'>play_arrow</i>' + response.replay);
    }
  }).fail(function() {
    console.log('error');
  }).always(function() {
    console.log('complete');
  });
});


/***/ }),
/* 3 */
/***/ (function(module, exports) {

$('#user_create_album').validate({
  rules: {
    name: {
      required: true
    },
    songs_id: {
      required: true
    },
    date: {
      required: true
    },
    description: {
      required: true
    },
    file: {
      extension: 'png|jpg|jpeg',
      required: false
    }
  },
  messages: {
    file: {
      extension: "Only images in png, jpg or jpeg"
    },
    name: "Your song need a name!",
    date: {
      required: "Your song need a date!"
    },
    description: {
      required: "Your song need a description!"
    }
  },
  invalidHandler: function(form, validator) {
    var errors;
    errors = validator.numberOfInvalids();
    if (errors) {
      $('#modal1').modal('open');
      $('.modal-flash-description').text("Your are " + errors + " errors");
    }
  },
  submitHandler: function(form) {
    var arr_tag, chip, chips_form, i, len;
    arr_tag = new Array();
    chips_form = $(".chips").material_chip('data');
    for (i = 0, len = chips_form.length; i < len; i++) {
      chip = chips_form[i];
      arr_tag.push(chip.tag);
    }
    $("#input-hidden-tag-album").val(arr_tag.toString());
    if ($('#user_create_album').attr("action").indexOf.call($('#user_create_album').attr("action"), "?mode=all") >= 0) {
      $("button[type='submit']").prop('disabled', true);
      $.ajax($('#user_create_album').attr('action'), {
        type: 'POST',
        dataType: 'json',
        data: {
          name: $('input[name=name]').val(),
          description: $('input[name=description]').val(),
          date: $('input[name=date]').val(),
          tags: $('input[id=input-hidden-tag-album]').val(),
          songs_id_delete: $('[id=input-hidden-id-song-delete]').val(),
          songs_id: $('input[id=input-hidden-id-song]').val()
        }
      }).done(function(response) {
        if (response.error) {
          $('#modal1').modal("open");
          $(".modal-flash-description").text(response.error);
        } else if (response.album_id) {
          location.href = '/music/album/' + response.album_id;
        }
      }).fail(function() {
        console.log('error');
      }).always(function() {
        console.log('complete');
      });
      return false;
    } else {
      return form.submit();
    }
  }
});


/***/ }),
/* 4 */
/***/ (function(module, exports) {

$('#form-comment').validate({
  rules: {
    comment: {
      required: true,
      maxlength: 100,
      minlength: 5
    }
  },
  invalidHandler: function(form, validator) {
    var errors;
    errors = validator.numberOfInvalids();
    if (errors) {
      $('#modal1').modal('open');
      $('.modal-flash-description').text("Your are " + errors + " errors");
    }
  },
  submitHandler: function(form) {
    $.post({
      url: $('#form-comment').attr("action"),
      dataType: 'json',
      data: {
        comment: $('#form-comment input[name="comment"]').val()
      }
    }).done(function(response) {
      if (response.error) {
        $('#modal1').modal("open");
        $(".modal-flash-description").text(response.error);
      } else if (response.success) {
        if ($(".no-exist")) {
          $(".no-exist").css("display", "none");
        }
        $('.collection.comments').append("<li class='collection-item avatar'> <span class='title'>" + " You now: " + response.success + "</span> </li>");
        $('#form-comment input[name="comment"]').val("");
      }
    }).fail(function() {
      console.log('error');
    }).always(function() {
      console.log('complete');
    });
    return false;
  }
});


/***/ }),
/* 5 */
/***/ (function(module, exports) {

$('#user_create_song').validate({
  rules: {
    title: {
      required: true
    },
    file: {
      required: false,
      extension: 'mp3|mpeg|mp4|wav|midi'
    },
    description: {
      required: true
    },
    genre: {
      required: true
    },
    type: {
      required: true
    },
    license: {
      required: true
    }
  },
  messages: {
    file: {
      extension: "Only mp3, mpeg, mp4, wav or midi"
    },
    title: "Your song need a title!",
    description: "Your song need a description!",
    genre: {
      required: "Your song need a genre!"
    },
    type: {
      required: "Your song need a type!"
    },
    license: {
      required: "Your song need a license!"
    }
  },
  invalidHandler: function(form, validator) {
    var errors;
    errors = validator.numberOfInvalids();
    if (errors) {
      $('#modal1').modal('open');
      $('.modal-flash-description').text("Your are " + errors + " errors");
    }
  },
  submitHandler: function(form) {
    if ($('#user_create_song').attr("action").indexOf.call($('#user_create_song').attr("action"), "?mode=all") >= 0) {
      $("button[type='submit']").prop('disabled', true);
      $.ajax($('#user_create_song').attr('action'), {
        type: 'POST',
        dataType: 'json',
        data: {
          title: $('input[name=title]').val(),
          description: $('input[name=description]').val(),
          license: $('select[name=license]').val(),
          type: $('select[name=type]').val(),
          genre: $('input[name=genre]').val()
        }
      }).done(function(response) {
        if (response.error) {
          $('#modal1').modal("open");
          $(".modal-flash-description").text(response.error);
        } else if (response.song_id) {
          location.href = '/music/song/' + response.song_id;
        }
      }).fail(function() {
        console.log('error');
      }).always(function() {
        console.log('complete');
      });
      return false;
    } else {
      return form.submit();
    }
  }
});


/***/ }),
/* 6 */
/***/ (function(module, exports) {

$('#setting-form-personal').validate({
  rules: {
    display_name: {
      required: true
    },
    first_name: {
      required: true
    },
    last_name: {
      required: true
    },
    country: {
      required: true,
      number: false
    },
    city: {
      required: true
    },
    date: {
      required: true
    },
    bio: {
      required: true
    }
  },
  messages: {
    display_name: "Write you display name!",
    first_name: {
      required: "Write you first name!"
    },
    last_name: {
      required: "Write you last name"
    },
    country: {
      required: "Write you country"
    },
    city: {
      required: "Write your city"
    },
    bio: {
      required: "Write any litle bio"
    }
  },
  invalidHandler: function(form, validator) {
    var errors;
    errors = validator.numberOfInvalids();
    if (errors) {
      $('#modal1').modal('open');
      $('.modal-flash-description').text("Your have " + errors + " errors");
    }
  },
  submitHandler: function(form) {
    form.submit();
  }
});


/***/ }),
/* 7 */
/***/ (function(module, exports) {

var add_button, input_reset_index, max_fields, validateUrl, wrapper, x;

input_reset_index = function() {
  var count, field, fields, i, len;
  count = 1;
  fields = $("#setting-form-social").find("input");
  for (i = 0, len = fields.length; i < len; i++) {
    field = fields[i];
    if ($(field).attr("class") === "social_url") {
      $(field).attr("name", "social_url[" + count + "]");
    } else if ($(field).attr("class") === "social_name") {
      $(field).attr("name", "social_name[" + count + "]");
      count++;
    }
  }
};

max_fields = 10;

wrapper = $('.input_fields_wrap');

add_button = $('.add_field_button');

x = 1;

$(add_button).click(function(e) {
  e.preventDefault();
  if (x < max_fields) {
    x++;
    $(wrapper).append('<div class="col s12"> <div class="input-field col s3"> <input class="social_url" name="social_url[' + x + ']" type="text" class="validate"> </div> <div class="input-field col s3"> <input class="social_name" name="social_name[' + x + ']" type="text" class="validate"> </div> <a href="#" class="btn waves-effect waves-light remove_field" data-id="none">Remove</a></div> </div>');
  }
  input_reset_index();
});

$(wrapper).on('click', '.remove_field', function(e) {
  var count, id, that;
  e.preventDefault();
  id = $(this).data("id");
  $(this).parent('div').remove();
  x--;
  that = $(this);
  count = 1;
  input_reset_index();
  if (id !== "none") {
    $.ajax('/auth/setting/social/' + id, {
      type: 'DELETE',
      dataType: 'json',
      success: function(resp) {
        if (resp.success) {
          console.log("success " + resp.success);
        }
        if (resp.error) {
          return console.log("error " + resp.error);
        }
      },
      error: function() {
        return console.log("error");
      },
      fail: function() {
        return console.log("fail");
      }
    });
  }
});

validateUrl = function(value) {
  return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[\/?#]\S*)?$/i.test(value);
};

$("#setting-form-social").submit(function(e) {
  var _count, count, field, fields, i, len;
  _count = 1;
  count = 1;
  fields = $("#setting-form-social").find("input");
  input_reset_index();
  for (i = 0, len = fields.length; i < len; i++) {
    field = fields[i];
    if ($(field).attr("name") === "social_url[" + count + "]") {
      if (!$(field).val()) {
        $('#modal1').modal("open");
        $(".modal-flash-description").text("Any field url are empty");
        return false;
      } else if (!validateUrl($(field).val())) {
        $('#modal1').modal("open");
        $(".modal-flash-description").text("Url format invalid in " + $(field).val());
        return false;
      }
    } else if ($(field).attr("name") === "social_name[" + count + "]") {
      if (!$(field).val()) {
        $('#modal1').modal("open");
        $(".modal-flash-description").text("Any field name are empty");
        return false;
      }
      count++;
    }
  }
  return true;
});


/***/ })
/******/ ]);