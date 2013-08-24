$( document ).ready(function() {

  $('.add').click(function(event) {
    event.preventDefault();
    $(this).closest('.selection').find(':hidden:first').slideToggle('fast');
  });

});

