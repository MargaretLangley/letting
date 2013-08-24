$( document ).ready(function() {

  $('.add').click(function(event) {
    event.preventDefault();
    var selection = $(this).closest('.selection');
    selection.find(':hidden:first').slideToggle('fast');
    if(selection.find(':hidden').length > 0) {
      // todo
    } else {
      $(this).addClass('disabled');
      // note disabled class is in forms.css.scss unless brighter idea
    }
  });

});

