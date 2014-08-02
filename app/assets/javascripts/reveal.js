

$( document ).ready(function() {

  $('.js-reveal-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-toggle-selection')
           .children('.js-revealable:hidden:first')
           .slideToggle('fast');
  });

  // Hiding a link
  // We apply a visual affect and clear the fields for reuse.

  $('.js-hide-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-toggle-selection').slideToggle('fast');
    $(this).closest('.js-toggle-selection').find('.js-clear').val('');
  });

  // Destroying a link - we set the _destroy field to true and
  // add visual affects of our choosing

  $('.js-destroy-link').click(function(event) {
    event.preventDefault();
    // previous hidden should be a _destroy field
    $(this).prev('input[type=hidden]').val('1')
    // visual affects
    $(this).closest('.js-toggle-selection').slideToggle('fast');
    $(this).closest('.js-toggle-selection').find('.js-clear').prop('disabled', true)
  });
});
