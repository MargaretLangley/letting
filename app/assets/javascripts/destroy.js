
$( document ).ready(function() {
  $('.remove-fields').click(function(event) {
    event.preventDefault();
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('.selection').slideToggle('fast')
  });
});