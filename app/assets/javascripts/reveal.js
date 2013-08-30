$( document ).ready(function() {

  $('.add').click(function(event) {
    event.preventDefault();
    var selection = $(this).closest('.selection');
    selection.children('.revealable:hidden:first').slideToggle('fast')

    // requery to see if there are any hidden left
    if(selection.children('.revealable:hidden:first').length > 0) {
      // todo
    } else {
      $(this).addClass('disabled');
      // note disabled class is in forms.css.scss unless brighter idea
    }
  });

  $('.toggle').click(function(event) {
    event.preventDefault();
    var selection = $(this).closest('.selection');
    selection.children('.togglable').slideToggle('fast')

  });

  $('.remove_fields').click(function(event) {
    event.preventDefault();
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('.selection').slideToggle('fast')
  });

});

